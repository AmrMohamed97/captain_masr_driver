import '../../../../core/imports/imports.dart';

class ResetPasswordForm extends StatelessWidget {
  const ResetPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
      builder: (context, state) {
        final cubit = context.read<ForgetPasswordCubit>();
        return Expanded(
          child: Form(
            key: cubit.resetPasswordFormKey,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                //! Password
                AuthTextField(
                  controller: cubit.passwordController,
                  title: AppStrings.password.tr(context),
                  hintText: AppStrings.enterYourPassword.tr(context),
                  svgIcon: Assets.imagesLock,
                  showPasswordSuffix: true,
                  obscure: cubit.obscurePassword,
                  passwordSufficOnTap: () {
                    cubit.obscurePasswordToggle();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppStrings.enterYourPassword.tr(context);
                    }
                    if (value.length < 8) {
                      return AppStrings.passwordLengthValidation.tr(context);
                    }
                    return null;
                  },
                ),
                //! Confirm Password
                AuthTextField(
                  controller: cubit.confirmPasswordController,
                  title: AppStrings.confirmPassword.tr(context),
                  hintText: AppStrings.confirmPassword.tr(context),
                  svgIcon: Assets.imagesLock,
                  showPasswordSuffix: true,
                  obscure: cubit.obscureConfirmPassword,
                  passwordSufficOnTap: () {
                    cubit.obscureConfirmPasswordToggle();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppStrings.confirmPassword.tr(context);
                    }
                    if (value.length < 8) {
                      return AppStrings.passwordLengthValidation.tr(context);
                    }
                    if (value != cubit.passwordController.text) {
                      return AppStrings.passwordNotMatch.tr(context);
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.rH(context)),

                //! Confirm Button
                CustomButton(
                  onPressed: () {
                    if (cubit.resetPasswordFormKey.currentState!.validate()) {
                      cubit.userResetPassword();
                    }
                  },
                  title: AppStrings.confirm.tr(context),
                ),

                SizedBox(height: 32.rH(context)),
              ],
            ),
          ),
        );
      },
    );
  }
}
