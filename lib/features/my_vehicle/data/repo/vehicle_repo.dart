import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../base/data/models/pagination_list_model.dart';
import '../models/driver_vehicle_model.dart';
import '../models/seat_model.dart';
import '../models/vehicle_brand_model.dart';
import '../models/vehicle_category_model.dart';
import '../models/vehicle_color_model.dart';
import '../models/vehicle_model_model.dart';
import '../models/vehicle_type_model.dart';

class VehicleRepo {
  final DioConsumer api;

  VehicleRepo(this.api);

  //! Get Driver Vehicle
  Future<Either<String, DriverVehicleModel>> getDriverVehicle() async {
    try {
      final Response response = await api.get(EndPoints.driverVehicle);
      return Right(DriverVehicleModel.fromJson(response.data["data"]));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Update Driver Vehicle
  Future<Either<String, String>> updateDriverVehicle({
    required int? vehicleCategoryId,
    required int? vehicleTypeId,
    required int? vehicleBrandId,
    required int? vehicleModelId,
    required int? vehicleColorId,
    required String? plateNumber,
    required MultipartFile? vehicleLicense,
    required String? vehicleLicensEexpiry,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.updateDriverVehicle,
        isFormData: true,
        data: {
          "vehicle_category_id": vehicleCategoryId,
          "vehicle_type_id": vehicleTypeId,
          "vehicle_brand_id": vehicleBrandId,
          "vehicle_model_id": vehicleModelId,
          "vehicle_color_id": vehicleColorId,
          "plate_number": plateNumber,
          "vehicle_license": vehicleLicense,
          "vehicle_license_expiry": vehicleLicensEexpiry,
        },
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Get Vehicle Category
  Future<Either<String, List<VehicleCategoryModel>>>
      getVehicleCategories() async {
    try {
      final Response response = await api.get(EndPoints.vehicleCategories);
      return Right(
        (response.data["data"] as List?)
                ?.map((e) => VehicleCategoryModel.fromJson(e))
                .toList() ??
            <VehicleCategoryModel>[],
      );
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Get Vehicle Types
  Future<Either<String, PaginationListModel>> getVehcileTypes({
    required int page,
    required int vehicleCategoryId,
  }) async {
    try {
      final Response response = await api.get(
        "${EndPoints.vehicleTypes}/$vehicleCategoryId",
        queryParameters: {"page": page},
      );
      return Right(
        PaginationListModel.fromJson(response.data["data"])
          ..data = (response.data["data"]["data"] as List?)
                  ?.map((e) => VehicleTypeModel.fromJson(e))
                  .toList() ??
              <VehicleTypeModel>[],
      );
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Get Vehicle Brands
  Future<Either<String, PaginationListModel>> getVehcileBrands({
    required int page,
    required int vehicleTypeId,
  }) async {
    try {
      final Response response = await api.get(
        "${EndPoints.vehicleBrands}/$vehicleTypeId",
        queryParameters: {"page": page},
      );
      return Right(
        PaginationListModel.fromJson(response.data["data"])
          ..data = (response.data["data"]["data"] as List?)
                  ?.map((e) => VehicleBrandModel.fromJson(e))
                  .toList() ??
              <VehicleBrandModel>[],
      );
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Get Vehicle Models
  Future<Either<String, PaginationListModel>> getVehcileModels({
    required int page,
    required int vehicleBrandId,
  }) async {
    try {
      final Response response = await api.get(
        "${EndPoints.vehicleModels}/$vehicleBrandId",
        queryParameters: {"page": page},
      );
      return Right(
        PaginationListModel.fromJson(response.data["data"])
          ..data = (response.data["data"]["data"] as List?)
                  ?.map((e) => VehicleModelModel.fromJson(e))
                  .toList() ??
              <VehicleModelModel>[],
      );
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Get Vehicle Colors
  Future<Either<String, PaginationListModel>> getVehcileColor({
    required int page,
  }) async {
    try {
      final Response response = await api.get(
        EndPoints.vehicleColors,
        queryParameters: {"page": page},
      );
      return Right(
        PaginationListModel.fromJson(response.data["data"])
          ..data = (response.data["data"]["data"] as List?)
                  ?.map((e) => VehicleColorModel.fromJson(e))
                  .toList() ??
              <VehicleColorModel>[],
      );
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Trip Vehicle Categories
  Future<Either<String, List<VehicleCategoryModel>>> tripVehicleCategories({
    required int tripId,
  }) async {
    try {
      final Response response = await api.get(
        "${EndPoints.tripVehicleCategories}/$tripId",
      );
      return Right(
        (response.data["data"] as List?)
                ?.map((e) => VehicleCategoryModel.fromJson(e))
                .toList() ??
            <VehicleCategoryModel>[],
      );
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Seats
  Future<Either<String, List<SeatModel>>> getSeats() async {
    try {
      final Response response = await api.get(EndPoints.seats);
      return Right(
        (response.data["data"] as List?)
                ?.map((e) => SeatModel.fromJson(e))
                .toList() ??
            <SeatModel>[],
      );
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }
}
