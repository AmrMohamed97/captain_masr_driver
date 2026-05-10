import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/imports/imports.dart';
import '../../../driver_trip/data/repo/driver_trip_repo.dart';
import '../../../my_vehicle/data/models/seat_model.dart';
import '../../../my_vehicle/data/models/vehicle_category_model.dart';
import '../../../my_vehicle/data/repo/vehicle_repo.dart';
import '../../../pick_location/data/models/selected_location_model.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';
// import '../../../rider_trip/data/repo/rider_trip_repo.dart';
import '../../data/repo/schedule_trip_repo.dart';
import '../../data/models/trip_estimation_model.dart';

part 'schedule_trip_state.dart';

class ScheduleTripCubit extends Cubit<ScheduleTripState> {
  ScheduleTripCubit({
    required bool isRider,
    this.postedTrip,
    bool? isPostedTrip,
  }) : super(ScheduleTripInitial()) {
    if (isPostedTrip != true) {
      getSeats();
    }
  }

  TripDetailsModel? postedTrip;

  //! Requests Realtime
  DatabaseReference? dbTripDetails;
  StreamSubscription<DatabaseEvent>? dbSubscription;
  List<TripDetailsModel> newRequests = [];
  List<TripDetailsModel> acceptedRequests = [];

  //! Today Status Realtime
  DatabaseReference? dbTodayStatus;
  StreamSubscription<DatabaseEvent>? dbTodayStatusSubscription;
  String? realtimeTodayStatus;
  String? driverStatus;

  /// Returns the most up-to-date todayStatus: realtime Firebase value if available,
  /// otherwise falls back to the value from the initial trip model.
  String? get effectiveTodayStatus => realtimeTodayStatus ?? postedTrip?.status;

  // void initStatus() {
  //   realtimeTodayStatus = postedTrip?.todayStatus;
  // }

  Future<void> initRequestsRealTime({required bool isRider}) async {
    if (postedTrip != null && isRider) {
      return;
    }
    dbTripDetails =
        FirebaseDatabase.instance.ref("share_trips/${postedTrip!.id}");

    dbSubscription = dbTripDetails?.onValue.listen((event) {
      try {
        final data = event.snapshot.value as Map?;
        // if (!kReleaseMode) log("Trip: ${data.toString()}");

        if (data != null) {
          postedTrip = TripDetailsModel.fromJson(data)
            ..requests = data['requests'] != null
                ? (data['requests'] is List)
                    ? (data['requests'] as List)
                        .where((element) => element != null)
                        .map((e) => TripDetailsModel.fromJson(e))
                        .toList()
                    : (data['requests'] as Map)
                        .map((key, value) {
                          return MapEntry(
                              key, TripDetailsModel.fromJson(value));
                        })
                        .values
                        .toList()
                : []
            ..riders = data['riders'] != null
                ? (data['riders'] is List)
                    ? (data['riders'] as List)
                        .where((element) => element != null)
                        .map((e) => TripDetailsModel.fromJson(e))
                        .toList()
                    : (data['riders'] as Map)
                        .map((key, value) {
                          return MapEntry(
                              key, TripDetailsModel.fromJson(value));
                        })
                        .values
                        .toList()
                : [];

          newRequests = postedTrip?.requests ?? [];
          acceptedRequests = postedTrip?.riders ?? [];
          update();
        }
      } catch (e) {
        if (!kReleaseMode) log("Error on Add: $e");
      }
    });
  }

  //! Today Status Realtime Listener
  void initTodayStatusRealTime(bool isRider) {
    if (postedTrip?.id == null) return;
    

    // if (!isRider) {
    dbTodayStatus = FirebaseDatabase.instance.ref(
      "share_trips/${postedTrip!.id}/status",
    );
    // } else {
    //   dbTodayStatus = FirebaseDatabase.instance.ref(
    //     "share_trips/${postedTrip!.id}/riders/${riderId!}/status",
    //   );
    // }
    // print("====================trip id======================================");
    // print("postedTrip!.id: ${postedTrip!.id}");
    if (isRider) {
      dbTodayStatusSubscription = dbTodayStatus?.onValue.listen((event) {
      try {
        final data = event.snapshot.value;
        // if (!kReleaseMode) log("Today Status: $data");

        if (data != null) {
          print('data=================#######===============================');
          print(data);
          driverStatus = data.toString();
          emit(TodayStatusChangedState());
        }
      } catch (e) {
        if (!kReleaseMode) log("Error on Today Status listener: $e");
      }
    });
    }
    else{dbTodayStatusSubscription = dbTodayStatus?.onValue.skip(1).listen((event) {
      try {
        final data = event.snapshot.value;
        // if (!kReleaseMode) log("Today Status: $data");

        if (data != null) {
          print('data=================#######===============================');
          print(data);
          realtimeTodayStatus = data.toString();
          emit(TodayStatusChangedState());
        }
      } catch (e) {
        if (!kReleaseMode) log("Error on Today Status listener: $e");
      }
    });}
  }

  void initTodayRiderStatusRealTime({bool isRider = false, int? riderId}) {
    if (postedTrip?.id == null) return;
    if (!isRider) return;

    dbTodayStatus = FirebaseDatabase.instance.ref(
      "share_trips/${postedTrip!.id}/riders/${riderId!}/status",
    );
    // print("====================trip id======================================");
    // print("postedTrip!.id: ${postedTrip!.id}");

    dbTodayStatusSubscription = dbTodayStatus?.onValue.skip(1).listen((event) {
      try {
        final data = event.snapshot.value;
        // if (!kReleaseMode) log("Today Status: $data");

        if (data != null) {
          print('data=================#######===============================');
          print(data);
          realtimeTodayStatus = data.toString();
          emit(TodayStatusChangedState());
        }
      } catch (e) {
        if (!kReleaseMode) log("Error on Today Status listener: $e");
      }
    });
  }

  Future<void> driverPostTrip() async {
    print('================================');
    print(
      startTime != null
          ? "${startTime!.hour.toString().padLeft(2, "0")}:${startTime!.minute.toString().padLeft(2, "0")}"
          : "",
    );
    emit(ScheduleTripLoadingState());
    final response = await sl<ScheduleTripRepo>().driverPostTrip(
      pickupAddress: startLocation?.address ?? '',
      pickupLatitude: startLocation?.lat ?? 0,
      pickupLongitude: startLocation?.lon ?? 0,
      dropoffAddress: endLocation?.address ?? '',
      dropoffLatitude: endLocation?.lat ?? 0,
      dropoffLongitude: endLocation?.lon ?? 0,
      seatsCount: selectedSeatsIds.length,
      availableSeetsId: selectedSeatsIds,
      dateFrom: formateDate(fromDate) ?? '',
      dateTo: formateDate(toDate) ?? '',
      time: startTime != null
          ? "${startTime!.hour.toString().padLeft(2, "0")}:${startTime!.minute.toString().padLeft(2, "0")}"
          : "",
      description: '',
      type: 'round_trip',
    );
    response.fold(
      (error) => emit(ScheduleTripErrorState(error)),
      (model) => emit(DriverPostScheduleTripSuccessState(trip: model)),
    );
  }

  //! Driver Start Schedule Trip
  Future<void> driverStartScheduleTrip() async {
    emit(ScheduleTripLoadingState());
    final response = await sl<DriverTripRepo>().startShareTrip(
      tripId: postedTrip!.id!,
    );
    response.fold(
      (error) => emit(ScheduleTripErrorState(error)),
      (message) => emit(DriverStartScheduleTripSuccessState(
        message: message,
        tripId: postedTrip!.id!,
      )),
    );
  }

  //! Driver Cancel Trip
  Future<void> driverCancelTrip({required String reason}) async {
    emit(ScheduleTripLoadingState());
    final response = await sl<DriverTripRepo>().driverCancelShareTrip(
      tripId: postedTrip!.id!,
    );
    response.fold(
      (error) => emit(ScheduleTripErrorState(error)),
      (message) => emit(DriverCancelScheduleSuccess(message: message)),
    );
  }

  //! Driver Cancel All Schedule Trip
  Future<void> driverCancelAllScheduleTrip({
    required List<String> reason,
    required String notes,
  }) async {
    emit(ScheduleTripLoadingState());
    final response = await sl<ScheduleTripRepo>().driverCancelAllScheduleTrip(
      tripId: postedTrip!.id!,
      cancelReasons: reason,
      notes: notes,
    );
    response.fold(
      (error) => emit(ScheduleTripErrorState(error)),
      (message) => emit(DriverCancelScheduleSuccess(
        message: message,
      )),
    );
  }

  //! Driver Cancel Rider Schedule Trip
  Future<void> driverCancelScheduleTripForRider({
    required int riderId,
    required List<String> reason,
    required String notes,
  }) async {
    emit(ScheduleTripLoadingState());
    final response =
        await sl<ScheduleTripRepo>().driverCancelScheduleTripForRider(
      tripId: riderId,
      cancelReasons: reason,
      notes: notes,
    );
    response.fold(
      (error) => emit(ScheduleTripErrorState(error)),
      (message) => emit(ScheduleTripSuccessState(message: message)),
    );
  }

  //! Decline Rider Request
  Future<void> declineRiderRequest({required int requestId}) async {
    emit(ScheduleTripLoadingState());
    final response = await sl<DriverTripRepo>().driverCancelShareTrip(
      tripId: requestId,
    );
    response.fold(
      (error) => emit(ScheduleTripErrorState(error)),
      (message) => emit(ScheduleTripSuccessState(message: message)),
    );
  }

  //! Vehicle Categories
  int? selectedVehicleCategoryId;
  List<VehicleCategoryModel> vehicleCategories = [];
  Future<void> getVehicleCategories() async {
    final result = await sl<VehicleRepo>().tripVehicleCategories(
      tripId: 1,
    );
    result.fold(
      (error) => emit(ScheduleTripErrorState(error)),
      (list) {
        vehicleCategories = list;
        if (vehicleCategories.isNotEmpty) {
          selectedVehicleCategoryId = vehicleCategories.first.id;
        }
        emit(ScheduleTripSuccessState());
      },
    );
  }

  void selectVehicleCategory(int index) {
    selectedVehicleCategoryId = vehicleCategories[index].id;
    if (selectedVehicleCategoryId != 2) {
      selectedSeatsIds.clear();
    }
    emit(ScheduleTripPickState());
  }

  //! Seats
  List<SeatModel> seats = [];
  List<int> selectedSeatsIds = [];
  Future<void> getSeats() async {
    final result = await sl<VehicleRepo>().getSeats();
    result.fold(
      (error) {
        emit(ScheduleTripErrorState(error));
      },
      (list) {
        seats = list;
        emit(ScheduleTripSuccessState());
      },
    );
  }

  //! Accept Scheduled Trip Request
  Future<void> acceptScheduledTripRequest({required int requestId}) async {
    emit(ScheduleTripLoadingState());
    final response = await sl<DriverTripRepo>().driverAcceptShareTripRider(
      requestId: requestId,
    );
    response.fold(
      (error) => emit(ScheduleTripErrorState(error)),
      (message) => emit(ScheduleTripSuccessState(message: message)),
    );
  }

  //! Form
  SelectedLocationModel? startLocation;
  SelectedLocationModel? endLocation;
  List<SelectedLocationModel> stops = [];

  GoogleMapController? mapController;
  Set<Marker>? markers;
  Set<Polyline> polylines = {};

  DateTime? fromDate;
  DateTime? toDate;
  List<DateTime> daysFromTo = [];
  List<DateTime> selectedDaysFromTo = [];
  bool goingAndReturning = false;
  String? startHour;
  TimeOfDay? startTime;
  String? returnHour;
  TimeOfDay? returnTime;
  int seatsNumber = 1;
  int? costPerSeat;
  bool showValidation = false;

  void validationToggle() {
    showValidation = true;
    emit(ScheduleTripPickState());
  }

  //! Tab Bar
  int selectedTabBar = 0;

  void scheduleTabBarToggle(int index) {
    selectedTabBar = index;
    emit(ScheduleTabBarToggleState());
  }

  Future<void> selectLocations(dynamic value) async {
    if (value != null) {
      startLocation = value[0];
      endLocation = value[1];
      stops = value[2];
      if (startLocation?.lat != null && startLocation!.lon != null) {
        setStartMarker(
            LatLng(startLocation!.lat ?? 0, startLocation?.lon ?? 0));
        // mapController!.animateCamera(
        //   CameraUpdate.newLatLng(
        //     LatLng(
        //       startLocation!.lat!,
        //       startLocation!.lon!,
        //     ),
        //   ),
        //   duration: const Duration(seconds: 1),
        // );
      }
      if (endLocation?.lat != null && endLocation!.lon != null) {
        setDestinationarker(
            LatLng(endLocation!.lat ?? 0, endLocation!.lon ?? 0));
      }
      await getRoute();
      fitToTwoPoints();
      emit(ScheduleTripPickState());
    }
  }

  void setStartMarker(LatLng position) async {
    final BitmapDescriptor pinIcon = await getScaledMarkerIcon(
      Assets.imagesPinLocationPng,
      80,
    );

    final marker = Marker(
      markerId: const MarkerId('Start'),
      position: position,
      icon: pinIcon,
    );

    markers = markers?.union({marker}) ?? {marker};

    emit(ScheduleTripPickState());
  }

  void setDestinationarker(LatLng position) async {
    final BitmapDescriptor pinIcon = await getScaledMarkerIcon(
      Assets.imagesRiderMapPin,
      100,
    );

    final marker = Marker(
      markerId: const MarkerId('end'),
      position: position,
      icon: pinIcon,
    );

    markers = markers?.union({marker}) ?? {marker};
    emit(ScheduleTripPickState());
  }

  Future<BitmapDescriptor> getScaledMarkerIcon(String path, int width) async {
    final ByteData byteData = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: width,
    );
    final frame = await codec.getNextFrame();
    final byteDataResized = await frame.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return BitmapDescriptor.fromBytes(byteDataResized!.buffer.asUint8List());
  }

  Future<void> getRoute() async {
    if (startLocation?.lat == null ||
        endLocation?.lat == null ||
        startLocation?.lon == null ||
        endLocation?.lon == null) {
      return;
    }
    const String apiKey = AppConstants.mapApiKey;

    // Build URL with waypoints if stops exist
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${startLocation!.lat},${startLocation!.lon}&destination=${endLocation!.lat},${endLocation!.lon}";

    // Add waypoints if there are stops
    if (stops.isNotEmpty) {
      final waypoints =
          stops.map((stop) => "${stop.lat},${stop.lon}").join("|");
      url += "&waypoints=$waypoints";

      if (!kReleaseMode) {
        log("Route with ${stops.length} stops: $waypoints");
      }
    }

    url += "&key=$apiKey";

    try {
      final response = await sl<DioConsumer>().get(url);
      if (response.statusCode == 200) {
        final List<LatLng> polylineCoordinates = _decodePolyline(
          response.data['routes']?[0]['overview_polyline']['points'],
        );
        polylines = {};
        polylines.add(
          Polyline(
            polylineId: const PolylineId("route"),
            color: AppColors.primary,
            width: 5,
            points: polylineCoordinates,
          ),
        );
      }
    } catch (e) {
      log("Error fetching route: $e");
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> polylineCoordinates = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int byte;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      final int deltaLat = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));
      lat += deltaLat;

      shift = 0;
      result = 0;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      final int deltaLng = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));
      lng += deltaLng;

      polylineCoordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polylineCoordinates;
  }

  void fitToTwoPoints() {
    if (mapController == null) return;

    if (startLocation?.lat == null ||
        endLocation?.lat == null ||
        startLocation?.lon == null ||
        endLocation?.lon == null) {
      return;
    }

    // Determine the southwest and northeast corners correctly
    final double southWestLat = startLocation!.lat! < endLocation!.lat!
        ? startLocation!.lat!
        : endLocation!.lat!;
    final double southWestLng = startLocation!.lon! < endLocation!.lon!
        ? startLocation!.lon!
        : endLocation!.lon!;
    final double northEastLat = startLocation!.lat! > endLocation!.lat!
        ? startLocation!.lat!
        : endLocation!.lat!;
    final double northEastLng = startLocation!.lon! > endLocation!.lon!
        ? startLocation!.lon!
        : endLocation!.lon!;

    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(southWestLat, southWestLng),
      northeast: LatLng(northEastLat, northEastLng),
    );

    mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50), // padding
    );
  }

  void selectFromDate(DateTime? date) {
    fromDate = date;
    toDate = null;
    if (fromDate != null && toDate != null) {
      daysFromTo.clear();
      selectedDaysFromTo.clear();
      int index = 0;
      while (!fromDate!.add(Duration(days: index)).isAfter(toDate!)) {
        daysFromTo.add(fromDate!.add(Duration(days: index)));
        index = index + 1;
      }
    }
    emit(ScheduleTripPickState());
  }

  void selectToDate(DateTime? date) {
    toDate = date;
    if (fromDate != null && toDate != null) {
      daysFromTo.clear();
      selectedDaysFromTo.clear();
      int index = 0;
      while (!fromDate!.add(Duration(days: index)).isAfter(toDate!)) {
        daysFromTo.add(fromDate!.add(Duration(days: index)));
        index = index + 1;
      }
    }
    emit(ScheduleTripPickState());
  }

  void goingAndReturningToggle() {
    goingAndReturning = !goingAndReturning;
    returnHour = null;
    emit(ScheduleTripPickState());
  }

  void selectStartHour({
    String? time,
    TimeOfDay? timeOfDay,
  }) {
    startHour = time;
    startTime = timeOfDay;
    emit(ScheduleTripPickState());
  }

  void selectReturnHour({
    String? time,
    TimeOfDay? timeOfDay,
  }) {
    returnHour = time;
    returnTime = timeOfDay;
    emit(ScheduleTripPickState());
  }

  void selectSeat(int index) {
    if (selectedSeatsIds.contains(seats[index].id)) {
      selectedSeatsIds.remove(seats[index].id);
    } else {
      selectedSeatsIds.add(seats[index].id!);
    }
    update();
  }

  void increaseSeatNumber() {
    seatsNumber++;
    emit(ScheduleTripPickState());
  }

  void decreaseSeatNumber() {
    if (seatsNumber != 1) {
      seatsNumber--;
    }
    emit(ScheduleTripPickState());
  }

  void selectDay(int index) {
    selectedDaysFromTo.contains(daysFromTo[index])
        ? selectedDaysFromTo.remove(daysFromTo[index])
        : selectedDaysFromTo.add(daysFromTo[index]);
    emit(ScheduleTripPickState());
  }

  dynamic formateDate(DateTime? date) {
    if (date != null) {
      return "${date.year}-${date.month}-${date.day}";
    }
    return;
  }

  void getCostPerSeat() {
    costPerSeat = 530;
    emit(GetCostPerSeatState());
  }

  //! Female
  bool isFemale = false;

  void femaleOptionToggle(bool value) {
    isFemale = value;
    emit(ScheduleTripPickState());
  }

  //! Baby Carriage
  bool isBabyCarriage = false;

  void babyCarrigageOptionToggle(bool value) {
    isBabyCarriage = value;
    emit(ScheduleTripPickState());
  }

  //! Requests
  int requestsTabIndex = 0;
  void changeRequestsTabIndex(int value) {
    requestsTabIndex = value;
    emit(ChangeRequestsTabIndexState());
  }

  TripEstimationModel? estimatedTripDetails;

  Future<void> calculateEstimated() async {
    print('================================');
    print(
      selectedSeatsIds.length,
    );
    emit(CalculateShareEstimatedLoadingState());
    final result = await sl<ScheduleTripRepo>().calculateEstimated(
      tripTypeId: 2,
      vehilceCategoryId: 2,
      pickupAddress: startLocation?.address ?? '',
      pickupLatitude: startLocation?.lat ?? 0,
      pickupLongitude: startLocation?.lon ?? 0,
      dropoffAddress: endLocation?.address ?? '',
      dropoffLatitude: endLocation?.lat ?? 0,
      dropoffLongitude: endLocation?.lon ?? 0,
      seatsNeeded: selectedSeatsIds.length,
      stops: stops.map((e) => LatLng(e.lat ?? 0, e.lat ?? 0)).toList(),
    );
    result.fold(
        (error) => emit(CalculateShareEstimatedErrorState(message: error)), (
      model,
    ) {
      estimatedTripDetails = model;
      emit(CalculateShareEstimatedSuccessState());
    });
  }

  void update() => emit(ScheduleTripSuccessState());

  @override
  Future<void> close() {
    dbSubscription?.cancel();
    dbTodayStatusSubscription?.cancel();
    return super.close();
  }
}
