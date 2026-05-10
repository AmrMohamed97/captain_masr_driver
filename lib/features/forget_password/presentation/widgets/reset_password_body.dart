import '../../../../core/imports/imports.dart';
import 'reset_password_form.dart';

class ResetPasswordBody extends StatelessWidget {
  const ResetPasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.rW(context)),
      child: Column(
        children: [
          //! Header
          AuthHeader(
            title: AppStrings.resetPassword.tr(context),
            subtitle: AppStrings.setNewPasswordToSecureYourAccount.tr(context),
          ),

          //! Form
          const ResetPasswordForm(),
        ],
      ),
    );
  }
}
