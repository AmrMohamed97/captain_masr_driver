import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/imports/imports.dart';
import '../../../../core/notifications/notification_handler.dart';

class RegisterRepo {
  final DioConsumer api;

  RegisterRepo(this.api);

  //! User Register
  Future<Either<String, String>> userRegister({
    required String username,
    required String email,
    required String countryCode,
    required String country,
    required String phone,
    required String gender,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.userRegister,
        isFormData: true,
        data: {
          "username": username,
          "email": email,
          "country_code": countryCode,
          "country": country,
          "phone": phone,
          "gender": gender,
          "password": password,
          "password_confirmation": passwordConfirmation,
          "profile_picture": "",
          "fcm_token": NotificationHandler.fcmToken,
        },
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Driver Register
  Future<Either<String, String?>> driverRegister({
    required MultipartFile? profilePicture,
    required String username,
    required String email,
    required String password,
    required String gender,
    required String idNumber,
    required String countryCode,
    required String country,
    required String phone,
    required int vehicleCategoryId,
    required int vehicleTypeId,
    required int vehicleBrandId,
    required int vehicleModelId,
    required int vehicleColorId,
    required String plateNumber,
    required MultipartFile nationalId,
    required String nationalIdExpiry,
    required MultipartFile driverLicense,
    required String driverLicenseExpiry,
    required MultipartFile vehicleLicense,
    required String vehicleLicenseExpiry,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.driverRegister,
        isFormData: true,
        data: {
          "profile_picture": profilePicture,
          "username": username,
          "email": email,
          "password": password,
          "password_confirmation": password,
          "gender": gender,
          "ID_number": idNumber,
          "country_code": countryCode,
          "country": country,
          "phone": phone,
          "vehicle_category_id": vehicleCategoryId,
          "vehicle_type_id": vehicleTypeId,
          "vehicle_brand_id": vehicleBrandId,
          "vehicle_model_id": vehicleModelId,
          "vehicle_color_id": vehicleColorId,
          "plate_number": plateNumber,
          "national_id": nationalId,
          "national_id_expiry": nationalIdExpiry,
          "driver_license": driverLicense,
          "driver_license_expiry": driverLicenseExpiry,
          "vehicle_license": vehicleLicense,
          "vehicle_license_expiry": vehicleLicenseExpiry,
          "fcm_token": NotificationHandler.fcmToken,
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
