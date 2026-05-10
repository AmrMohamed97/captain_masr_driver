import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/imports/imports.dart';
import '../../../pick_location/data/models/selected_location_model.dart';
import '../../data/models/trip_details_model.dart';
import '../../data/repo/rider_trip_repo.dart';
import '../../../driver_trip/data/repo/driver_trip_repo.dart';

part 'rider_trip_state.dart';

class RiderTripCubit extends Cubit<RiderTripState> {
  RiderTripCubit({
    required this.isDelivery,
    required this.isShareRide,
    required tripId,
    required riderId,
  }) : super(RiderTripInitial()) {
    if (isShareRide) {
      initShareTripDetailsRealTime(tripId: tripId, riderId: riderId);
    } else {
      initTripDetailsRealTime(tripId: tripId);
    }
  }

  GoogleMapController? mapController;

  //! Driver Location
  LatLng? driverLocation;
  DatabaseReference? db;
  StreamSubscription<DatabaseEvent>? driverLocationSubscription;

  TripDetailsModel? tripDetails;
  List<TripDetailsModel> newRequests = [];
  DatabaseReference? dbTripDetails;
  StreamSubscription<DatabaseEvent>? tripDetailsSubscription;
  void initTripDetailsRealTime({required int tripId}) async {
    dbTripDetails = FirebaseDatabase.instance.ref("trips/$tripId");

    tripDetailsSubscription = dbTripDetails?.onValue.listen((event) {
      try {
        final data = event.snapshot.value as Map?;
        if (!kReleaseMode) log("Trip Details: ${data.toString()}");

        if (data != null) {
          tripDetails = TripDetailsModel.fromJson(data);
          emit(state);

          //! Set Destination
          if (destination == null &&
              tripDetails?.pickupLatitude != null &&
              tripDetails?.pickupLongitude != null) {
            destination = LatLng(
              tripDetails!.pickupLatitude!,
              tripDetails!.pickupLongitude!,
            );
          }

          //! Driver Arriverd
          if (tripDetails?.status == "driver_arrived") {
            isDriverWaiting = true;
            isTripStarted = false;
            _startStatusTimer();
          }

          //! Started
          if (tripDetails?.status == "started") {
            totalDistanceNum = null;
            isTripStarted = true;
            isDriverWaiting = false;
            destination = LatLng(
              tripDetails!.dropoffLatitude!,
              tripDetails!.dropoffLongitude!,
            );
            _startStatusTimer();
            getRoute();
          }

          //! Completed
          if (tripDetails?.status == "completed") {
            try {
              sl<Cache>().setData(
                AppConstants.recentLocations,
                jsonEncode({
                  AppConstants.recentLocations: [
                    SelectedLocationModel(
                      address: tripDetails?.pickupAddress,
                      lat: tripDetails?.pickupLatitude,
                      lon: tripDetails?.pickupLongitude,
                    ).toJson(),
                    SelectedLocationModel(
                      address: tripDetails?.dropoffAddress,
                      lat: tripDetails?.dropoffLatitude,
                      lon: tripDetails?.dropoffLongitude,
                    ).toJson(),
                  ],
                }),
              );
            } catch (e) {
              log("Error on save locations: $e");
            }
            tripDetailsSubscription?.cancel();
            driverLocationSubscription?.cancel();
            emit(RideCompleteState());
          }

          //! Cancel
          if (tripDetails?.status == "cancelled" ||
              tripDetails?.status == "canceled") {
            emit(RiderTripCancelledFromDriverState());
            return;
          }

          if (driverLocation == null) {
            updateDriverLocation();
          }
        }
      } catch (e) {
        if (!kReleaseMode) log("Error on Add: $e");
      }
    });
  }

  void initShareTripDetailsRealTime({
    required int tripId,
    required int riderId,
  }) async {
    log("Trip Id:$tripId");
    dbTripDetails = FirebaseDatabase.instance.ref(
      "share_trips/$tripId",
    );

    tripDetailsSubscription = dbTripDetails?.onValue.listen((event) {
      try {
        final data = event.snapshot.value as Map?;
        if (!kReleaseMode) log("Share Trip Details: ${data.toString()}");

        if (data != null) {
          final tripModel = TripDetailsModel.fromJson(data);

          //! Extract own rider details
          final ridersMap = data['riders'] as Map?;
          if (ridersMap != null && ridersMap.containsKey(riderId.toString())) {
            tripDetails =
                TripDetailsModel.fromJson(ridersMap[riderId.toString()]);
          } else {
            tripDetails = tripModel;
          }

          //! Extract Requests
          newRequests = data['requests'] != null
              ? (data['requests'] is List)
                  ? (data['requests'] as List)
                      .where((element) => element != null)
                      .map((e) => TripDetailsModel.fromJson(e))
                      .toList()
                  : (data['requests'] as Map)
                      .map((key, value) {
                        return MapEntry(key, TripDetailsModel.fromJson(value));
                      })
                      .values
                      .toList()
              : [];

          //! Set Destination
          if (tripDetails?.status == "started" &&
              tripDetails?.dropoffLatitude != null &&
              tripDetails?.dropoffLongitude != null) {
            destination = LatLng(
              tripDetails!.dropoffLatitude!,
              tripDetails!.dropoffLongitude!,
            );
          } else if (tripDetails?.status != "started" &&
              tripDetails?.pickupLatitude != null &&
              tripDetails?.pickupLongitude != null) {
            destination = LatLng(
              tripDetails!.pickupLatitude!,
              tripDetails!.pickupLongitude!,
            );
          }

          log("Status: ${tripDetails?.status}");
          emit(NewRequestsUpdateState());

          //! Driver Arriverd
          if (tripDetails?.status == "driver_arrived") {
            isDriverWaiting = true;
            _startStatusTimer();
          }

          //! Started
          if (tripDetails?.status == "started") {
            totalDistanceNum = null;
            isTripStarted = true;
            _startStatusTimer();
            getRoute();
          }

          //! Completed
          if (tripDetails?.status == "completed") {
            try {
              sl<Cache>().setData(
                AppConstants.recentLocations,
                jsonEncode({
                  AppConstants.recentLocations: [
                    SelectedLocationModel(
                      address: tripDetails?.pickupAddress,
                      lat: tripDetails?.pickupLatitude,
                      lon: tripDetails?.pickupLongitude,
                    ).toJson(),
                    SelectedLocationModel(
                      address: tripDetails?.dropoffAddress,
                      lat: tripDetails?.dropoffLatitude,
                      lon: tripDetails?.dropoffLongitude,
                    ).toJson(),
                  ],
                }),
              );
            } catch (e) {
              log("Error on save locations: $e");
            }
            tripDetailsSubscription?.cancel();
            driverLocationSubscription?.cancel();
            emit(RideCompleteState());
          }

          //! Cancel
          if (tripDetails?.status == "cancelled" ||
              tripDetails?.status == "canceled") {
            emit(RiderTripCancelledFromDriverState());
            return;
          }

          if (driverLocation == null) {
            updateDriverLocation();
          }
        }
      } catch (e) {
        if (!kReleaseMode) log("Error on Add: $e");
      }
    });
  }

  void updateDriverLocation() {
    db = FirebaseDatabase.instance.ref(
      "driver_locations/${tripDetails?.driverId ?? 0}",
    );

    driverLocationSubscription = db?.onValue.listen((event) {
      try {
        final data = event.snapshot.value as Map?;
        log("driver_locations/${tripDetails?.driverId ?? 0}");
        if (!kReleaseMode) log("Driver Location: ${data.toString()}");

        if (data != null) {
          driverLocation = LatLng(data["latitude"], data["longitude"]);

          getRoute();
        }
      } catch (e) {
        if (!kReleaseMode) log("Error on update driver location: $e");
      }
    });

    // db?.onChildChanged.listen((event) {
    //   try {
    //     final data = event.snapshot.value as Map?;
    //     if (!kReleaseMode) log("Driver Location: ${data.toString()}");

    //     if (data != null) {
    //       driverLocation = LatLng(
    //         data["latitude"],
    //         data["longitude"],
    //       );

    //       getRoute();
    //     }
    //   } catch (e) {
    //     if (!kReleaseMode) log("Error on Add: $e");
    //   }
    // });
  }

  bool isActive = true;
  bool isShareRide = false;
  bool isDelivery = false;

  LatLng? destination;
  Set<Marker> markers = {};

  //! Dragable Container
  bool isBottomContainerExpanded = false;

  void bottomContainerExpandedToggle(bool value) {
    isBottomContainerExpanded = value;
    emit(RideBottomContainerExpandedToggleState());
  }

  //! Polyline
  Set<Polyline> polylines = {};
  String? arrivalTime;
  Duration? remainigArrivalTimeDuration;
  bool isDriverWaiting = false;
  bool isTripStarted = false;

  //! Unified time tracking
  Duration currentDisplayTime = Duration.zero;
  DateTime? statusChangedAt;
  Timer? statusTimer;

  String? remainingDistance;
  num? remainingDistanceNum;
  num? totalDistanceNum;
  bool? isTripCompleted;
  bool? hasPayed;
  bool payDialogShowed = false;
  bool tripEnded = false;

  Future<void> getRoute() async {
    emit(GetRouteLoadingState());
    if (destination == null || driverLocation == null) return;
    const String apiKey = "AIzaSyCuOWpUhowE4hXXmyFi0P_2wlCBQu6cFt4";

    // Build URL with waypoints if stops exist
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${driverLocation!.latitude},${driverLocation!.longitude}&destination=${destination!.latitude},${destination!.longitude}";

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
        final List<LatLng> polylineCoordinates = _decodePolyline(
          response.data['routes'][0]['overview_polyline']['points'],
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

        markers = {};

        await setCarMarker(driverLocation!);
        await setRiderMarker(destination!);

        // Add stop markers if there are stops
        if (tripDetails?.stops != null && tripDetails!.stops.isNotEmpty) {
          await setStopMarkers(tripDetails!.stops);
        }

        emit(GetRouteSuccessState());

        mapController?.animateCamera(
          CameraUpdate.newLatLng(driverLocation!),
          duration: const Duration(milliseconds: 300),
        );

        final int durationInSeconds =
            response.data['routes'][0]['legs'][0]['duration']['value'];
        remainigArrivalTimeDuration = Duration(seconds: durationInSeconds);

        arrivalTime = formatTimeWithLocale(
          DateTime.now().add(remainigArrivalTimeDuration!).toString(),
        );

        final num distanceInMeters =
            response.data['routes'][0]['legs'][0]['distance']['value'];
        final double distanceInKm = distanceInMeters.toDouble() / 1000;
        remainingDistanceNum = distanceInKm;
        if (totalDistanceNum != null) {
          null;
        } else {
          totalDistanceNum = tripDetails?.distanceKm ?? distanceInKm;
        }
        remainingDistance = formatDistance(distanceInKm);

        emit(GetRouteSuccessState());
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

  String formatDistance(double distanceInKm) {
    final double distanceInMeters = distanceInKm * 1000;
    if (distanceInMeters < 1000) {
      return "${distanceInMeters.toInt()} ${sl<Cache>().getLanguage() == "en" ? "M" : "متر"}";
    } else {
      return "${distanceInKm.toStringAsFixed(2)} ${sl<Cache>().getLanguage() == "en" ? "KM" : "كيلومتر"}";
    }
  }

  String formatTimeWithLocale(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat.jm(sl<Cache>().getLanguage()).format(dateTime);
  }

  Future<void> setCarMarker(LatLng position) async {
    final BitmapDescriptor carIcon = await getScaledMarkerIcon(
      isDelivery ? Assets.imagesDeliveryMapIcon : Assets.imagesMapCar,
      100,
    );

    final marker = Marker(
      markerId: const MarkerId('Driver'),
      position: position,
      icon: carIcon,
      infoWindow: const InfoWindow(title: 'Driver'),
    );

    markers = markers.union({marker});
    isActive ? emit(state) : null;
  }

  Future<void> setRiderMarker(LatLng position) async {
    final BitmapDescriptor pinIcon = await getScaledMarkerIcon(
      Assets.imagesRiderMapPin,
      100,
    );

    final marker = Marker(
      markerId: const MarkerId('You'),
      position: position,
      icon: pinIcon,
      infoWindow: const InfoWindow(title: 'You'),
    );

    markers = markers.union({marker});
    isActive ? emit(state) : null;
  }

  Future<void> setStopMarkers(List<LatLng> stops) async {
    for (int i = 0; i < stops.length; i++) {
      final BitmapDescriptor pinIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueOrange, // Use orange markers for stops
      );

      final Marker marker = Marker(
        markerId: MarkerId('Stop_$i'),
        position: stops[i],
        icon: pinIcon,
        infoWindow: InfoWindow(title: 'Stop ${i + 1}'),
      );

      markers = markers.union({marker});
    }
    isActive ? emit(state) : null;
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
        statusChangedAt = DateTime.now();
      }
    } else {
      statusChangedAt = DateTime.now();
    }

    // Initialize current time immediately
    _updateCurrentTime();

    if (!kReleaseMode) {
      log(
        "Timer started - statusChangedAt: $statusChangedAt, isDriverWaiting: $isDriverWaiting, isTripStarted: $isTripStarted, currentDisplayTime: ${currentDisplayTime.toString()}",
      );
    }

    // Only start timer for waiting and trip states (not arrival)
    if (isDriverWaiting || isTripStarted) {
      statusTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!isActive) {
          if (!kReleaseMode) log("Timer cancelled - isActive: $isActive");
          timer.cancel();
          return;
        }
        _updateCurrentTime();
        if (!kReleaseMode) {
          log(
            "Timer tick - currentDisplayTime: ${currentDisplayTime.toString()}, formatDuration: ${formatDuration()}",
          );
        }
        // Emit unique timer state to force UI rebuild
        emit(RideTimerState(counter: DateTime.now().millisecondsSinceEpoch));
        if (!kReleaseMode) {
          log(
            "State emitted - RideTimerState with counter: ${DateTime.now().millisecondsSinceEpoch}",
          );
        }
      });
      if (!kReleaseMode) {
        log(
          "Timer started successfully - isDriverWaiting: $isDriverWaiting, isTripStarted: $isTripStarted",
        );
      }
    } else {
      if (!kReleaseMode) {
        log(
          "Timer NOT started - isDriverWaiting: $isDriverWaiting, isTripStarted: $isTripStarted",
        );
      }
    }

    // Emit initial timer state
    emit(RideTimerState(counter: DateTime.now().millisecondsSinceEpoch));
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

  void _stopStatusTimer() {
    statusTimer?.cancel();
    statusTimer = null;
  }

  //! Unified Format Time Method
  String formatDuration() {
    Duration duration;

    if (isTripStarted || isDriverWaiting) {
      // Use timer-based duration for active states
      _updateCurrentTime(); // Ensure current time is updated
      duration = currentDisplayTime;
    } else {
      // Use direct route duration for arrival time (no timer)
      duration = remainigArrivalTimeDuration ?? Duration.zero;
    }

    if (duration.inSeconds > 0) {
      duration = duration - const Duration(hours: 3);
    }

    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    final String formattedTime =
        '$minutes:${seconds.toString().padLeft(2, '0')}';

    if (sl<Cache>().getLanguage() == "en") {
      return '$formattedTime min';
    } else {
      return '$formattedTime دقيقة';
    }
  }

  //! formatTime method for unified approach
  String formatTime() {
    return formatDuration(); // Use the same logic as formatDuration
  }

  //! Arrival Time Progress (for progress bar)
  double calculateRemainigArrivalTimeValue() {
    if (remainigArrivalTimeDuration == null) {
      return 0;
    }
    return remainigArrivalTimeDuration!.inSeconds > 0 ? 0.5 : 1.0;
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
    if (!isTripStarted || currentDisplayTime.inSeconds == 0) {
      return 0;
    }

    final estimatedMinutes = tripDetails?.timeMinutes?.toInt() ?? 30;
    final estimatedTotalSeconds = estimatedMinutes * 60;

    if (estimatedTotalSeconds > 0) {
      return (currentDisplayTime.inSeconds / estimatedTotalSeconds).clamp(
        0.0,
        1.0,
      );
    }

    return 0;
  }

  //! Cancel Trip
  Future<void> cancelTrip({
    required List<String> cancelReasons,
    required String notes,
  }) async {
    emit(RiderTripLoadingState());
    final result = isShareRide
        ? await sl<RiderTripRepo>().cancelShareTrip(
            shareTripId: tripDetails?.id ?? 0,
            cancelReasons: cancelReasons,
            notes: notes,
          )
        : await sl<RiderTripRepo>().cancelTrip(
            tripId: tripDetails?.rideId ?? 0,
            cancelReasons: cancelReasons,
            notes: notes,
          );
    result.fold(
      (error) => emit(RiderCancelTripErrorState(error: error)),
      (message) => emit(RiderCancelTripSuccessState(message: message)),
    );
  }

  //! Accept Scheduled Trip Request
  Future<void> acceptScheduledTripRequest({required int requestId}) async {
    emit(RiderTripLoadingState());
    final response = await sl<DriverTripRepo>().driverAcceptShareTripRider(
      requestId: requestId,
    );
    response.fold(
      (error) => emit(RiderCancelTripErrorState(error: error.toString())),
      (message) => emit(state),
    );
  }

  //! Decline Rider Request
  Future<void> declineRiderRequest({required int requestId}) async {
    emit(RiderTripLoadingState());
    final response = await sl<DriverTripRepo>().driverCancelShareTrip(
      tripId: requestId,
    );
    response.fold(
      (error) => emit(RiderCancelTripErrorState(error: error.toString())),
      (message) => emit(state),
    );
  }

  @override
  Future<void> close() {
    isActive = false;
    _stopStatusTimer();
    tripDetailsSubscription?.cancel();
    driverLocationSubscription?.cancel();
    return super.close();
  }
}
