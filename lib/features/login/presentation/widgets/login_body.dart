import '../../../../core/imports/imports.dart';
// import '../../../splash/presentation/views/choose_role_view.dart';
import 'login_form.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        //! Header
        AuthHeaderRed(
          showBackButton: false,
        ),

        //! Form
        LoginForm()
      ],
    );
  }
}
