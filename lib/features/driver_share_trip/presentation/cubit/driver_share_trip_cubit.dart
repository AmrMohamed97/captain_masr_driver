import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/imports/imports.dart';
import '../../../driver_trip/data/models/complete_trip_response_model.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';
import '../../data/models/directions_response_model.dart';
import '../../data/repo/driver_share_trip_repo.dart';

part 'driver_share_trip_state.dart';

class DriverShareTripCubit extends Cubit<DriverShareTripState> {
  DriverShareTripCubit({
    required int tripId,
  }) : super(DriverShareTripInitial()) {
    // if (isShareTrip || isOnMyWay) {
    initShareTripDetailsRealTime(tripId: tripId);
    // }
  }

  //! Trip Details
  TripDetailsModel? tripDetails;
  DateTime? driverarrivalTime;
  TripDetailsModel? currentTripDetails;
  List<TripDetailsModel> requests = [];
  List<TripDetailsModel> riders = [];
  List<int> shownRequestIds = [];
  DatabaseReference? dbTripDetails;
  StreamSubscription<DatabaseEvent>? dbSubscription;

  void initShareTripDetailsRealTime({required int tripId}) async {
    print('========================trip id ==========================');
    print(tripId);

    dbTripDetails = FirebaseDatabase.instance.ref("share_trips/$tripId");

    dbSubscription = dbTripDetails?.onValue.listen((event) {
      try {
        final data = event.snapshot.value as Map?;
        if (!kReleaseMode) log("Share Trip Details: ${data.toString()}");

        if (data != null) {
          currentTripDetails = TripDetailsModel.fromJson(data);
          print('========================trip data ==========================');
          print(currentTripDetails?.id);

          // Update requests and riders lists
          requests = currentTripDetails?.requests ?? [];
          riders = currentTripDetails?.riders
                  .where(
                    (e) => e.status != "completed" && e.status != "cancelled",
                  )
                  .toList() ??
              [];

          final oldStatus = tripDetails?.status;

          if (isDriverSelected) {
            tripDetails = currentTripDetails;
          } else if (selectedRider != null) {
            // Find the selected rider in the updated riders list
            final updatedRider =
                riders.where((e) => e.riderId == selectedRider).firstOrNull;
            if (updatedRider != null) {
              tripDetails = updatedRider;
            } else {
              // If selected rider is no longer in the list (e.g. cancelled), fallback to driver
              isDriverSelected = true;
              selectedRider = null;
              tripDetails = currentTripDetails;
            }
          }

          final newStatus = tripDetails?.status;
          bool statusChanged = oldStatus != newStatus;

          //! Set Destination
          if (destinationLocation == null) {
            _startStatusTimer();
            updateTravelTime();
            if (tripDetails?.dropoffLatitude != null &&
                tripDetails?.dropoffLongitude != null) {
              destinationLocation = LatLng(
                tripDetails!.dropoffLatitude!,
                tripDetails!.dropoffLongitude!,
              );
            }
          }

          if (tripDetails?.status == "driver_arrived") {
            driverarrivalTime = DateTime.now();
            isDriverWaiting = true;
            isTripStarted = false;
            if (statusChanged) _startStatusTimer();
          }

          if (tripDetails?.status == "started") {
            if (statusChanged) totalDistanceNum = null;
            isDriverWaiting = false;
            isTripStarted = true;
            if (statusChanged) {
              _startStatusTimer();
              updateTravelTime();
            }
            if (tripDetails?.dropoffLatitude != null &&
                tripDetails?.dropoffLongitude != null) {
              destinationLocation = LatLng(
                tripDetails!.dropoffLatitude!,
                tripDetails!.dropoffLongitude!,
              );
            }
            if (statusChanged) updateTravelTime();
            _startStatusTimer();
          }

          if (tripDetails?.status == "cancelled") {
            emit(DriverShareTripCancelledFromRiderState());
            return;
          }

          //! Rider Droped Off
          // if (tripDetails?.riders.any((e) => e.status == "completed") ??
          //     false) {
          //   final completedTrip =
          //       tripDetails?.riders.where((e) => e.status == "completed").first;
          //   emit(
          //     DriverShareTripCompletedState(
          //       // completeTripResponseModel: null,
          //       tripDetails: completedTrip,
          //     ),
          //   );
          // }

          //! New Requests
          if (requests.isNotEmpty) {
            for (var request in requests) {
              if (request.status != "cancelled" &&
                  request.id != null &&
                  !shownRequestIds.contains(request.id)) {
                shownRequestIds.add(request.id!);
                emit(NewShareRiderJoinState(tripDetails: request));
              }
            }
          }

          // Only emit generic state if something else didn't emit a more specific one
          // and we need the UI to reflect general changes
          if (statusChanged) {
            emit(
                SelectShareRiderState()); // Use a specific state that triggers partial rebuilds
          }
        }
      } catch (e) {
        if (!kReleaseMode) log("Error on Add: $e");
      }
    });
  }

  //! Driver Arrived
  Future<void> driverArrived() async {
    emit(DriverShareTripLoadingState());
    final result = await sl<DriverShareTripRepo>().tripArriverd(
      tripId: tripDetails?.rideId ?? 0,
    );
    result.fold(
      (error) => emit(DriverShareTripErrorState(error: error)),
      (message) => emit(DriverShareTripSuccessState(message: message)),
    );
  }

  //! Driver Arrived Share Trip
  Future<void> driverArrivedShareTrip() async {
    emit(DriverShareTripLoadingState());
    final result = await sl<DriverShareTripRepo>().driverArrivedShareTrip(
      requestId: tripDetails?.id ?? 0,
    );
    result.fold(
      (error) => emit(DriverShareTripErrorState(error: error)),
      (message) => emit(DriverShareTripSuccessState(message: message)),
    );
  }

  //! Start Trip
  Future<void> startTrip({XFile? deliveryImage}) async {
    emit(DriverShareTripLoadingState());
    final result = await sl<DriverShareTripRepo>().tripStart(
      tripId: tripDetails?.rideId ?? 0,
      tripCode: tripDetails?.tripCode,
      deliveryImageDriver: await uploadImageToApi(deliveryImage),
    );
    result.fold(
      (error) => emit(DriverShareTripErrorState(error: error)),
      (message) => emit(DriverShareTripSuccessState(message: message)),
    );
  }

  //! Start Share Trip
  Future<void> startShareTrip() async {
    emit(DriverShareTripLoadingState());
    final result = await sl<DriverShareTripRepo>().startShareTrip(
      tripId: tripDetails?.id ?? 0,
    );
    result.fold(
      (error) => emit(DriverShareTripErrorState(error: error)),
      (message) => emit(DriverShareTripSuccessState(message: message)),
    );
  }

  //! Start Share Trip With Riders
  Future<void> startShareTripWithRiders() async {
    emit(DriverShareTripLoadingState());
    final result = await sl<DriverShareTripRepo>().startShareTripWithRiders(
      requestId: tripDetails?.id ?? 0,
    );
    result.fold((error) => emit(DriverShareTripErrorState(error: error)),
        (message) {
      destinationLocation = LatLng(
        tripDetails?.dropoffLatitude ?? 0,
        tripDetails?.dropoffLongitude ?? 0,
      );
      log("Destination Location: $destinationLocation");
      getRoute();
      emit(DriverShareTripSuccessState(message: message));
    });
  }

  //! Complete Trip
  Future<void> completeTrip() async {
    final TripDetailsModel? currentTripDetails = tripDetails;
    emit(DriverShareTripLoadingState());
    final result = await sl<DriverShareTripRepo>().tripComplete(
      tripId: tripDetails?.rideId ?? 0,
    );
    result.fold((error) => emit(DriverShareTripErrorState(error: error.message)), (
      completedTrips,
    ) {
      tripEnded = true;
      dbSubscription?.cancel();
      emit(DriverShareTripCompletedState(
          completeTripResponseModel: completedTrips,
          tripDetails: currentTripDetails));
    });
  }

  //! Complete Share Trip With Riders
  Future<void> completeShareTripWithRiders() async {
    emit(DriverShareTripLoadingState());
    final result =
        await sl<DriverShareTripRepo>().driverCompleteShareTripWithRiders(
      requestId: tripDetails?.id ?? 0,
    );
    result.fold((error) => emit(DriverShareTripErrorState(error: error.message)),
        (completedTrips) {
      selectDriver(true);
      emit(DriverShareTripCompletedState(
          completeTripResponseModel: completedTrips, tripDetails: tripDetails));
      // emit(DriverShareTripSuccessState(message: message));
    });
  }

  //! Cancel Trip
  Future<void> cancelTrip({
    required List<String>? cancelReasons,
    required String? notes,
  }) async {
    emit(DriverShareTripLoadingState());
    final result = await sl<DriverShareTripRepo>().cancelTrip(
      tripId: tripDetails?.rideId ?? 0,
      cancelReasons: cancelReasons,
      notes: notes,
    );
    result.fold(
      (error) => emit(DriverShareTripErrorState(error: error)),
      (message) => emit(DriverCancelShareTripSuccessState(message: message)),
    );
  }

  //! Complete Share Trip
  Future<void> completeShareTrip() async {
    emit(DriverShareTripLoadingState());
    final result = await sl<DriverShareTripRepo>().completeShareTrip(
      tripId: tripDetails?.id ?? 0,
    );
    result.fold((error) => emit(DriverShareTripErrorState(error: error)),
        (message) {
      tripEnded = true;
      dbSubscription?.cancel();
      emit(DriverShareCompleteShareTripState());
    });
  }

  //! Accept Share Trip Rider
  Future<void> acceptShareTripRider(TripDetailsModel newRider) async {
    emit(DriverShareTripLoadingState());
    final result = await sl<DriverShareTripRepo>().driverAcceptShareTripRider(
      requestId: newRider.id!,
    );
    result.fold((error) => emit(DriverShareTripErrorState(error: error)),
        (message) {
      selectDriver(true);
      emit(DriverShareTripSuccessState(message: message));
    });
  }

  Future<void> declineRiderRequest({required int requestId}) async {
    emit(DriverShareTripLoadingState());
    final response = await sl<DriverShareTripRepo>().driverCancelShareTrip(
      tripId: requestId,
    );
    response.fold(
      (error) => emit(DriverShareTripErrorState(error: error.toString())),
      (message) {
        selectDriver(false);
        emit(DriverShareTripSuccessState(message: message));
      },
    );
  }

  //! Cancel Share Trip
  Future<void> cancelShareTrip({
    required List<String>? cancelReasons,
    required String? notes,
  }) async {
    emit(DriverShareTripLoadingState());
    final result = await sl<DriverShareTripRepo>().driverCancelShareTrip(
      tripId: tripDetails?.id ?? 0,
      cancelReasons: cancelReasons,
      notes: notes,
    );
    result.fold(
      (error) => emit(DriverShareTripErrorState(error: error)),
      (message) => emit(DriverCancelShareTripSuccessState(message: message)),
    );
  }

  //! Cancel All Schedule Trip
  Future<void> cancelAllScheduleTrip({
    required List<String>? cancelReasons,
    required String? notes,
  }) async {
    emit(DriverShareTripLoadingState());
    final result = await sl<DriverShareTripRepo>().driverCancelAllScheduleTrip(
      tripId: tripDetails?.id ?? 0,
      cancelReasons: cancelReasons ?? [],
      notes: notes ?? '',
    );
    result.fold(
      (error) => emit(DriverShareTripErrorState(error: error)),
      (message) => emit(DriverCancelShareTripSuccessState(message: message)),
    );
  }

  //! Driver Cancel Rider Schedule Trip
  Future<void> driverCancelScheduleTripForRider({
    // required int riderId,
    required List<String> reason,
    required String notes,
  }) async {
    // print(currentTripDetails?.riderId);
    // print(tripDetails?.id);
    emit(DriverShareTripLoadingState());
    final response =
        await sl<DriverShareTripRepo>().driverCancelScheduleTripForRider(
      requestId: tripDetails?.id ?? 0, //here must use request id
      cancelReasons: reason,
      notes: notes,
    );
    response.fold(
      (error) => emit(DriverShareTripErrorState(error: error)),
      (message) =>
          emit(DriverCancelShareTripForRiderSuccessState(message: message)),
    );
  }

// ...
  //! Cancel Share Trip With Riders
  Future<void> cancelShareTripWithRiders({
    required List<String>? cancelReasons,
    required String? notes,
  }) async {
    emit(DriverShareTripLoadingState());
    final result =
        await sl<DriverShareTripRepo>().driverCancelShareTripWithRider(
      requestId: tripDetails?.id ?? 0,
      cancelReasons: cancelReasons,
      notes: notes,
    );
    result.fold(
      (error) => emit(DriverShareTripErrorState(error: error)),
      (message) => emit(DriverShareTripSuccessState(message: message)),
    );
  }

  GoogleMapController? mapController;

  // Unified timer controls
  Timer? statusTimer;
  Duration currentDisplayTime = Duration.zero;
  DateTime? statusChangedAt;

  bool isClassicTrip = false;
  bool isGroupTrip = false;
  bool isShareTrip = false;
  bool isDeliveryTrip = false;
  bool isOnMyWay = false;

  bool isBottomContainerExpanded = true;
  bool isBottomContainerExpanded2 = false;

  bool isDriverWaiting = false;
  bool isTripStarted = false;
  bool? isTripCompleted;
  bool isActive = true;
  bool tripEnded = false;
  int? selectedCodeIndex;
  bool showTripCodeValidation = false;
  int? selectedRider;

  LatLng? driverLocation;
  LatLng? destinationLocation;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  String? arrivalTime;
  String? remainingDistance;
  int? travelTimeSeconds;
  // DateTime? _lastTravelTimeFetch;
  num? remainingDistanceNum;
  num? totalDistanceNum;

  List<TripDetailsModel> ridersList =
      []; // Remove this if not needed, we use riders

  void bottomContainerExpandedToggle(bool value) {
    isBottomContainerExpanded = value;
    emit(DriverShareBottomContainerExpandedToggleState());
  }

  void bottomContainerExpandedToggle2(bool value) {
    isBottomContainerExpanded2 = value;
    emit(DriverShareBottomContainerExpandedToggleState());
  }

  Future<void> getRoute() async {
    // emit(DriverTripGetRouteLoadingState());
    if (destinationLocation == null || driverLocation == null) return;

    const String apiKey = "AIzaSyCuOWpUhowE4hXXmyFi0P_2wlCBQu6cFt4";

    // Build URL with waypoints if stops exist
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${driverLocation!.latitude},${driverLocation!.longitude}&destination=${destinationLocation!.latitude},${destinationLocation!.longitude}";

    // Add waypoints if there are stops
    if (tripDetails?.stops != null && tripDetails!.stops.isNotEmpty) {
      final waypoints = tripDetails!.stops
          .map((stop) => "${stop.latitude},${stop.longitude}")
          .join("|");
      url += "&waypoints=$waypoints";

      if (!kReleaseMode) {
        log("Route with ${tripDetails!.stops.length} stops: $waypoints");
      }
    }

    url += "&key=$apiKey";

    try {
      final response = await sl<DioConsumer>().get(url);
      if (response.statusCode == 200) {
        final directionsResponse = DirectionsResponseModel.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        );

        if (!directionsResponse.isOk || directionsResponse.firstRoute == null) {
          log("Directions API returned status: ${directionsResponse.status}");
          return;
        }

        final route = directionsResponse.firstRoute!;
        final leg = route.firstLeg;

        final List<LatLng> polylineCoordinates = _decodePolyline(
          route.overviewPolyline.points,
        );

        polylines.clear();
        polylines.add(
          Polyline(
            polylineId: const PolylineId("route"),
            color: AppColors.primary,
            width: 5,
            points: polylineCoordinates,
          ),
        );

        markers.clear();

        await setCarMarker(driverLocation!);
        await setRiderMarker(destinationLocation!);

        // Add stop markers if there are stops
        if (tripDetails?.stops != null && tripDetails!.stops.isNotEmpty) {
          await setStopMarkers(tripDetails!.stops);
        }

        mapController?.animateCamera(
          CameraUpdate.newLatLng(driverLocation!),
          duration: const Duration(milliseconds: 300),
        );

        if (leg != null) {
          final int durationInSeconds = leg.duration.value;

          // Set arrival time based on route calculation
          arrivalTime = formatTimeWithLocale(
            DateTime.now().add(Duration(seconds: durationInSeconds)).toString(),
          );

          final double distanceInKm = leg.distance.value.toDouble() / 1000;
          remainingDistanceNum = distanceInKm;
          if (totalDistanceNum != null && totalDistanceNum != 0.0) {
            null;
          } else {
            totalDistanceNum = tripDetails?.status == "started"
                ? tripDetails?.distanceKm ?? distanceInKm
                : distanceInKm;
          }
          remainingDistance = formatDistance(distanceInKm);
        }

        emit(DriverShareTripGetRouteSuccessState());
      }
    } catch (e) {
      log("Error fetching route: $e");
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> polylineCoordinates = [];
    int index = 0, lat = 0, lng = 0;

    while (index < encoded.length) {
      int result = 0, shift = 0, byte;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      result = 0;
      shift = 0;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      polylineCoordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polylineCoordinates;
  }

  Future<void> setCarMarker(LatLng position) async {
    final icon = await getScaledMarkerIcon(
      isDeliveryTrip ? Assets.imagesDeliveryMapIcon : Assets.imagesMapCar,
      100,
    );
    markers.add(
      Marker(
        markerId: const MarkerId('Driver'),
        position: position,
        icon: icon,
        infoWindow: const InfoWindow(title: 'Driver'),
      ),
    );
  }

  Future<void> setRiderMarker(LatLng position) async {
    final icon = await getScaledMarkerIcon(Assets.imagesRiderMapPin, 100);
    markers.add(
      Marker(
        markerId: const MarkerId('You'),
        position: position,
        icon: icon,
        infoWindow: const InfoWindow(title: 'You'),
      ),
    );
  }

  Future<void> setStopMarkers(List<LatLng> stops) async {
    for (int i = 0; i < stops.length; i++) {
      final Marker marker = Marker(
        markerId: MarkerId('Stop_$i'),
        position: stops[i],
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueOrange, // Use orange markers for stops
        ),
        infoWindow: InfoWindow(title: 'Stop ${i + 1}'),
      );

      markers.add(marker);
    }
  }

  Future<BitmapDescriptor> getScaledMarkerIcon(String path, int width) async {
    final ByteData byteData = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: width,
    );
    final frame = await codec.getNextFrame();
    final resized = await frame.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return BitmapDescriptor.fromBytes(resized!.buffer.asUint8List());
  }

  // void arrivalTimer() {
  //   _arrivalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (remainigArrivalTimeDuration?.inSeconds == 0) {
  //       timer.cancel();
  //       return;
  //     }
  //     remainigArrivalTimeDuration =
  //         Duration(seconds: remainigArrivalTimeDuration!.inSeconds - 1);
  //     calculateRemainigArrivalTimeValue();
  //     emit(DriverTimerState());
  //   });
  // }

  //! Unified Timer and Time Calculation
  void _startStatusTimer() {
    statusTimer?.cancel();

    // Store when status changed (from tripDetails.updatedAt)
    if (tripDetails?.updatedAt != null && tripDetails!.updatedAt!.isNotEmpty) {
      try {
        // Handle different DateTime formats and timezone issues
        String dateTimeStr = tripDetails!.updatedAt!;
        // Remove timezone offset if present to get local time
        if (dateTimeStr.contains('+') || dateTimeStr.contains('Z')) {
          dateTimeStr =
              dateTimeStr.replaceAll('Z', '').split('+')[0].split('-')[0];
        }
        statusChangedAt = DateTime.parse(dateTimeStr);
      } catch (e) {
        log("Error parsing updatedAt: $e, using current time");
        statusChangedAt = DateTime.now(); // fallback
      }
    } else {
      statusChangedAt = DateTime.now(); // fallback
    }

    // Initialize current time immediately
    _updateCurrentTime();

    if (!kReleaseMode) {
      log(
        "Timer started - statusChangedAt: $statusChangedAt, isDriverWaiting: $isDriverWaiting, isTripStarted: $isTripStarted, currentDisplayTime: ${currentDisplayTime.toString()}",
      );
    }

    // Start timer for waiting and trip states
    if (isDriverWaiting || isTripStarted) {
      statusTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!isActive) {
          timer.cancel();
          return;
        }
        _updateCurrentTime();

        emit(DriverShareTimerState(
            counter: DateTime.now().millisecondsSinceEpoch));
      });
    }

    // Emit initial timer state
    emit(DriverShareTimerState(counter: DateTime.now().millisecondsSinceEpoch));
  }

  void _updateCurrentTime() {
    if (statusChangedAt == null) {
      currentDisplayTime = Duration.zero;
      return;
    }

    final Duration difference = DateTime.now().difference(statusChangedAt!);
    // Ensure we don't have negative durations
    currentDisplayTime = difference.isNegative ? Duration.zero : difference;
  }

  //! Update timer when rider is selected in share trips
  void _updateTimerForSelectedRider(TripDetailsModel rider) {
    // Stop current timer
    statusTimer?.cancel();
    statusTimer = null;

    // Reset timer flags
    isDriverWaiting = false;
    isTripStarted = false;

    // Set timer flags based on selected rider's status
    if (rider.status == "driver_arrived") {
      isDriverWaiting = true;
      isTripStarted = false;
      _startStatusTimer();
    } else if (rider.status == "started") {
      isDriverWaiting = false;
      isTripStarted = true;
      _startStatusTimer();
      updateTravelTime();
    } else if (rider.status == "accepted") {
      isDriverWaiting = false;
      isTripStarted = false;
      updateTravelTime();
    } else {
      // For other statuses (pending, completed, cancelled), no timer needed
      currentDisplayTime = Duration.zero;
      emit(DriverShareTimerState(
          counter: DateTime.now().millisecondsSinceEpoch));
    }

    if (!kReleaseMode) {
      log(
        "Timer updated for rider ${rider.riderName} with status: ${rider.status}",
      );
    }
  }

  String formatDistance(double distanceInKm) {
    final double meters = distanceInKm * 1000;
    return meters < 1000
        ? "${meters.toInt()} ${sl<Cache>().getLanguage() == "en" ? "M" : "متر"}"
        : "${distanceInKm.toStringAsFixed(2)} ${sl<Cache>().getLanguage() == "en" ? "KM" : "كيلومتر"}";
  }

  String formatTimeWithLocale(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat.jm(sl<Cache>().getLanguage()).format(dateTime);
  }

  String formatDuration() {
    Duration duration = currentDisplayTime;

    if (duration.inSeconds > 0) {
      duration = duration - const Duration(hours: 3);
    }

    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    final formatted = '$minutes:${seconds.toString().padLeft(2, '0')}';

    return sl<Cache>().getLanguage() == "en"
        ? '$formatted min'
        : '$formatted دقيقة';
  }

  //! formatTime method for unified approach
  String formatTime() {
    return formatDuration(); // Use the same logic as formatDuration
  }

  double calculateRemainigArrivalTimeValue() {
    // Return progress based on current display time
    // For arrival time, we can use a simple calculation or return 0 if not available
    return 0.0;
  }

  double calculateRemainingDistanceValue() {
    if (totalDistanceNum == null ||
        remainingDistanceNum == null ||
        totalDistanceNum == 0) {
      return 0;
    }

    final value =
        (totalDistanceNum! - remainingDistanceNum!) / totalDistanceNum!;
    return value.clamp(0.0, 1.0);
  }

  double calculateRemainigTripTimeValue() {
    // Return progress based on current display time
    // For trip time, we can use a simple calculation or return 0 if not available
    return currentDisplayTime.inSeconds / 10.0;
  }

  void selectTripCode(int index) {
    selectedCodeIndex = index;
    emit(SelectShareTripCodeState());
  }

  void selectRider(int riderId) {
    isDriverSelected = false;
    selectedRider = riderId;
    final rider = riders.where((e) => e.riderId == riderId).firstOrNull;
    if (rider != null) {
      tripDetails = rider;

      // Update timer based on selected rider's status
      _updateTimerForSelectedRider(rider);

      if (rider.status != "started" && rider.status != "completed" ||
          rider.status == "pending") {
        destinationLocation = LatLng(
          rider.pickupLatitude!,
          rider.pickupLongitude!,
        );
        log("Destination Location: $destinationLocation");
        getRoute();
      } else {
        destinationLocation = LatLng(
          rider.dropoffLatitude!,
          rider.dropoffLongitude!,
        );
        log("Destination Location: $destinationLocation");
        getRoute();
      }
    }
    emit(SelectShareRiderState());
    updateTravelTime(force: true);
  }

  // void addRider(TripDetailsModel newRider) {
  //   riders.add(newRider);
  //   emit(SelectRiderState());
  // }

  Future<void> updateTravelTime({bool force = false}) async {
    if (tripDetails == null) return;

    try {
      final minutes = await MapsHelper.getArrivalTime(
        dropoffLat: double.parse(
          (isTripStarted
                  ? tripDetails!.dropoffLatitude
                  : tripDetails!.pickupLatitude)
              .toString(),
        ),
        dropoffLng: double.parse(
          (isTripStarted
                  ? tripDetails!.dropoffLongitude
                  : tripDetails!.pickupLongitude)
              .toString(),
        ),
        driverId: tripDetails!.driverId!,
      );

      if (minutes != null) {
        travelTimeSeconds = minutes * 60;
        emit(DriverShareTravelTimeUpdatedState());
      }
    } catch (e) {
      log("Error updating travel time: $e");
    }
  }

  void removeRider() {
    // riders.remove(Assets.imagesTestProfile2);
    emit(SelectShareRiderState());
  }

  bool isDriverSelected = true;

  void selectDriver(bool value) {
    isDriverSelected = value;
    if (value) {
      selectedRider = null;
      tripDetails = currentTripDetails;

      // Update timer based on overall trip status when switching to driver view
      if (tripDetails != null) {
        _updateTimerForSelectedRider(tripDetails!);
      }

      if (tripDetails?.dropoffLatitude != null &&
          tripDetails?.dropoffLongitude != null) {
        destinationLocation = LatLng(
          tripDetails!.dropoffLatitude!,
          tripDetails!.dropoffLongitude!,
        );
        log("Destination Location: $destinationLocation");
        getRoute();
      }
    }
    emit(SelectShareRiderState());
    updateTravelTime(force: true);
  }

  @override
  Future<void> close() {
    isActive = false;
    statusTimer?.cancel();
    dbSubscription?.cancel();
    return super.close();
  }
}
