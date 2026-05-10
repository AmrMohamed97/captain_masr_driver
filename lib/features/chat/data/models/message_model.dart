class MessageModel {
  final int? id, receiverId, requestId, senderId;
  final String? message, createdAt, requestType;
  final bool? isSeen;

  MessageModel({
    required this.id,
    required this.receiverId,
    required this.requestId,
    required this.senderId,
    required this.message,
    required this.createdAt,
    required this.requestType,
    required this.isSeen,
  });

  factory MessageModel.fromJson(Map json) {
    return MessageModel(
      id: int.tryParse(json["mysql_id"]?.toString() ?? ""),
      receiverId: int.tryParse(json["receiver_id"]?.toString() ?? ""),
      requestId: int.tryParse(json["request_id"]?.toString() ?? ""),
      senderId: int.tryParse(json["sender_id"]?.toString() ?? ""),
      message: json["message"]?.toString(),
      createdAt: json["created_at"]?.toString(),
      requestType: json["request_type"]?.toString(),
      isSeen: json["is_seen"] == true || json["is_seen"] == 1,
    );
  }
}
