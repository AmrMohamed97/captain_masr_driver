import 'notification_data_model.dart';

class NotificationDetailModel {
  final String? id, type, title, body, createdAt, updatedAt;
  final int? userId;
  final bool? isRead;
  final NotificationDataModel? data;
  final int unreadCount;

  NotificationDetailModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.isRead,
    required this.data,
    required this.unreadCount,
  });

  factory NotificationDetailModel.fromJson(Map<String, dynamic> json) {
    final notification =
        json["data"]["notification"] as Map<String, dynamic>? ?? {};
    return NotificationDetailModel(
      id: notification["id"],
      type: notification["type"],
      title: notification["title"],
      body: notification["body"],
      createdAt: notification["created_at"],
      updatedAt: notification["updated_at"],
      userId: notification["user_id"],
      isRead: notification["is_read"],
      data: notification["data"] != null
          ? NotificationDataModel.fromJson(notification["data"])
          : null,
      unreadCount: json["data"]["unread_count"] as int? ?? 0,
    );
  }
}
