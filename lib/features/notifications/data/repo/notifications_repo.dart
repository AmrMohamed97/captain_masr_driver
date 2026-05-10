import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_strings.dart';
import '../models/notifications_response_model.dart';

class NotificationsRepo {
  final DioConsumer api;
  NotificationsRepo(this.api);

  //! Get Notifications
  Future<Either<String, NotificationsResponseModel>> getNotifications(
      {required int page}) async {
    try {
      final Response response = await api.get(
        EndPoints.notifications,
        queryParameters: {"page": page},
      );
      return Right(NotificationsResponseModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }
}
