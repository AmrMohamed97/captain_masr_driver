import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../base/data/models/pagination_list_model.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';
import '../models/canceled_trip_model.dart';

class TripsRepo {
  final DioConsumer api;

  TripsRepo(this.api);

  //! Get Completed Trips
  Future<Either<String, PaginationListModel>> getCompletedTrips({
    required int page,
    required bool isRider,
    int? limit,
  }) async {
    try {
      final Response response = await api.get(
        isRider ? EndPoints.userCompletedTrips : EndPoints.driverCompletedTrips,
        queryParameters: {
          "page": page,
          "limit": limit,
        },
      );
      return Right(
        PaginationListModel.fromJson(response.data["data"])
          ..data = (response.data["data"]["data"] as List?)
                  ?.map((e) => TripDetailsModel.fromJson(e))
                  .toList() ??
              <TripDetailsModel>[],
      );
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Get Canceled Trips
  Future<Either<String, PaginationListModel>> getCanceledTrips({
    required int page,
    required bool isRider,
  }) async {
    try {
      final Response response = await api.get(
        isRider ? EndPoints.userCanceledTrips : EndPoints.driverCanceledTrips,
        queryParameters: {"page": page},
      );
      return Right(
        PaginationListModel.fromJson(response.data["data"])
          ..data = (response.data["data"]["data"] as List?)
                  ?.map((e) => CanceledTripModel.fromJson(e))
                  .toList() ??
              <CanceledTripModel>[],
      );
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Get User Scheduled Trips
  Future<Either<String, PaginationListModel>> getScheduleTrips({
    required bool isRider,
    required int page,
  }) async {
    try {
      final Response response = await api.get(
        isRider
            ? EndPoints.getUserScheduleTrips
            : EndPoints.getDriverScheduleTrips,
        queryParameters: {
          "page": page,
        },
      );
      return Right(
        PaginationListModel.fromJson(response.data["data"])
          ..data = (response.data["data"]["data"] as List?)
                  ?.map((e) => TripDetailsModel.fromJson(e))
                  .toList() ??
              <TripDetailsModel>[],
      );
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }
}
