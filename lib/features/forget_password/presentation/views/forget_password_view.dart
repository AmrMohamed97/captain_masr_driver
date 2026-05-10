import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../otp/presentation/views/otp_view.dart';
import '../widgets/forget_password_body.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(),
      child: Scaffold(
        body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
          listener: (context, state) {
            if (state is ForgetPasswordSuccessState) {
              showToast(
                context,
                message: state.message,
                state: ToastStates.success,
              );
              navigateReplacement(
                context,
                OtpView(
                  isForgetPassword: true,
                  phone:
                      context.read<ForgetPasswordCubit>().phoneController.text,
                  countryCode: context
                          .read<ForgetPasswordCubit>()
                          .selectedCountry
                          ?.dialCode ??
                      "20",
                ),
              );
            }
            if (state is ForgetPasswordErrorState) {
              showToast(
                context,
                message: state.error,
                state: ToastStates.error,
              );
            }
          },
          builder: (context, state) {
            return CustomModalProgressIndicator(
              inAsyncCall: state is ForgetPasswordLoadingState,
              child: const ForgetPasswordBody(),
            );
          },
        ),
      ),
    );
  }
}
