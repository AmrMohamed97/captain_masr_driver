import 'notification_data_model.dart';

class NotificationModel {
  final String? id, type, title, body, createdAt, image;
  final bool? isRead;
  final NotificationDataModel? data;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.image,
    required this.isRead,
    required this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["id"],
      type: json["type"],
      title: json["title"],
      body: json["body"],
      createdAt: json["created_at"],
      image: json["image"],
      isRead: json["is_read"],
      data: json["data"] != null
          ? NotificationDataModel.fromJson(json["data"])
          : null,
    );
  }
}
