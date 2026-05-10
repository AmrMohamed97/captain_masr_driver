import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_strings.dart';

class ProfileRepo {
  final DioConsumer api;

  ProfileRepo(this.api);

  //! Edit Profile
  Future<Either<String, String>> userEditProfile({
    required String username,
    required MultipartFile? profilePicture,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.userUpdateProfile,
        isFormData: true,
        data: {
          "username": username,
          "profile_picture": profilePicture,
        },
      );
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }

  //! Update Phone
  Future<Either<String, String>> updatePhone({
    required String countryCode,
    required String country,
    required String phone,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.updatePhone,
        isFormData: true,
        data: {
          "country_code": countryCode,
          "country_change": country,
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

  //! Update Email
  Future<Either<String, String>> updateEmail({
    required String email,
  }) async {
    try {
      final Response response = await api.post(
        EndPoints.updateEmail,
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

  //! Delete Account
  Future<Either<String, String>> deleteAccount() async {
    try {
      final Response response = await api.post(EndPoints.deleteAccount);
      return Right(response.data["message"]);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }
}
