import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/sounds/sound_player.dart';
import '../../../driver_trip/data/repo/driver_trip_repo.dart';
import '../../../driver_trip/presentation/views/driver_trip_view.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';

part 'find_riders_state.dart';

class FindRidersCubit extends Cubit<FindRidersState> {
  FindRidersCubit(
    BuildContext context, {
    required int driverId,
    required this.acceptedTripTypeIds,
  }) : super(FindRidersInitial()) {
    getCurrentLocation();
    initRealTime(
      context,
      driverId: driverId,
    );
  }

  /// Trip type IDs the driver has enabled (from HomeCubit.driverTripTypes).
  final List<int> acceptedTripTypeIds;

  //! Accept Request
  Future<bool> acceptRide({required int id}) async {
    emit(AcceptRequestLoadingState());
    final result = await sl<DriverTripRepo>().acceptRequest(id: id);
    return result.fold(
      (error) {
        // Ride no longer available — remove it from the list
        rideRequests.removeWhere((ride) => ride.id == id || ride.rideId == id);
        _pendingRideSubscriptions.remove(id)?.cancel();
        emit(AcceptRequestErrorState(error: error));
        emit(RiderRemovedRecievedState());
        return false;
      },
      (message) {
        emit(AcceptRequestSuccessState(message: message));
        return true;
      },
    );
  }

  //! Ride Requests
  DatabaseReference? db;
  StreamSubscription<DatabaseEvent>? requestsSubscription;
  StreamSubscription<DatabaseEvent>? requestsChangedSubscription;
  StreamSubscription<DatabaseEvent>? requestsRemovedSubscription;
  final Map<int, StreamSubscription<DatabaseEvent>> _pendingRideSubscriptions =
      {};
  List<TripDetailsModel> rideRequests = [];

  void initRealTime(BuildContext context, {required int driverId}) {
    db = FirebaseDatabase.instance.ref("drivers/$driverId/assigned_rides");

    //! Request Added
    requestsSubscription = db!.onChildAdded.listen(
      (event) {
        try {
          final data = event.snapshot.value as Map?;
          if (!kReleaseMode) log("Added: ${data.toString()}");

          if (data != null) {
            final ride = TripDetailsModel.fromJson(data);
            // Filter: ignore trip types the driver has not selected
            if (acceptedTripTypeIds.isNotEmpty &&
                ride.tripTypeId != null &&
                !acceptedTripTypeIds.contains(ride.tripTypeId)) {
              return;
            }
            rideRequests.insert(0, ride);
            _watchPendingRide(ride.rideId ?? ride.id ?? 0);
            SoundPlayer.alertSound();
            emit(RiderRequestRecievedState());
          }
        } catch (e) {
          emit(RealTimeErrorState());
          if (!kReleaseMode) log("Error on Add: $e");
        }
      },
      onError: (error) {
        if (!kReleaseMode) log("Stream Error on Add: $error");
        emit(RealTimeErrorState());
      },
    );

    requestsChangedSubscription = db!.onChildChanged.listen((event) {
      try {
        final data = event.snapshot.value as Map?;
        if (!kReleaseMode) log("Changed: ${data.toString()}");

        if (data != null) {
          final status = data["status"]?.toString() ?? "";
          if (status == "accepted") {
            // navigateReplacement(
            //   context,
            //   DriverTripView(
            //     tripId: data["ride_id"],
            //     isClassicTrip: data["trip_type"] == "classic",
            //     isDeliveryTrip: data["trip_type"] == "delivery",
            //   ),
            // );
            // emit(RequestAcceptedState(
            //   tripId: data["ride_id"],
            //   tripType: data["trip_type"],
            // ));
            // rideRequests.removeWhere(
            //   (ride) => ride.id == data["id"] || ride.rideId == data["ride_id"],
            // );
          } else if (status == "cancelled" || status == "canceled") {
            rideRequests.removeWhere(
              (ride) => ride.id == data["id"] || ride.rideId == data["ride_id"],
            );
            emit(RiderRemovedRecievedState());
          }
        }
      } catch (e) {
        if (!kReleaseMode) log("Error on Change: $e");
      }
    });

    // ! Request Removed
    requestsRemovedSubscription = db!.onChildRemoved.listen((event) {
      try {
        final data = event.snapshot.value as Map?;
        final status = data?["status"]?.toString() ?? "";
        if (status == "accepted") {
           navigateReplacement(
            context,
            DriverTripView(
              tripId: data?["ride_id"],
              isClassicTrip: data?["trip_type"] == "classic",
              isDeliveryTrip: data?["trip_type"] == "delivery",
            ),
          );
          // emit(RequestAcceptedState(
          //   tripId: data["ride_id"],
          //   tripType: data["trip_type"],
          // ));
          // rideRequests.removeWhere(
          //   (ride) => ride.id == data["id"] || ride.rideId == data["ride_id"],
          // );
        } else {
          if (!kReleaseMode) log("Removed: ${data.toString()}");

          if (data != null) {
            final removedRide = TripDetailsModel.fromJson(data);
            rideRequests.removeWhere((ride) => ride.id == removedRide.id);
            emit(RiderRemovedRecievedState());
          }
        }
      } catch (e) {
        if (!kReleaseMode) log("Error on Remove: $e");
      }
    });
  }

  /// Watches trips/{rideId}. When status becomes canceled/cancelled/accepted
  /// by another driver, the request is removed from the list immediately.
  void _watchPendingRide(int rideId) {
    if (rideId == 0 || _pendingRideSubscriptions.containsKey(rideId)) return;
    final ref = FirebaseDatabase.instance.ref("trips/$rideId");
    _pendingRideSubscriptions[rideId] = ref.onValue.listen((event) {
      try {
        final data = event.snapshot.value as Map?;
        if (data == null) return;
        final status = data["status"]?.toString() ?? "";
        if (status == "canceled" || status == "cancelled"
            // ||
            // status == "accepted"
            ) {
          _pendingRideSubscriptions.remove(rideId)?.cancel();
          final before = rideRequests.length;
          rideRequests.removeWhere(
            (ride) => ride.rideId == rideId || ride.id == rideId,
          );
          if (rideRequests.length != before) emit(RiderRemovedRecievedState());
        }
      } catch (e) {
        if (!kReleaseMode) log("Error watching trip $rideId: $e");
      }
    });
  }

  void declineRequest({required int id}) {
    db?.child("$id").remove();
  }

  void retryRealTime(BuildContext context, {required int driverId}) {
    requestsSubscription?.cancel();
    requestsChangedSubscription?.cancel();
    requestsRemovedSubscription?.cancel();
    for (final sub in _pendingRideSubscriptions.values) {
      sub.cancel();
    }
    _pendingRideSubscriptions.clear();
    rideRequests.clear();
    emit(FindRidersInitial());
    initRealTime(context, driverId: driverId);
  }

  @override
  Future<void> close() {
    requestsSubscription?.cancel();
    requestsChangedSubscription?.cancel();
    requestsRemovedSubscription?.cancel();
    for (final sub in _pendingRideSubscriptions.values) {
      sub.cancel();
    }
    _pendingRideSubscriptions.clear();
    return super.close();
  }

  GoogleMapController? mapController;

  double? latitude;
  double? longitude;
  String? address;

  //! Save Current Location
  Future<void> getCurrentLocation() async {
    emit(FindRidersGetCurrentLocationLoadingState());

    // Get the device's current location using the location package
    final Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return; // location service not enabled
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return; // permission not granted
      }
    }

    // Get the current location
    final LocationData locationData = await location.getLocation();

    latitude = locationData.latitude;
    longitude = locationData.longitude;

    emit(FindRidersGetCurrentLocationSuccessState());
  }
}
