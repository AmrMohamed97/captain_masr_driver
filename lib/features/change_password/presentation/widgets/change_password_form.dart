import '../../../../core/imports/imports.dart';

import 'change_password_button.dart';

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
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Form(
              key: cubit.formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.rW(context), vertical: 24.rH(context)),
                children: [
                  // Title: تغيير الرقم السري
                  Center(
                    child: Text(
                      context.read<GlobalCubit>().language == 'ar'
                          ? "تغيير الرقم السري"
                          : AppStrings.changePassword.tr(context),
                      style: Styles.bold20(context).copyWith(
                        color: AppColors.primary,
                        fontSize: 22 ,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.rH(context)),

                  //! Current Password
                  AuthTextField(
                    controller: cubit.currentPasswordController,
                    title: context.read<GlobalCubit>().language == 'ar'
                        ? 'كلمة المرور الحالية'
                        : AppStrings.currentPassword.tr(context),
                    hintText: context.read<GlobalCubit>().language == 'ar'
                        ? 'اكتب كلمة المرور الحالية'
                        : AppStrings.enterCurrentPassword.tr(context),
                    svgIcon: null,
                    borderRadius: 30,
                    fillColor: Colors.white,
                    borderSideColor: Colors.grey.shade300,
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
                    title: context.read<GlobalCubit>().language == 'ar'
                        ? 'كلمة المرور الجديدة'
                        : AppStrings.newPassword.tr(context),
                    hintText: context.read<GlobalCubit>().language == 'ar'
                        ? 'اكتب كلمة المرور الجديدة'
                        : AppStrings.enterNewPassword.tr(context),
                    svgIcon: null,
                    borderRadius: 30,
                    fillColor: Colors.white,
                    borderSideColor: Colors.grey.shade300,
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
                    title: context.read<GlobalCubit>().language == 'ar'
                        ? 'إعادة كتابة كلمة المرور'
                        : AppStrings.confirmNewPassword.tr(context),
                    hintText: context.read<GlobalCubit>().language == 'ar'
                        ? 'إعادة كتابة كلمة المرور'
                        : AppStrings.confirmNewPassword.tr(context),
                    svgIcon: null,
                    borderRadius: 30,
                    fillColor: Colors.white,
                    borderSideColor: Colors.grey.shade300,
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

                  SizedBox(height: 24.rH(context)),

                  //! Save Changes Button
                  const ChangePasswordButton(),

                  SizedBox(height: 32.rH(context)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
