import 'dart:async';
import 'dart:convert';

import '../../../../core/imports/imports.dart';
import '../../data/repo/otp_repo.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());

  bool isActive = true;
  bool isChangePhone = false;
  String? phone, countryCode, email;

  //! Verify Otp
  Future<void> userVerifyOtp() async {
    emit(VerifyOtpLoadingState());
    final result = await sl<OtpRepo>().userVerifyOtp(
      countryCode: countryCode!,
      phone: phone!,
      otp: otp!,
    );
    result.fold(
      (error) => emit(VerifyOtpErrorState(error: error)),
      (model) {
        if (model.user != null) {
          sl<Cache>().setData(AppConstants.token, model.user?.token);
          sl<Cache>()
              .setData(AppConstants.user, jsonEncode(model.user?.toJson()));
        }
        emit(VerifyOtpSuccessState(message: model.message ?? ""));
      },
    );
  }

  //! Check Otp
  Future<void> userCheckOtp() async {
    emit(VerifyOtpLoadingState());
    final result = await sl<OtpRepo>().checkOtp(
      countryCode: countryCode!,
      phone: phone!,
      otp: otp!,
    );
    result.fold(
      (error) => emit(VerifyOtpErrorState(error: error)),
      (message) => emit(VerifyOtpSuccessState(message: message)),
    );
  }

  //! Resend Otp
  Future<void> resendOtp({required bool isRider}) async {
    emit(ResendOtpLoadingState());
    final result = email != null
        ? await sl<OtpRepo>().emailResendOtp(
            email: email!,
            isRider: isRider,
          )
        : await sl<OtpRepo>().resendOtp(
            countryCode: countryCode!,
            phone: phone!,
          );
    result.fold(
      (error) => emit(ResendOtpErrorState(error: error)),
      (message) {
        emit(ResendOtpSuccessState(message: message));
        startTimer();
      },
    );
  }

  //! Verify Change Email
  Future<void> verifyChangeEmail() async {
    emit(VerifyOtpLoadingState());
    final result = await sl<OtpRepo>().verifyEmail(otp: otp!);
    result.fold(
      (error) => emit(VerifyOtpErrorState(error: error)),
      (message) => emit(UpdateVerifyOtpSuccessState(message: message)),
    );
  }

  //! Verify Change Phone
  Future<void> verifyChangePhone() async {
    emit(VerifyOtpLoadingState());
    final result = await sl<OtpRepo>().verifyChangePhone(otp: otp!);
    result.fold(
      (error) => emit(VerifyOtpErrorState(error: error)),
      (message) => emit(UpdateVerifyOtpSuccessState(message: message)),
    );
  }

  //! Form
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? otp;
  bool isForgetPassword = false;

  //! OTP Timer
  late Timer otpTimer;
  int remainingSeconds = 90;
  bool requestSent = false;

  void startTimer() {
    remainingSeconds = 90;
    otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isActive) return;
      if (remainingSeconds > 0) {
        remainingSeconds--;
        emit(OTPTimerState());
      } else {
        timer.cancel();
        emit(OTPTimerState());
      }
    });
  }

  @override
  Future<void> close() {
    isActive = false;
    return super.close();
  }
}
