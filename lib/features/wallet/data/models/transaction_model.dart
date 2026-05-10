import '../../../login/data/models/user_model.dart';

class TransactionModel {
  final int? id, rideId;
  final String? action, amount, time;
  final UserModel? user;

  TransactionModel({
    required this.id,
    required this.rideId,
    required this.action,
    required this.amount,
    required this.time,
    required this.user,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json["id"],
      rideId: json["ride_id"],
      action: json["action"],
      amount: json["amount"],
      time: json["time"],
      user: json["user"] != null
          ? UserModel.fromJson(json["user"])
          : json["driver"] != null
              ? UserModel.fromJson(json["driver"])
              : null,
    );
  }
}
