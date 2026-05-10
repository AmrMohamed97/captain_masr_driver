part of 'forget_password_cubit.dart';

@immutable
sealed class ForgetPasswordState {}

final class ForgetPasswordInitial extends ForgetPasswordState {}

final class ResetPasswordObscurePasswordToggleState
    extends ForgetPasswordState {}

final class ForgetPasswordLoadingState extends ForgetPasswordState {}

final class ForgetPasswordErrorState extends ForgetPasswordState {
  final String error;

  ForgetPasswordErrorState({required this.error});
}

final class ForgetPasswordSuccessState extends ForgetPasswordState {
  final String message;

  ForgetPasswordSuccessState({required this.message});
}

final class ResetPasswordLoadingState extends ForgetPasswordState {}

final class ResetPasswordErrorState extends ForgetPasswordState {
  final String error;

  ResetPasswordErrorState({required this.error});
}

final class ResetPasswordSuccessState extends ForgetPasswordState {
  final String message;

  ResetPasswordSuccessState({required this.message});
}
