part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginObscurePasswordToggleState extends LoginState {}

final class LoginValidationToggleState extends LoginState {}

final class LoginLoadingState extends LoginState {}

final class LoginErrorState extends LoginState {
  final String error;
  final bool? isVerified;

  LoginErrorState({
    required this.error,
    this.isVerified,
  });
}

final class LoginSuccessState extends LoginState {
  final String? message;

  LoginSuccessState({required this.message});
}
