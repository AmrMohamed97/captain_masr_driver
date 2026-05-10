import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../forget_password/presentation/views/reset_password_view.dart';
import '../../../preferences/presentation/views/preferences_view.dart';
import '../widgets/otp_body.dart';
import 'driver_verify_account_view.dart';

class OtpView extends StatelessWidget {
  const OtpView({
    super.key,
    this.isForgetPassword = false,
    this.phone,
    this.countryCode,
    this.email,
    this.isChangePhone = false,
  });

  final String? phone, countryCode, email;
  final bool isForgetPassword, isChangePhone;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpCubit()
        ..startTimer()
        ..phone = phone
        ..countryCode = countryCode
        ..isForgetPassword = isForgetPassword
        ..email = email
        ..isChangePhone = isChangePhone,
      child: Scaffold(
        body: BlocConsumer<OtpCubit, OtpState>(
          listener: (context, state) {
            if (state is VerifyOtpSuccessState) {
              showToast(
                context,
                message: state.message,
                state: ToastStates.success,
              );
              if (isForgetPassword) {
                final cubit = context.read<OtpCubit>();
                navigateReplacement(
                  context,
                  ResetPasswordView(
                    countryCode: cubit.countryCode!,
                    phone: cubit.phone!,
                    otp: cubit.otp!,
                  ),
                );
              } else {
                context.read<GlobalCubit>().getUserData();
                navigateReplacement(
                  context,
                  context.read<GlobalCubit>().isRider
                      ? const PreferencesView()
                      : const DriverVerifyAccountView(),
                );
              }
            }
            if (state is VerifyOtpErrorState) {
              showToast(
                context,
                message: state.error,
                state: ToastStates.error,
              );
            }
            if (state is ResendOtpSuccessState) {
              showToast(
                context,
                message: state.message,
                state: ToastStates.success,
              );
            }
            if (state is ResendOtpErrorState) {
              showToast(
                context,
                message: state.error,
                state: ToastStates.error,
              );
            }
            if (state is UpdateVerifyOtpSuccessState) {
              showToast(
                context,
                message: state.message,
                state: ToastStates.success,
              );
              context.read<GlobalCubit>().updateUserData();
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return CustomModalProgressIndicator(
              inAsyncCall: state is VerifyOtpLoadingState ||
                  state is ResendOtpLoadingState,
              child: const OtpBody(),
            );
          },
        ),
      ),
    );
  }
}
