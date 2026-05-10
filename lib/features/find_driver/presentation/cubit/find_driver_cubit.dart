import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/sounds/sound_player.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';
import '../../../rider_trip/data/repo/rider_trip_repo.dart';
import '../../data/models/notified_driver_model.dart';

part 'find_driver_state.dart';

class FindDriverCubit extends Cubit<FindDriverState> {
  FindDriverCubit({
    required this.tripDetails,
    required this.isDelivery,
    required this.isShareRide,
    String? createdAt,
  }) : super(FindDriverInitial()) {
    initRealTime();
    if (createdAt != null) {
      final createdDateTime = DateTime.parse(createdAt);
      final currentDateTime = DateTime.now();
      final difference = currentDateTime.difference(createdDateTime);
      log("Difference: ${difference.inSeconds}");
      timerSeconds = difference.inSeconds;
      if (timerSeconds! < 0) {
        timerSeconds = 0;
      }
    } else {
      timerSeconds = 0;
    }
  }

  DatabaseReference? db;
  DatabaseReference? dbNotifiedDrivers;
  List<TripDetailsModel> requests = [];
  List<NotifiedDriverModel> notifiedDrivers = [];

  void initRealTime() {
    db = FirebaseDatabase.instance
        .ref("ride_requests/${tripDetails?.rideId ?? 0}/drivers");

    dbNotifiedDrivers = FirebaseDatabase.instance
        .ref("trips/${tripDetails?.rideId ?? 0}/notified_drivers");

    //! Request Added
    db!.onChildAdded.listen((event) {
      try {
        final data = event.snapshot.value as Map?;

        if (data != null) {
          requests.add(TripDetailsModel.fromJson(data));
          SoundPlayer.alertSound();
          emit(RecieveDriverRequestState());
        }
      } catch (e) {
        if (!kReleaseMode) log("Error on Add: $e");
      }
    });

    //! Request Changed
    db!.onChildChanged.listen((event) {
      try {
        final data = event.snapshot.value as Map?;

        if (data != null) {
          requests.add(TripDetailsModel.fromJson(data));
          SoundPlayer.alertSound();
          emit(RecieveDriverRequestState());
        }
      } catch (e) {
        if (!kReleaseMode) log("Error on Add: $e");
      }
    });

    //! Request Removed
    db!.onChildRemoved.listen((event) {
      try {
        final data = event.snapshot.value as Map?;
        if (!kReleaseMode) log("Removed: ${data.toString()}");

        if (data != null) {
          // final removedRide = RideModel.fromJson(data);
          // rideRequests.removeWhere((ride) => ride.id == removedRide.id);
          // emit(RiderRemovedRecievedState());
        }
      } catch (e) {
        if (!kReleaseMode) log("Error on Remove: $e");
      }
    });

    //! Notified Drivers
    dbNotifiedDrivers!.onChildAdded.listen((event) {
      try {
        final data = event.snapshot.value as Map?;

        if (data != null) {
          notifiedDrivers.add(NotifiedDriverModel.fromJson(data));
          if (notifiedDrivers.length > 3) {
            notifiedDrivers.add(notifiedDrivers.removeAt(0));
          }
          emit(RecieveDriverRequestState());
        }
      } catch (e) {
        if (!kReleaseMode) log("Error on Add: $e");
      }
    });
  }

  //! Decline Driver
  Future<void> declineDriver({required int driverId}) async {
    db!.child(driverId.toString()).remove();
  }

  //! Accept Ride
  void acceptDriver({required int driverId}) async {
    emit(AcceptDriverLoadingState());
    final result = await sl<RiderTripRepo>().acceptDriver(
      tripId: tripDetails?.id ?? 0,
      driverId: driverId,
    );
    result.fold(
      (error) => emit(AcceptDriverErrorState(error: error)),
      (message) {
        removeDriverAssigned(driverId: driverId);
        emit(AcceptDriverSuccessState(message: message, driverId: driverId));
      },
    );
  }

  //! Cancel Trip
  Future<void> cancelTrip() async {
    emit(FindDriverCancelTripLoadingState());
    final result =
        await sl<RiderTripRepo>().cancelTrip(tripId: tripDetails?.rideId ?? 0);
    result.fold(
      (error) => emit(FindDriverCancelTripErrorState(error: error)),
      (message) => emit(FindDriverCancelTripSuccessState(message: message)),
    );
  }

  //! Remove Driver Assigned
  void removeDriverAssigned({required int driverId}) {
    sl<RiderTripRepo>().removeAssignedForDriver(
      rideId: tripDetails?.rideId ?? 0,
      driverId: driverId,
    );
  }

  //! Ride Type
  TripDetailsModel? tripDetails;
  bool isShareRide = false;
  bool isDelivery = false;
  bool isActive = true;

  // recieveRequest() {
  //   if (!isActive) return;
  //   Future.delayed(const Duration(seconds: 3), () {
  //     if (requests.length < 2) {
  //       requests.add("value");
  //     }
  //     if (!isActive) return;
  //     emit(RecieveRequestState());
  //     recieveRequest();
  //   });
  // }

  removeRequest(tripId) {
    if (isActive) {
      requests.removeWhere((e) => e.id == tripId);
      if (!isActive) return;
      emit(FindDriverInitial());
    }
  }

  //! Dragable Container
  bool isBottomContainerExpanded = false;

  bottomContainerExpandedToggle(bool value) {
    if (!isActive) return;
    isBottomContainerExpanded = value;
    if (!isActive) return;
    emit(BottomContainerExpandedToggleState());
  }

  //! Timer
  int? timerSeconds;

  @override
  Future<void> close() {
    isActive = false;
    return super.close();
  }
}
