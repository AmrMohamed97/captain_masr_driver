import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_strings.dart';
import '../models/saved_place_model.dart';

class SavedPlacesRepo {
  final DioConsumer api;

  SavedPlacesRepo(this.api);

  //! Get Saved Locations
  Future<Either<String, List<SavedPlaceModel>>> getSavedLocations() async {
    try {
      final Response response = await api.get(EndPoints.savedLocations);
      return Right(
        (response.data["data"] as List?)
                ?.map((e) => SavedPlaceModel.fromJson(e))
                .toList() ??
            <SavedPlaceModel>[],
      );
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Save Location
  Future<Either<String, String>> saveLocation({
    required String type,
    required String? address,
    required String lat,
    required String long,
    required int? iconType,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.savedLocations,
        isFormData: true,
        data: {
          "type": type,
          "address": address,
          "lat": lat,
          "long": long,
          "icon_type": iconType,
        },
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Edit Location
  Future<Either<String, String>> editLocation({
    required int id,
    required String? type,
    required String? address,
    required String lat,
    required String? long,
    required int? iconType,
  }) async {
    try {
      final Response response = await api.post(
        "${EndPoints.savedLocations}/$id",
        isFormData: true,
        data: {
          "type": type,
          "address": address,
          "lat": lat,
          "long": long,
          "icon_type": iconType,
        },
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Delete Saved Location
  Future<Either<String, String>> deleteSavedLocation({
    required int locationId,
  }) async {
    try {
      final Response response = await api.delete(
        "${EndPoints.savedLocations}/$locationId",
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }
}
