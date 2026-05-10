import 'user_model.dart';

class LoginModel {
  final String? message;
  final UserModel? user;

  LoginModel({
    required this.message,
    required this.user,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      message: json["msg"] ?? json["message"],
      user: json["data"] != null ? UserModel.fromJson(json["data"]) : null,
    );
  }
}
