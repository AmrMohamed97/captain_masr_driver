import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/imports/imports.dart';
import '../../../delivery/data/models/delivery_details_model.dart';
import '../models/available_share_trips_model.dart';
import '../models/trip_details_model.dart';

class RiderTripRepo {
  final DioConsumer api;

  RiderTripRepo(this.api);

  //! Request Classic Trip
  Future<Either<String, TripDetailsModel>> requestClassicTrip({
    required int vehicleCategoryId,
    required String pickupAddress,
    required double pickupLatitude,
    required double pickupLongitude,
    required String dropoffAddress,
    required double dropoffLatitude,
    required double dropoffLongitude,
    required List<LatLng> stops,
    required bool? femaleDriver,
    required bool? babyCarriage,
    required bool? luggages,
    required int? smallLuggaes,
    required int? mediumLuggaes,
    required int? largeLuggaes,
    required String? promoCode,
    required int mainPaymentMethodId,
    required int? subPaymentMethodId,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.userRequestClassic,
        isFormData: true,
        data: {
          "dropoff_address": dropoffAddress,
          "dropoff_latitude": dropoffLatitude,
          "trip_type_id": 1,
          "vehicle_category_id": vehicleCategoryId,
          "pickup_address": pickupAddress,
          "pickup_latitude": pickupLatitude,
          "pickup_longitude": pickupLongitude,
          "dropoff_longitude": dropoffLongitude,
          "stops": stops
              .map((e) => {"latitude": e.latitude, "longitude": e.longitude})
              .toList(),
          "female_driver": femaleDriver ?? false,
          "baby_carriage": babyCarriage ?? false,
          "luggages": luggages ?? false,
          "small_count": smallLuggaes ?? 0,
          "medium_count": mediumLuggaes ?? 0,
          "large_count": largeLuggaes ?? 0,
          "promo_code": promoCode,
          "main_payment_method_id": mainPaymentMethodId,
          "sub_payment_method_id": subPaymentMethodId,
        },
      );
      return Right(TripDetailsModel.fromJson(response.data["data"]));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Request Delivery Trip
  Future<Either<String, TripDetailsModel>> requestDeliveryTrip({
    required int vehicleCategoryId,
    required String pickupAddress,
    required double pickupLatitude,
    required double pickupLongitude,
    required String dropoffAddress,
    required double dropoffLatitude,
    required double dropoffLongitude,
    required List<LatLng> stops,
    required DeliveryDetailsModel deliveryDetails,
    required String? promoCode,
    required int mainPaymentMethodId,
    required int? subPaymentMethodId,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.userRequestClassic,
        isFormData: true,
        data: {
          "trip_type_id": 4,
          "vehicle_category_id": vehicleCategoryId,
          "pickup_address": pickupAddress,
          "pickup_latitude": pickupLatitude,
          "pickup_longitude": pickupLongitude,
          "dropoff_address": dropoffAddress,
          "dropoff_latitude": dropoffLatitude,
          "dropoff_longitude": dropoffLongitude,
          "stops": stops
              .map((e) => {"latitude": e.latitude, "longitude": e.longitude})
              .toList(),
          "deliver_type": deliveryDetails.deliveryType,
          "deliver_item_id": deliveryDetails.deliveryItemId,
          "deliver_item_size_id": deliveryDetails.deliveryItemSizeId,
          "payment_of_deliver_type": deliveryDetails.paymentType,
          "notes": deliveryDetails.note ?? "",
          "delivery_image": await uploadImageToApi(deliveryDetails.image),
          "promo_code": promoCode,
          "main_payment_method_id": mainPaymentMethodId,
          "sub_payment_method_id": subPaymentMethodId,
        },
      );
      return Right(TripDetailsModel.fromJson(response.data["data"]));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

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
      print(TripDetailsModel.fromJson(response.data["data"]).toMap());
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
      //status of trip changed from pending to accepted in assign_trip
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
  Future<Either<String, AvailableShareTripsModel>> searchShareRides({
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
      return Right(AvailableShareTripsModel.fromJson(response.data["data"]));
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
