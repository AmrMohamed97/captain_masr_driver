import '../../../../core/imports/imports.dart';
import '../widgets/login_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xff800005),
        body: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return CustomModalProgressIndicator(
              inAsyncCall: state is LoginLoadingState,
              child: const LoginBody(),
            );
          },
        ),
      ),
    );
  }
}
