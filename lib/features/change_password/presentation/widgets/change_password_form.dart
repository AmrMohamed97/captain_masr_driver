import '../../../../core/imports/imports.dart';

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      builder: (context, state) {
        final cubit = context.read<ChangePasswordCubit>();
        return Expanded(
          child: Form(
            key: cubit.formKey,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                //! Current Password
                AuthTextField(
                  controller: cubit.currentPasswordController,
                  title: AppStrings.currentPassword.tr(context),
                  hintText: AppStrings.enterCurrentPassword.tr(context),
                  svgIcon: Assets.imagesLock,
                  showPasswordSuffix: true,
                  obscure: cubit.obscureCurrentPassword,
                  passwordSufficOnTap: () {
                    cubit.obscureCurrentPasswordToggle();
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
                //! New Password
                AuthTextField(
                  controller: cubit.newPasswordController,
                  title: AppStrings.newPassword.tr(context),
                  hintText: AppStrings.enterNewPassword.tr(context),
                  svgIcon: Assets.imagesLock,
                  showPasswordSuffix: true,
                  obscure: cubit.obscureNewPassword,
                  passwordSufficOnTap: () {
                    cubit.obscureNewPasswordToggle();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppStrings.enterYourPassword.tr(context);
                    }
                    if (value.length < 8) {
                      return AppStrings.passwordLengthValidation.tr(context);
                    }
                    if (value == cubit.currentPasswordController.text) {
                      return AppStrings.newPasswordCanNotBeAsOld.tr(context);
                    }
                    return null;
                  },
                ),
                //! Confirm Password
                AuthTextField(
                  controller: cubit.confirmPasswordController,
                  title: AppStrings.confirmNewPassword.tr(context),
                  hintText: AppStrings.confirmNewPassword.tr(context),
                  svgIcon: Assets.imagesLock,
                  showPasswordSuffix: true,
                  obscure: cubit.obscureConfirmNewPassword,
                  passwordSufficOnTap: () {
                    cubit.obscureConfirmNewPasswordToggle();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppStrings.confirmNewPassword.tr(context);
                    }
                    if (value.length < 8) {
                      return AppStrings.passwordLengthValidation.tr(context);
                    }
                    if (value != cubit.newPasswordController.text) {
                      return AppStrings.passwordNotMatch.tr(context);
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
