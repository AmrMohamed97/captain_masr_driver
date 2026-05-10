import '../../../base/data/models/pagination_model.dart';
import 'notification_model.dart';

class NotificationsResponseModel {
  final List<NotificationModel> notifications;
  final PaginationModel? pagination;

  NotificationsResponseModel({
    required this.notifications,
    required this.pagination,
  });

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationsResponseModel(
      notifications: (json["data"]["data"] as List?)
              ?.map((e) => NotificationModel.fromJson(e))
              .toList() ??
          <NotificationModel>[],
      pagination: json["data"]["meta"] != null
          ? PaginationModel.fromJson(json["data"]["meta"])
          : null,
    );
  }
}
