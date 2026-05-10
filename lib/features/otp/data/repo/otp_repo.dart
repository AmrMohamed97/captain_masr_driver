import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../login/data/models/login_model.dart';

class OtpRepo {
  final DioConsumer api;

  OtpRepo(this.api);

  //! User Verify Otp
  Future<Either<String, LoginModel>> userVerifyOtp({
    required String countryCode,
    required String phone,
    required String otp,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.userVerifyOtp,
        isFormData: true,
        data: {
          "country_code": countryCode,
          "phone": phone,
          "otp": otp,
        },
      );
      return Right(LoginModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Check Otp
  Future<Either<String, String>> checkOtp({
    required String countryCode,
    required String phone,
    required String otp,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.checkOtp,
        isFormData: true,
        data: {
          "country_code": countryCode,
          "phone": phone,
          "otp": otp,
        },
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Resend Otp
  Future<Either<String, String>> resendOtp({
    required String countryCode,
    required String phone,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.resendOtp,
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

  //! Verify Email
  Future<Either<String, String>> verifyEmail({
    required String otp,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.verifyEmail,
        isFormData: true,
        data: {"otp": otp},
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Email Resend Otp
  Future<Either<String, String>> emailResendOtp(
      {required String email, required bool isRider}) async {
    try {
      final Response response = await api.post(
        isRider ? EndPoints.userEmailResendOtp : EndPoints.driverEmailResendOtp,
        isFormData: true,
        data: {"email": email},
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Verify Change Phone
  Future<Either<String, String>> verifyChangePhone({
    required String otp,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.verifyChangePhone,
        isFormData: true,
        data: {"otp": otp},
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }
}
