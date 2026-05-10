part of 'change_password_cubit.dart';

@immutable
sealed class ChangePasswordState {}

final class ChangePasswordInitial extends ChangePasswordState {}

final class ChangePasswordObscurePasswordToggleState
    extends ChangePasswordState {}

final class ChangePasswordLoadingState extends ChangePasswordState {}

final class ChangePasswordErrorState extends ChangePasswordState {
  final String error;

  ChangePasswordErrorState({required this.error});
}

final class ChangePasswordSuccessState extends ChangePasswordState {
  final String message;

  ChangePasswordSuccessState({required this.message});
}
