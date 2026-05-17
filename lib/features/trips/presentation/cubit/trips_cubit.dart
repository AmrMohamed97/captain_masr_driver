import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/imports/imports.dart';
import '../../../base/data/models/pagination_model.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';
import '../../../rider_trip/data/repo/rider_trip_repo.dart';
import '../../data/models/canceled_trip_model.dart';
import '../../data/repo/trips_repo.dart';

part 'trips_state.dart';

class TripsCubit extends Cubit<TripsState> {
  TripsCubit({
    required this.userId,
    required this.isRider,
  }) : super(TripsInitial()) {
    initPagination();
    initTripDetailsRealTime();
  }

  int userId;
  bool isRider;

  //! Onging Trips Realtime
  List<TripDetailsModel> ongoingTrips = [];
  DatabaseReference? dbOngoingTrips;
  StreamSubscription<DatabaseEvent>? tripDetailsSubscription;
  StreamSubscription<DatabaseEvent>? tripChangesSubscription;
  void initTripDetailsRealTime() async {
    ongoingTrips.clear();
    tripDetailsSubscription?.cancel();
    tripChangesSubscription?.cancel();
    emit(state);

    dbOngoingTrips = isRider
        ? FirebaseDatabase.instance.ref("rider_trips/$userId")
        : FirebaseDatabase.instance.ref("drivers/$userId/ingoing");

    tripDetailsSubscription = dbOngoingTrips?.onValue.listen((event) {
      try {
        final data = event.snapshot.value;

        if (!kReleaseMode) log("Trips: ${data.toString()}");

        if (data == null) {
          ongoingTrips.clear();
          emit(TripsSuccessState());
        }

        if (data != null && data is List) {
          ongoingTrips = data
              .where((tripData) => tripData != null)
              .map((tripData) => TripDetailsModel.fromJson(tripData as Map))
              .toList();

          emit(TripsSuccessState());
        }

        if (data != null && data is Map) {
          ongoingTrips = data
              .map((key, value) =>
                  MapEntry(key, TripDetailsModel.fromJson(value as Map)))
              .values
              .toList();

          emit(TripsSuccessState());
        }
      } catch (e) {
        if (!kReleaseMode) log("Error on Add: $e");
      }
    });

    tripChangesSubscription = dbOngoingTrips?.onChildChanged.listen((event) {
      try {
        final data = event.snapshot.value as Map?;
        if (!kReleaseMode) log("Trip Changed: ${data.toString()}");

        if (data != null) {
          final tripData = TripDetailsModel.fromJson(data);
          final existingIndex =
              ongoingTrips.indexWhere((trip) => trip.id == tripData.id);

          if (existingIndex != -1) {
            ongoingTrips[existingIndex] = tripData;
          } else {
            ongoingTrips.add(tripData);
          }

          emit(TripsSuccessState());
        }
      } catch (e) {
        if (!kReleaseMode) log("Error on Change: $e");
      }
    });
  }

  //! Pagination
  ScrollController scrollController = ScrollController();
  PaginationModel? pagination;
  int page = 0;
  void initPagination() {
    const double scrollThreshold = 250.0;
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
              (scrollController.position.maxScrollExtent - scrollThreshold) &&
          state is! TripsLoadingState) {
        if ((pagination?.lastPage ?? 0) > page) {
          switch (selectedTapBar) {
            case 1:
              getCompletedTrips();
            case 2:
              getCompletedShareTrips();
            case 4:
              getCanceledTrips();
            default:
          }
        }
      }
    });
  }

  //! Get Completed Trips
  List<TripDetailsModel> completedTrips = [];
  Future<void> getCompletedTrips() async {
    emit(TripsLoadingState());
    final result = await sl<TripsRepo>().getCompletedTrips(
      page: page + 1,
      isRider: isRider,
    );
    result.fold(
      (error) => emit(TripsErrorState(error: error)),
      (model) {
        completedTrips += model.data as List<TripDetailsModel>;
        pagination = model.pagination;
        page += 1;
        emit(TripsSuccessState());
      },
    );
  }

  //! Get Completed Share/Group Trips
  List<TripDetailsModel> completedShareTrips = [];
  Future<void> getCompletedShareTrips() async {
    emit(TripsLoadingState());
    final result = await sl<TripsRepo>().getCompletedTrips(
      page: page + 1,
      isRider: isRider,
      type: "share_trips",
    );
    result.fold(
      (error) => emit(TripsErrorState(error: error)),
      (model) {
        completedShareTrips += model.data as List<TripDetailsModel>;
        pagination = model.pagination;
        page += 1;
        emit(TripsSuccessState());
      },
    );
  }

  //! Get Scheduled Trips
  List<TripDetailsModel> scheduledTrips = [];
  Future<void> getScheduledTrips() async {
    emit(TripsLoadingState());
    final result = await sl<TripsRepo>().getScheduleTrips(
      isRider: isRider,
      page: page + 1,
    );
    result.fold(
      (error) => emit(TripsErrorState(error: error)),
      (model) {
        scheduledTrips += model.data as List<TripDetailsModel>;
        pagination = model.pagination;
        page += 1;
        emit(TripsSuccessState());
      },
    );
  }

  //! Get Canceled Trips
  List<CanceledTripModel> canceledTrips = [];
  Future<void> getCanceledTrips() async {
    emit(TripsLoadingState());
    final result = await sl<TripsRepo>().getCanceledTrips(
      page: page + 1,
      isRider: isRider,
    );
    result.fold(
      (error) => emit(TripsErrorState(error: error)),
      (model) {
        canceledTrips += model.data as List<CanceledTripModel>;
        canceledTrips.removeWhere((e) => e.ride == null);
        pagination = model.pagination;
        page += 1;
        emit(TripsSuccessState());
      },
    );
  }

  //! Cancel Trip
  Future<void> cancelTrip({
    required int tripId,
  }) async {
    emit(TripsCancelTripLoadingState());
    final result = await sl<RiderTripRepo>().cancelTrip(
      tripId: tripId,
    );
    result.fold(
      (error) => emit(TripsErrorState(error: error)),
      (message) => emit(TripsSuccessState(message: message)),
    );
  }

  //! Refresh
  Future<void> onRefresh() async {
    pagination = null;
    page = 0;
    completedTrips.clear();
    completedShareTrips.clear();
    scheduledTrips.clear();
    canceledTrips.clear();
    switch (selectedTapBar) {
      case 0:
        return initTripDetailsRealTime();
      case 1:
        return await getCompletedTrips();
      case 2:
        return await getCompletedShareTrips();
      case 3:
        return await getScheduledTrips();
      case 4:
        return await getCanceledTrips();
      default:
        return;
    }
  }

  //! Tap Bar
  int selectedTapBar = 0;

  selectTapBar(int index) {
    selectedTapBar = index;
    pagination = null;
    page = 0;
    completedTrips.clear();
    completedShareTrips.clear();
    canceledTrips.clear();
    scrollController.jumpTo(0);
    emit(TripsSelectTapBarState());
    switch (index) {
      //! On Going
      case 0:
        return;
      //! Completed
      case 1:
        getCompletedTrips();
      //! Completed Share
      case 2:
        getCompletedShareTrips();
      //! schedule Trip
      case 3:
        getScheduledTrips();
        return;
      //! Canceled Trips
      case 4:
        getCanceledTrips();

      default:
        return;
    }
  }

  @override
  Future<void> close() {
    tripDetailsSubscription?.cancel();
    tripChangesSubscription?.cancel();
    return super.close();
  }
}
