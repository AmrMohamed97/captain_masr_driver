import 'package:intl_phone_field/countries.dart';

import '../../../../core/imports/imports.dart';
import '../../data/password_repo.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  //! Reset Password
  String? countryCode, phone, otp;
  Future<void> userResetPassword() async {
    emit(ResetPasswordLoadingState());
    final result = await sl<PasswordRepo>().userResetPassword(
      countryCode: countryCode!,
      phone: phone!,
      otp: otp!,
      password: passwordController.text,
    );
    result.fold(
      (error) => emit(ResetPasswordErrorState(error: error)),
      (message) => emit(ResetPasswordSuccessState(message: message)),
    );
  }

  //! Forget Password
  Future<void> userForgetPassword() async {
    emit(ForgetPasswordLoadingState());
    final result = await sl<PasswordRepo>().userForgetPassword(
      countryCode: selectedCountry?.dialCode ?? "20",
      phone: phoneController.text,
    );
    result.fold(
      (error) => emit(ForgetPasswordErrorState(error: error)),
      (message) => emit(ForgetPasswordSuccessState(message: message)),
    );
  }

  //! Forget Password Form
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  Country? selectedCountry;

  //! Reset Password Form
  GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  //! Obscure Password
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  obscurePasswordToggle() {
    obscurePassword = !obscurePassword;
    emit(ResetPasswordObscurePasswordToggleState());
  }

  obscureConfirmPasswordToggle() {
    obscureConfirmPassword = !obscureConfirmPassword;
    emit(ResetPasswordObscurePasswordToggleState());
  }
}
