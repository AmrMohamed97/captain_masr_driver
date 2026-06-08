import '../../../../core/imports/imports.dart';
import 'forget_password_form.dart';

class ForgetPasswordBody extends StatelessWidget {
  const ForgetPasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        //! Header
        AuthHeaderRed(
          showBackButton: true,
        ),

        //! Form
        ForgetPasswordForm(),
      ],
    );
  }
}
