import 'dart:convert';

import 'package:intl_phone_field/countries.dart';

import '../../../../core/imports/imports.dart';
import '../../../otp/data/repo/otp_repo.dart';
import '../../data/repo/login_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  //! User Login
  Future<void> userLogin() async {
    emit(LoginLoadingState());
    final result = await sl<LoginRepo>().userLogin(
      countryCode: selectedCountry?.dialCode ?? "20",
      phone: phoneController.text,
      password: passwordController.text,
    );
    result.fold(
      (error) async {
        if (error is Map && error["status_code"] == 450) {
          await sl<OtpRepo>().resendOtp(
            countryCode: selectedCountry?.dialCode ?? "20",
            phone: phoneController.text,
          );
          emit(
            LoginErrorState(error: error["message"], isVerified: false),
          );
        } else {
          emit(LoginErrorState(error: error));
        }
      },
      (model) {
        if (model.user != null) {
          sl<Cache>().setData(AppConstants.token, model.user?.token);
          sl<Cache>()
              .setData(AppConstants.user, jsonEncode(model.user?.toJson()));
        }
        emit(LoginSuccessState(message: model.message));
      },
    );
  }

  //! Driver Login
  Future<void> driverLogin() async {
    emit(LoginLoadingState());
    final result = await sl<LoginRepo>().driverLogin(
      countryCode: selectedCountry?.dialCode ?? "20",
      phone: phoneController.text,
      password: passwordController.text,
    );
    result.fold(
      (error) async {
        if (error is Map && error["status_code"] == 450) {
          await sl<OtpRepo>().resendOtp(
            countryCode: selectedCountry?.dialCode ?? "20",
            phone: phoneController.text,
          );
          emit(
            LoginErrorState(error: error["message"], isVerified: false),
          );
        } else {
          emit(LoginErrorState(error: error));
        }
      },
      (model) {
        if (model.user != null) {
          sl<Cache>().setData(AppConstants.token, model.user?.token);
          sl<Cache>()
              .setData(AppConstants.user, jsonEncode(model.user?.toJson()));
        }
        emit(LoginSuccessState(message: model.message));
      },
    );
  }

  //! Form
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Country? selectedCountry;

  //! Password Obscur
  bool obscurePassword = true;

  obscurePasswordToggle() {
    obscurePassword = !obscurePassword;
    emit(LoginObscurePasswordToggleState());
  }
}
