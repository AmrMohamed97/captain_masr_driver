import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../home/presentation/views/home_view.dart';
import '../../../otp/presentation/views/otp_view.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          if (state.message != null) {
            showToast(
              context,
              message: state.message!,
              state: ToastStates.success,
            );
            context.read<GlobalCubit>().updateUserData();
            navigateAndRemoveUntil(
              context,
              context.read<GlobalCubit>().isRider
                  ? const BaseView()
                  : const HomeView(),
            );
          }
        }
        if (state is LoginErrorState) {
          showToast(
            context,
            message: state.error,
            state: ToastStates.error,
          );
          if (state.isVerified == false) {
            navigateReplacement(
              context,
              OtpView(
                phone: context.read<LoginCubit>().phoneController.text,
                countryCode:
                    context.read<LoginCubit>().selectedCountry?.dialCode ??
                        "20",
              ),
            );
          }
        }
      },
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();
        return CustomButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            if (cubit.formKey.currentState!.validate()) {
              context.read<GlobalCubit>().isRider
                  ? cubit.userLogin()
                  : cubit.driverLogin();
            }
          },
          title: AppStrings.login.tr(context),
        );
      },
    );
  }
}
