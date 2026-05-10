import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../rider_trip/data/models/available_share_trips_model.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';
import '../models/trip_estimation_model.dart';

class ScheduleTripRepo {
  final DioConsumer api;

  ScheduleTripRepo(this.api);

  //! Driver Post Trip
  Future<Either<String, TripDetailsModel>> driverPostTrip({
    required String pickupAddress,
    required double pickupLatitude,
    required double pickupLongitude,
    required String dropoffAddress,
    required double dropoffLatitude,
    required double dropoffLongitude,
    required int seatsCount,
    required List<int> availableSeetsId,
    required String dateFrom,
    required String dateTo,
    required String time,
    required String description,
    required String type,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.driverPostScheduleTrip,
        isFormData: true,
        data: {
          "pickup_address": pickupAddress,
          "pickup_latitude": pickupLatitude,
          "pickup_longitude": pickupLongitude,
          "dropoff_address": dropoffAddress,
          "dropoff_latitude": dropoffLatitude,
          "dropoff_longitude": dropoffLongitude,
          "available_seets_id[]": availableSeetsId,
          "seats_count": seatsCount,
          "date_from": dateFrom,
          "date_to": dateTo,
          "time": time,
          "description": description,
          "type": type,
        },
      );
      return Right(TripDetailsModel.fromJson(response.data["data"]));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! User Request Scheduled Trip
  Future<Either<String, String>> userRequestScheduledTrip({
    required int tripId,
    required String pickupAddress,
    required double pickupLatitude,
    required double pickupLongitude,
    required String dropoffAddress,
    required double dropoffLongitude,
    required double dropoffLatitude,
    required int vehicleCategoryId,
    required int seatsCount,
    required List<int> seatsIds,
    required int mainPaymentMethodId,
    required int? subPaymentMethodId,
    required String time,
    required List<String> dates,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.userRequestScheduledTrip,
        isFormData: true,
        data: {
          "share_ride_id": tripId,
          "seats_count": seatsCount,
          "seats_ids[]": seatsIds,
          "main_payment_method_id": mainPaymentMethodId,
          "sub_payment_method_id": subPaymentMethodId,
          "pickup_address": pickupAddress,
          "pickup_latitude": pickupLatitude,
          "pickup_longitude": pickupLongitude,
          "dropoff_address": dropoffAddress,
          "dropoff_latitude": dropoffLatitude,
          "dropoff_longitude": dropoffLongitude,
          "vehicle_category_id": vehicleCategoryId,
          "dates[]": dates,
          "time": time,
          "trip_type_id": 1,
        },
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! User Search Scheduled Trips
  Future<Either<String, AvailableShareTripsModel>> userSearchScheduledTrips({
    required double pickupLatitude,
    required double pickupLongitude,
    required double dropoffLatitude,
    required double dropoffLongitude,
    required List<String> dates,
    required String time,
    required int vehicleCategoryId,
    required List<int> seatsIds,
    required int page,
  }) async {
    try {
      log("Time: $time");
      final Response response = await api.get(
        EndPoints.riderSearchScheduledTrips,
        queryParameters: {"page": page},
        data: {
          "pickup_latitude": pickupLatitude,
          "pickup_longitude": pickupLongitude,
          "dropoff_latitude": dropoffLatitude,
          "dropoff_longitude": dropoffLongitude,
          "dates": dates,
          "time": time,
          "vehicle_category_id": vehicleCategoryId,
          "seats_id[]": seatsIds,
          "trip_type_id": 1,
          "per_page": 10,
        },
      );
      return Right(AvailableShareTripsModel.fromJson(response.data["data"]));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Driver Cancel All Schedule Trip
  Future<Either<String, String>> driverCancelAllScheduleTrip({
    required int tripId,
    required List<String> cancelReasons,
    required String notes,
  }) async {
    try {
      final Response response = await api.post(
        "${EndPoints.driverCancelAllScheduleTrip}/$tripId",
        data: {"cancel_reasons": cancelReasons, "notes": notes},
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Driver Cancel Schedule Trip For Rider
  Future<Either<String, String>> driverCancelScheduleTripForRider({
    required int tripId,
    required List<String> cancelReasons,
    required String notes,
  }) async {
    try {
      final Response response = await api.post(
        "${EndPoints.driverCancelScheduleTripForRider}/$tripId",
        data: {"cancel_reasons": cancelReasons, "notes": notes},
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }
    //! Calculate Estimated
  Future<Either<String, TripEstimationModel>> calculateEstimated({
    required int tripTypeId,
    required int vehilceCategoryId,
    required String pickupAddress,
    required double pickupLatitude,
    required double pickupLongitude,
    required String dropoffAddress,
    required double dropoffLatitude,
    required double dropoffLongitude,
    required List<LatLng> stops,
    required int? seatsNeeded,
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
          "seats_needed":seatsNeeded,
          "stops": stops
              .map((e) => {"latitude": e.latitude, "longitude": e.longitude})
              .toList(),
        },
      );
      print(response.data["data"]);
      print(response.data["data"]["total_price"]);
      print(response.data["data"]["price"]);
      print(TripEstimationModel.fromJson(response.data["data"]).toJson());
      return Right(TripEstimationModel.fromJson(response.data as Map<String, dynamic>));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }
}
