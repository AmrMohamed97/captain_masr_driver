import '../../../base/data/models/pagination_model.dart';
import 'notification_model.dart';

class NotificationsResponseModel {
  final List<NotificationModel> notifications;
  final PaginationModel? pagination;
  final int unreadCount;

  NotificationsResponseModel({
    required this.notifications,
    required this.pagination,
    required this.unreadCount,
  });

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    final notificationsWrapper = json["data"]["notifications"] as Map<String, dynamic>?;
    return NotificationsResponseModel(
      notifications: (notificationsWrapper?["data"] as List?)
              ?.map((e) => NotificationModel.fromJson(e))
              .toList() ??
          <NotificationModel>[],
      pagination: notificationsWrapper?["meta"] != null
          ? PaginationModel.fromJson(notificationsWrapper!["meta"])
          : null,
      unreadCount: json["data"]["unread_count"] as int? ?? 0,
    );
  }
}
