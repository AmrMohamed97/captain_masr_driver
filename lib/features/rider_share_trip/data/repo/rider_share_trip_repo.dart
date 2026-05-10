import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/imports/imports.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';
import '../models/rider_available_share_trips_model.dart';

class RiderShareTripRepo {
  final DioConsumer api;

  RiderShareTripRepo(this.api);


  //! Calculate Estimated
  Future<Either<String, TripDetailsModel>> calculateEstimated({
    required int tripTypeId,
    required int vehilceCategoryId,
    required String pickupAddress,
    required double pickupLatitude,
    required double pickupLongitude,
    required String dropoffAddress,
    required double dropoffLatitude,
    required double dropoffLongitude,
    required List<LatLng> stops,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.userTripEstimate,
        data: {
          "trip_type_id": tripTypeId,
          "vehicle_category_id": vehilceCategoryId,
          "pickup_address": pickupAddress,
          "pickup_latitude": pickupLatitude,
          "pickup_longitude": pickupLongitude,
          "dropoff_address": dropoffAddress,
          "dropoff_latitude": dropoffLatitude,
          "dropoff_longitude": dropoffLongitude,
          "stops": stops
              .map((e) => {"latitude": e.latitude, "longitude": e.longitude})
              .toList(),
        },
      );
      return Right(TripDetailsModel.fromJson(response.data["data"]));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Accept Driver
  Future<Either<String, String>> acceptDriver(
      {required int tripId, required int driverId}) async {
    try {
      final Response response = await api.post(
        "${EndPoints.userAcceptDriver}/$tripId/$driverId",
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Cancel Trip
  Future<Either<String, String>> cancelTrip({
    required int tripId,
    List<String>? cancelReasons,
    String? notes,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.cancelTrip.replaceAll("tripId", tripId.toString()),
        data: {
          "cancel_reasons": cancelReasons,
          "notes": notes,
        },
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Search Share Rides
  Future<Either<String, RiderAvailableShareTripsModel>> searchShareRides({
    required int page,
    required double pickupLatitude,
    required double pickupLongitude,
    required double dropoffLatitude,
    required double dropoffLongitude,
    required String date,
    required int vehicleCategoryId,
    required List<int> seatsIds,
  }) async {
    try {
      // print('data================================================');
      // print(pickupLatitude);
      // print(pickupLongitude);
      // print(dropoffLatitude);
      // print(dropoffLongitude);
      // print(date);
      // print(seatsIds);
      final Response response = await api.get(
        EndPoints.riderSearchShareRides,
        queryParameters: {"page": page},
        data: {
          "pickup_latitude": pickupLatitude,
          "pickup_longitude": pickupLongitude,
          "dropoff_latitude": dropoffLatitude,
          "dropoff_longitude": dropoffLongitude,
          "date": date,
          "vehicle_category_id": vehicleCategoryId,
          "trip_type_id": 3,
          "seets_id": seatsIds,
        },
      );
      return Right(RiderAvailableShareTripsModel.fromJson(response.data["data"]));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Request Share Trip
  Future<Either<String, String>> requestShareTrip({
    required int shareRideId,
    required int seatsCount,
    required List<int> seatsIds,
    required int mainPaymentMethodId,
    int? subPaymentMethodId,
    required String pickupAddress,
    required double pickupLatitude,
    required double pickupLongitude,
    required String dropoffAddress,
    required double dropoffLatitude,
    required double dropoffLongitude,
    required int vehicleCategoryId,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.riderRequestShareTrip,
        data: {
          "share_ride_id": shareRideId,
          "seats_count": seatsCount,
          "seats_ids": seatsIds,
          "main_payment_method_id": mainPaymentMethodId,
          "sub_payment_method_id": subPaymentMethodId,
          "pickup_address": pickupAddress,
          "pickup_latitude": pickupLatitude,
          "pickup_longitude": pickupLongitude,
          "dropoff_address": dropoffAddress,
          "dropoff_latitude": dropoffLatitude,
          "dropoff_longitude": dropoffLongitude,
          "vehicle_category_id": vehicleCategoryId,
          "trip_type_id": 3
        },
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Cancel Share Trip
  Future<Either<String, String>> cancelShareTrip({
    required int shareTripId,
    required List<String>? cancelReasons,
    required String? notes,
  }) async {
    try {
      final Response response = await api.post(
        "${EndPoints.riderCancelShareTrip}/$shareTripId",
        data: {
          "cancel_reasons": cancelReasons,
          "notes": notes,
        },
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Remove Assigned For Driver
  Future<void> removeAssignedForDriver({
    required int rideId,
    required int driverId,
  }) async {
    try {
      await api.post(
        "${EndPoints.removeAssignedForDriver}/$rideId/$driverId",
      );
    } catch (e) {
      log("Error removing assigned for driver: ${e.toString()}");
    }
  }
}
