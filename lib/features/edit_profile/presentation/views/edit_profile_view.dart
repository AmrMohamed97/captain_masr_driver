import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../otp/presentation/views/otp_view.dart';
import '../../../splash/presentation/views/choose_role_view.dart';
import '../widgets/edit_profile_body.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (newContext) => EditProfileCubit(
        name: context.read<GlobalCubit>().userModel?.username ?? "",
        email: context.read<GlobalCubit>().userModel?.email ?? "",
        mobile: context.read<GlobalCubit>().userModel?.phone ?? "",
        gender: context.read<GlobalCubit>().userModel?.gender ?? "male",
        idNumber: context.read<GlobalCubit>().userModel?.idNumber ?? "",
      ),
      child: Scaffold(
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            //! Edit Profile
            if (state is EditProfileSuccessState) {
              showToast(
                context,
                message: state.message,
                state: ToastStates.success,
              );
              context.read<GlobalCubit>().updateUserData();
              Navigator.pop(context);
            }
            if (state is EditProfileErrorState) {
              showToast(
                context,
                message: state.error,
                state: ToastStates.error,
              );
            }
            //! Delete Account
            if (state is DeleteAccountSuccessState) {
              showToast(
                context,
                message: state.message,
                state: ToastStates.success,
              );
              context.read<GlobalCubit>().getUserData();
              context.read<GlobalCubit>().navBarController.index = 0;

              navigateAndRemoveUntil(
                context,
                const ChooseRoleView(),
              );
            }
            if (state is DeleteAccountErrorState) {
              showToast(
                context,
                message: state.error,
                state: ToastStates.error,
              );
            }
            //! Verify Email
            if (state is VerifyEmailSuccessState) {
              navigate(
                context,
                OtpView(
                  email: context.read<EditProfileCubit>().emailController.text,
                ),
              );
            }
          },
          builder: (context, state) {
            return CustomModalProgressIndicator(
              inAsyncCall: state is EditProfileLoadingState ||
                  state is DeleteAccountLoadingState,
              child: const EditProfileBody(),
            );
          },
        ),
      ),
    );
  }
}
