import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../otp/presentation/views/otp_view.dart';
import '../cubit/register_cubit.dart';
import '../widgets/register_body.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            if (state.message != null) {
              showToast(
                context,
                message: state.message!,
                state: ToastStates.success,
              );
            }
            navigateReplacement(
              context,
              OtpView(
                phone: context.read<RegisterCubit>().phoneController.text,
                countryCode:
                    context.read<RegisterCubit>().selectedCountry?.dialCode ??
                        "20",
              ),
            );
          }
          if (state is RegisterErrorState) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: CustomModalProgressIndicator(
              inAsyncCall: state is RegisterLoadingState,
              child: const RegisterBody(),
            ),
          );
        },
      ),
    );
  }
}
