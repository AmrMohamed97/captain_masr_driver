import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/imports/imports.dart';
import '../models/driver_preferences_model.dart';
import '../models/driver_today_summary_model.dart';

class HomeRepo {
  final DioConsumer api;

  HomeRepo(this.api);

  //! Sliders
  Future<Either<String, List<String>>> getSliders() async {
    try {
      final Response response = await api.get(
        EndPoints.sliders,
      );
      return Right((response.data["data"] as List?)
              ?.map((e) => e["image"]?.toString() ?? "")
              .toList() ??
          []);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Get Driver Preferences
  Future<Either<String, DriverPreferencesModel>> getDriverPreferences() async {
    try {
      final Response response = await api.get(EndPoints.driverPreferences);
      return Right(DriverPreferencesModel.fromJson(response.data["data"]));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Save Driver Preferences
  Future<Either<String, String>> saveDriverPreferences({
    required bool classicRide,
    required bool shareTrip,
    required bool groupTrip,
    required bool delivery,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.driverPreferences,
        data: {
          "classic_ride": classicRide,
          "share_trip": shareTrip,
          "group_trip": groupTrip,
          "delivery": delivery,
        },
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Driver Today Summary
  Future<Either<String, DriverTodaySummaryModel>> driverTodaySummary() async {
    try {
      final Response response = await api.get(
        EndPoints.driverTodaySummary,
      );
      return Right(DriverTodaySummaryModel.fromJson(response.data["data"]));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Driver Trip Types
  Future<Either<String, List<int>>> driverTripTypes() async {
    try {
      final Response response = await api.get(
        EndPoints.driverTripTypes,
      );
      return Right(
        (response.data["data"] as List?)
                ?.map((e) => int.parse("$e"))
                .toList() ??
            <int>[],
      );
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }
}
