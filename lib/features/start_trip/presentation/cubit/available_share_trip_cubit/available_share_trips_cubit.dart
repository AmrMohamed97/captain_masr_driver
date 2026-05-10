import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

import '../../../../../core/imports/imports.dart';
import '../../../../base/data/models/pagination_model.dart';
import '../../../../rider_trip/data/models/share_trip_model.dart';
import '../../../../rider_trip/data/models/trip_details_model.dart';
import '../../../../rider_trip/data/repo/rider_trip_repo.dart';
import '../../../../schedule_trip/data/repo/schedule_trip_repo.dart';
import '../../../data/models/rider_share_trip_data_model.dart';

part 'available_share_trips_state.dart';

class AvailableShareTripsCubit extends Cubit<AvailableShareTripsState> {
  AvailableShareTripsCubit({
    this.isScheduled = false,
  }) : super(AvailableShareTripsInitial());

  bool isScheduled;

  //! Realtime
  DatabaseReference? tripsRef;
  StreamSubscription<DatabaseEvent>? tripsStream;

  Future<void> initRealtime({required int riderId}) async {
    // if (isScheduled) return;
    tripsRef =
        FirebaseDatabase.instance.ref("share_trips_user_requests/$riderId");
    tripsStream = tripsRef!.onChildChanged.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        log("Trip Details: $data");
        final TripDetailsModel model = TripDetailsModel.fromJson(data);
        print("==============================================================");
        print("model status: ${model.status}");
        if (model.status == 'accepted') {
          if (isScheduled) {
            final int index =
              trips.indexWhere((trip) => trip.id == model.shareRideId);

          if (index != -1) {
            trips[index].requestStatus = model.status;
            print(
                "Status updated for trip ${model.shareRideId}: ${model.status}");
          }
          emit(GetAvailableShareTripsSuccessState());
          }else{
          emit(DriverAcceptTrip(tripId: model.shareRideId ?? 0));
          }
        }
        if (model.status == 'cancelled' ||
            model.status == 'canceled' ||
            model.status == 'canclled' ||
            model.status == 'cancled' ||
            model.status == 'rejected' ||
            model.status == 'refused') {
          final int index =
              trips.indexWhere((trip) => trip.id == model.shareRideId);

          if (index != -1) {
            trips[index].requestStatus = model.status;
            print(
                "Status updated for trip ${model.shareRideId}: ${model.status}");
          } else {
            print(
                "Matching failed: Trip ID ${model.shareRideId} not found in trips list. Available IDs: ${trips.map((e) => e.id).toList()}");
          }
          emit(GetAvailableShareTripsSuccessState());
        }
      }
    });
  }

  //! Paginaiton
  void initPagination() {
    const double scrollThreshold = 500.0;
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
              (scrollController.position.maxScrollExtent - scrollThreshold) &&
          state is! GetAvailableShareTripsLoadingState) {
        if ((pagination?.lastPage ?? 0) > currentPage) {
          riderSearchShareRides();
        }
      }
    });
  }

  ScrollController scrollController = ScrollController();
  int currentPage = 0;
  PaginationModel? pagination;

  late RiderShareTripDataModel shareTripData;

  //! Rider Search Share Rides
  List<ShareTripModel> trips = [];
  //!  get available share trips based on user location
  Future<void> riderSearchShareRides() async {
    print("trip data======================================");
    print(shareTripData.pickupLatitude);
    print(shareTripData.pickupLongitude);
    print(shareTripData.dropoffLatitude);
    print(shareTripData.dropoffLongitude);
    print(shareTripData.date);
    print(shareTripData.dates);
    print(shareTripData.vehicleCategoryId);
    print(shareTripData.seatsIds);
    emit(GetAvailableShareTripsLoadingState());
    final result = isScheduled
        ? await sl<ScheduleTripRepo>().userSearchScheduledTrips(
            page: currentPage + 1,
            pickupLatitude: shareTripData.pickupLatitude,
            pickupLongitude: shareTripData.pickupLongitude,
            dropoffLatitude: shareTripData.dropoffLatitude,
            dropoffLongitude: shareTripData.dropoffLongitude,
            dates: shareTripData.dates ?? [],
            time: shareTripData.time ?? "",
            vehicleCategoryId: shareTripData.vehicleCategoryId,
            seatsIds: shareTripData.seatsIds,
          )
        : await sl<RiderTripRepo>().searchShareRides(
            page: currentPage + 1,
            pickupLatitude: shareTripData.pickupLatitude,
            pickupLongitude: shareTripData.pickupLongitude,
            dropoffLatitude: shareTripData.dropoffLatitude,
            dropoffLongitude: shareTripData.dropoffLongitude,
            date: shareTripData.date ?? "",
            vehicleCategoryId: shareTripData.vehicleCategoryId,
            seatsIds: shareTripData.seatsIds,
          );
    result.fold(
      (error) => emit(AvailableShareTripsErrorState(error: error)),
      (model) {
        trips += model.trips;
        currentPage += 1;
        pagination = model.pagination;
        emit(GetAvailableShareTripsSuccessState());
      },
    );
  }

  //! Rider Request Share Trip
  Future<void> riderRequestShareTrip({required int id,required List<int> availableSeatIds}) async {
    print("request data======================================");
    print(shareTripData.pickupLatitude);
    print(shareTripData.pickupLongitude);
    print(shareTripData.dropoffLatitude);
    print(shareTripData.dropoffLongitude);
    print(shareTripData.date);
    print(shareTripData.vehicleCategoryId);
    print(shareTripData.seatsIds);
    print(shareTripData.mainPaymentMethodId);
    print(shareTripData.subPaymentMethodId);
    print(shareTripData.time);
    print(shareTripData.dates);
    print(shareTripData.seatsCount);
    print(id);
    emit(AvailableShareTripsLoadingState());
    final result = isScheduled
        ? await sl<ScheduleTripRepo>().userRequestScheduledTrip(
            tripId: id,
            pickupAddress: shareTripData.pickupAddress,
            pickupLatitude: shareTripData.pickupLatitude,
            pickupLongitude: shareTripData.pickupLongitude,
            dropoffAddress: shareTripData.dropoffAddress,
            dropoffLongitude: shareTripData.dropoffLongitude,
            dropoffLatitude: shareTripData.dropoffLatitude,
            vehicleCategoryId: shareTripData.vehicleCategoryId,
            seatsCount: shareTripData.seatsCount,
            seatsIds: availableSeatIds,//shareTripData.seatsIds,
            mainPaymentMethodId: shareTripData.mainPaymentMethodId,
            subPaymentMethodId: shareTripData.subPaymentMethodId,
            time: shareTripData.time ?? "",
            dates: shareTripData.dates ?? [],
          )
        : await sl<RiderTripRepo>().requestShareTrip(
            shareRideId: id,
            seatsCount: shareTripData.seatsCount,
            seatsIds: availableSeatIds,//shareTripData.seatsIds,
            mainPaymentMethodId: shareTripData.mainPaymentMethodId,
            pickupAddress: shareTripData.pickupAddress,
            pickupLatitude: shareTripData.pickupLatitude,
            pickupLongitude: shareTripData.pickupLongitude,
            dropoffAddress: shareTripData.dropoffAddress,
            dropoffLatitude: shareTripData.dropoffLatitude,
            dropoffLongitude: shareTripData.dropoffLongitude,
            vehicleCategoryId: shareTripData.vehicleCategoryId,
          );
    result.fold(
      (error) => emit(AvailableShareTripsErrorState(error: error)),
      (message) {
        final int index = trips.indexWhere((trip) => trip.id == id);

        if (index != -1) {
          trips[index].requestStatus = 'pending';
        }
        emit(AvailableShareTripsSuccessState(message: message));
      },
    );
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    tripsStream?.cancel();
    return super.close();
  }
}
