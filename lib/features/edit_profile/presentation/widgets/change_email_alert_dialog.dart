import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../otp/presentation/views/otp_view.dart';

class ChangeEmailAlertDialog extends StatelessWidget {
  const ChangeEmailAlertDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileCubit(),
      child: BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state is UpdateEmailSuccessState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.success,
            );
            navigateReplacement(
              context,
              OtpView(
                email: context.read<EditProfileCubit>().emailController.text,
              ),
            );
          }
          if (state is UpdateEmailErrorState) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<EditProfileCubit>();
          return CustomModalProgressIndicator(
            inAsyncCall: state is UpdateEmailLoadingState,
            child: AlertDialog(
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: 343.rW(context),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.rW(context),
                  vertical: 24.rH(context),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //! Close Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Icon(
                            Icons.close,
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                      SizedBox(height: 8.rH(context)),

                      //! Title
                      Text(
                        AppStrings.changeEmail.tr(context),
                        style: Styles.semibold21Primary(context),
                      ),

                      SizedBox(height: 10.rH(context)),

                      //! Text Field
                      AuthTextField(
                        controller: cubit.emailController,
                        title: AppStrings.email.tr(context),
                        hintText: AppStrings.enterNewEmail.tr(context),
                        svgIcon: Assets.imagesEmail,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppStrings.enterNewEmail.tr(context);
                          }
                          final emailRegex =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return AppStrings.invalidEmail.tr(context);
                          }
                          if (value ==
                              context.read<GlobalCubit>().userModel?.email) {
                            return AppStrings.enterDifferentEmail.tr(context);
                          }
                          return null;
                        },
                      ),

                      //! Change Button
                      CustomButton(
                        onPressed: () {
                          if (cubit.formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            cubit.updateEmail();
                          }
                        },
                        title: AppStrings.saveChanges.tr(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
