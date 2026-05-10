import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_strings.dart';
import '../models/preferences_model.dart';

class PreferencesRepo {
  final DioConsumer api;

  PreferencesRepo(this.api);

  //! Save Preferences
  Future<Either<String, String>> savePreferences({
    required bool coolRide,
    required bool quietRide,
    required bool smokingFriendly,
    required bool petsFree,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.preferences,
        data: {
          "cool_ride": coolRide,
          "quiet_ride": quietRide,
          "smoking_friendly": smokingFriendly,
          "pets_free": petsFree,
        },
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Get Preferences
  Future<Either<String, PreferencesModel>> getPreferences() async {
    try {
      final Response response = await api.get(
        EndPoints.preferences,
      );
      return Right(PreferencesModel.fromJson(response.data["data"]));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }
}
