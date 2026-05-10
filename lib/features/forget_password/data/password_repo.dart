import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/databases/api/dio_consumer.dart';
import '../../../core/databases/api/end_points.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/app_strings.dart';

class PasswordRepo {
  final DioConsumer api;

  PasswordRepo(this.api);

  //! User Forget Password
  Future<Either<String, String>> userForgetPassword({
    required String countryCode,
    required String phone,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.userForgetPassword,
        isFormData: true,
        data: {
          "country_code": countryCode,
          "phone": phone,
        },
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Reset Password
  Future<Either<String, String>> userResetPassword({
    required String countryCode,
    required String phone,
    required String otp,
    required String password,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.userResetPassword,
        isFormData: true,
        data: {
          "country_code": countryCode,
          "phone": phone,
          "otp": otp,
          "password": password,
          "password_confirmation": password,
        },
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Change Password
  Future<Either<String, String>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.changePassword,
        isFormData: true,
        data: {
          "current_password": currentPassword,
          "new_password": newPassword,
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
