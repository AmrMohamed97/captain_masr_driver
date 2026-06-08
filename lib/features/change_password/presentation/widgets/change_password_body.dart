import '../../../../core/imports/imports.dart';
import 'change_password_button.dart';
import 'change_password_form.dart';

class ChangePasswordBody extends StatelessWidget {
  const ChangePasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        //! Header
        AuthHeaderRed(
          showBackButton: true,
        ),

        //! Form
        ChangePasswordForm(),
      ],
    );
  }
}
