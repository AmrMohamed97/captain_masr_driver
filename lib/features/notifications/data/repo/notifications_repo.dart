import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_strings.dart';
import '../models/notification_detail_model.dart';
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

  //! Get Notification By Id (also marks it as read on the server)
  Future<Either<String, NotificationDetailModel>> getNotificationById(
      {required String id}) async {
    try {
      final Response response =
          await api.get(EndPoints.notificationById(id));
      return Right(NotificationDetailModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(AppStrings.anErrorOccured());
    }
  }
}

