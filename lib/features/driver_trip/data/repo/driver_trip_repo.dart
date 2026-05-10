import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/imports/imports.dart';
import '../models/complete_trip_response_model.dart';

class DriverTripRepo {
  final DioConsumer api;

  DriverTripRepo(this.api);

  //! Accept Request
  Future<Either<String, String>> acceptRequest({required int id}) async {
    try {
      final Response response = await api.post(
        "${EndPoints.driverAcceptRide}/$id",
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Trip Arrived
  Future<Either<String, String>> tripArriverd({required int tripId}) async {
    try {
      final Response response = await api.post(
        EndPoints.driverArrived.replaceAll("ID", "$tripId"),
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Trip Start
  Future<Either<String, String>> tripStart({
    required int tripId,
    required int? tripCode,
    MultipartFile? deliveryImageDriver,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.driverStartTrip.replaceAll("ID", "$tripId"),
        isFormData: true,
        data: {
          "trip_code": tripCode,
          "delivery_image_driver": deliveryImageDriver,
        },
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Trip Complete
  Future<Either<Failure, CompleteTripResponseModel>> tripComplete(
      {required int tripId}) async {
    try {
      final Response response = await api.post(
        EndPoints.driverCompleteTrip.replaceAll("ID", "$tripId"),
      );
      return Right(CompleteTripResponseModel.fromJson(
          response.data as Map<String, dynamic>));
    }catch (e) {
      debugPrint(e.toString());
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
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

  //! Post Share Trip
  Future<Either<String, Map>> postShareTrip({
    required String pickupAddress,
    required double pickupLatitude,
    required double pickupLongitude,
    required String dropoffAddress,
    required double dropoffLatitude,
    required double dropoffLongitude,
    required String status,
    required bool femaleRider,
    required bool babyCarriage,
    required String luggagesCount,
    required int seatsAvailable,
    required List<int> availableSeatsId,
    required String date,
    required String time,
    String? description,
    required String type,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.driverPostShareTrip,
        data: {
          "pickup_address": pickupAddress,
          "pickup_latitude": pickupLatitude,
          "pickup_longitude": pickupLongitude,
          "dropoff_address": dropoffAddress,
          "dropoff_latitude": dropoffLatitude,
          "dropoff_longitude": dropoffLongitude,
          "status": status,
          "female_rider": femaleRider,
          "baby_carriage": babyCarriage,
          "luggages_count": luggagesCount,
          "seats_available": seatsAvailable,
          "available_seets_id":
              availableSeatsId.isNotEmpty ? availableSeatsId : [1, 2, 3, 4],
          "date": date,
          "time": time,
          "description": description,
          "type": type
        },
      );
      return Right(response.data);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Start Share Trip
  Future<Either<String, String>> startShareTrip({required int tripId}) async {
    try {
      final Response response = await api.post(
        "${EndPoints.driverStartShareTrip}/$tripId",
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Start Share Trip With Riders
  Future<Either<String, String>> startShareTripWithRiders(
      {required int requestId}) async {
    try {
      final Response response = await api.post(
        "${EndPoints.driverStartShareTripWithRiders}/$requestId",
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Driver Arrived Share Trip
  Future<Either<String, String>> driverArrivedShareTrip(
      {required int requestId}) async {
    try {
      final Response response = await api.post(
        "${EndPoints.driverArrivedShareTrip}/$requestId",
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Complete Share Trip
  Future<Either<String, String>> completeShareTrip(
      {required int tripId}) async {
    try {
      final Response response = await api.post(
        "${EndPoints.driverCompleteShareTrip}/$tripId",
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Complete Share Trip With Riders
  Future<Either<Failure, String>> driverCompleteShareTripWithRiders(
      {required int requestId}) async {
    try {
      final Response response = await api.post(
        "${EndPoints.driverCompleteShareTripWithRiders}/$requestId",
      );
      return Right(response.data["message"]);
    }catch (e) {
      debugPrint(e.toString());
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  //! Driver Accept Share Trip Rider
  Future<Either<String, String>> driverAcceptShareTripRider({
    required int requestId,
  }) async {
    try {
      final Response response = await api.post(
        "${EndPoints.driverAcceptShareTripRider}/$requestId",
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Driver Cancel Share Trip
  Future<Either<String, String>> driverCancelShareTrip({
    required int tripId,
    List<String>? cancelReasons,
    String? notes,
  }) async {
    try {
      final Response response = await api.post(
        "${EndPoints.driverCancelShareTrip}/$tripId",
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

  //! Driver Cancel Share Trip With Rider
  Future<Either<String, String>> driverCancelShareTripWithRider({
    required int requestId,
    List<String>? cancelReasons,
    String? notes,
  }) async {
    try {
      final Response response = await api.post(
        "${EndPoints.driverCancelShareTripWithRiders}/$requestId",
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
}
