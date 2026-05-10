import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/imports/imports.dart';
import '../../../../core/notifications/notification_handler.dart';
import '../models/login_model.dart';
import '../models/user_model.dart';

class LoginRepo {
  final DioConsumer api;

  LoginRepo(this.api);

  //! User Login
  Future<Either<dynamic, LoginModel>> userLogin({
    required String countryCode,
    required String phone,
    required String password,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.userLogin,
        isFormData: true,
        data: {
          "country_code": countryCode,
          "phone": phone,
          "password": password,
          "fcm_token": NotificationHandler.fcmToken,
        },
      );
      if (response.statusCode == 450) {
        return Left(response.data["message"]);
      }
      return Right(LoginModel.fromJson(response.data));
    } on ServerException catch (e) {
      if (e.errorModel.statusCodel == 450) {
        return Left(
          {"message": e.errorModel.detail, "status_code": 450},
        );
      }
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  Future<Either<dynamic, LoginModel>> driverLogin({
    required String countryCode,
    required String phone,
    required String password,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.driverLogin,
        isFormData: true,
        data: {
          "country_code": countryCode,
          "phone": phone,
          "password": password,
          "fcm_token": NotificationHandler.fcmToken,
        },
      );
      if (response.statusCode == 450) {
        return Left(response.data["message"]);
      }
      return Right(LoginModel.fromJson(response.data));
    } on ServerException catch (e) {
      if (e.errorModel.statusCodel == 450) {
        return Left(
          {"message": e.errorModel.detail, "status_code": 450},
        );
      }
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! User Profile
  Future<Either<String, UserModel>> getUserProfile({
    required bool isRider,
  }) async {
    try {
      final Response response = isRider
          ? await api.get(
              EndPoints.userProfile,
            )
          : await api.get(
              EndPoints.driverProfile,
            );
      return Right(UserModel.fromJson(response.data["data"]));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }
}
