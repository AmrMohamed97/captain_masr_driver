import '../../../../core/imports/imports.dart';
import 'change_password_button.dart';
import 'change_password_form.dart';

class ChangePasswordBody extends StatelessWidget {
  const ChangePasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
      child: Column(
        children: [
          //! Header
          CustomAppBar(
            title: AppStrings.changePassword.tr(context),
          ),

          SizedBox(height: 26.rH(context)),

          const ChangePasswordForm(),

          SizedBox(height: 16.rH(context)),

          //! Save Changes Button
          const ChangePasswordButton(),

          SizedBox(height: 32.rH(context)),
        ],
      ),
    );
  }
}
