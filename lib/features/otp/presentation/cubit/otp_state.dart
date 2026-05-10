part of 'otp_cubit.dart';

@immutable
sealed class OtpState {}

final class OtpInitial extends OtpState {}

final class OTPTimerState extends OtpState {}

final class VerifyOtpLoadingState extends OtpState {}

final class VerifyOtpErrorState extends OtpState {
  final String error;

  VerifyOtpErrorState({required this.error});
}

final class VerifyOtpSuccessState extends OtpState {
  final String message;

  VerifyOtpSuccessState({required this.message});
}

final class UpdateVerifyOtpSuccessState extends OtpState {
  final String message;

  UpdateVerifyOtpSuccessState({required this.message});
}

final class ResendOtpLoadingState extends OtpState {}

final class ResendOtpErrorState extends OtpState {
  final String error;

  ResendOtpErrorState({required this.error});
}

final class ResendOtpSuccessState extends OtpState {
  final String message;

  ResendOtpSuccessState({required this.message});
}
