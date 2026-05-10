import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../widgets/reset_password_body.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({
    super.key,
    required this.countryCode,
    required this.phone,
    required this.otp,
  });

  final String countryCode, phone, otp;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubit()
        ..countryCode = countryCode
        ..phone = phone
        ..otp = otp,
      child: Scaffold(
        body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccessState) {
              showToast(
                context,
                message: state.message,
                state: ToastStates.success,
              );
              Navigator.pop(context);
            }
            if (state is ResetPasswordErrorState) {
              showToast(
                context,
                message: state.error,
                state: ToastStates.error,
              );
            }
          },
          builder: (context, state) {
            return CustomModalProgressIndicator(
              inAsyncCall: state is ResetPasswordLoadingState,
              child: const ResetPasswordBody(),
            );
          },
        ),
      ),
    );
  }
}
