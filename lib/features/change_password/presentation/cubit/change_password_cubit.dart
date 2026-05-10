import '../../../../core/imports/imports.dart';
import '../../../forget_password/data/password_repo.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());

  //! Change Password
  Future<void> changePassword() async {
    emit(ChangePasswordLoadingState());
    final result = await sl<PasswordRepo>().changePassword(
      currentPassword: currentPasswordController.text,
      newPassword: newPasswordController.text,
    );
    result.fold(
      (error) => emit(ChangePasswordErrorState(error: error)),
      (message) => emit(ChangePasswordSuccessState(message: message)),
    );
  }

  //*Form
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  //! Obscure Password
  bool obscureCurrentPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmNewPassword = true;

  obscureCurrentPasswordToggle() {
    obscureCurrentPassword = !obscureCurrentPassword;
    emit(ChangePasswordObscurePasswordToggleState());
  }

  obscureNewPasswordToggle() {
    obscureNewPassword = !obscureNewPassword;
    emit(ChangePasswordObscurePasswordToggleState());
  }

  obscureConfirmNewPasswordToggle() {
    obscureConfirmNewPassword = !obscureConfirmNewPassword;
    emit(ChangePasswordObscurePasswordToggleState());
  }
}
