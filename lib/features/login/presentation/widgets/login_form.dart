import 'package:flutter/gestures.dart';

import '../../../../core/imports/imports.dart';
import '../../../forget_password/presentation/views/forget_password_view.dart';
import '../../../register/presentation/views/register_view.dart';
import 'login_button.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();
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
                padding: EdgeInsets.symmetric(
                  horizontal: 24.rW(context),
                  vertical: 24.rH(context),
                ),
                children: [
                  // Title: تسجيل الدخول
                  Center(
                    child: Text(
                      AppStrings.login.tr(context),
                      style: Styles.bold20(
                        context,
                      ).copyWith(color: AppColors.primary, fontSize: 22),
                    ),
                  ),
                  SizedBox(height: 24.rH(context)),

                  //! Phone
                  CustomIntlPhoneField(
                    controller: cubit.phoneController,
                    title: context.read<GlobalCubit>().language == 'ar'
                        ? 'رقم التليفون'
                        : AppStrings.mobileNumber.tr(context),
                    borderRadius: 30,
                    fillColor: Colors.white,
                    borderSideColor: Colors.grey.shade300,
                    textDirection: TextDirection.rtl,
                    showDropdownIcon: true,
                    onCountryChanged: (country) {
                      cubit.selectedCountry = country;
                    },
                    validator: (value) {
                      if (value == null) {
                        return AppStrings.enteryYouMobileNumber.tr(context);
                      } else if ((cubit.selectedCountry?.maxLength ?? 10) !=
                          cubit.phoneController.text.length) {
                        return AppStrings.invalidPhoneNumber.tr(context);
                      } else {
                        return null;
                      }
                    },
                  ),

                  //! Password
                  AuthTextField(
                    controller: cubit.passwordController,
                    title: context.read<GlobalCubit>().language == 'ar'
                        ? 'كلمة المرور'
                        : AppStrings.password.tr(context),
                    hintText: context.read<GlobalCubit>().language == 'ar'
                        ? 'اكتب كلمة المرور'
                        : AppStrings.enterYourPassword.tr(context),
                    svgIcon: null,
                    borderRadius: 30,
                    fillColor: Colors.white,
                    borderSideColor: Colors.grey.shade300,
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

                  //! Forget Password ?
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: GestureDetector(
                      onTap: () {
                        navigate(context, const ForgetPasswordView());
                      },
                      child: Text(
                        AppStrings.forgetPassword.tr(context),
                        style: Styles.medium14(context).copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.rH(context)),

                  //! Login Button
                  const LoginButton(),
                  SizedBox(height: 18.rH(context)),

                  //! Dont Have Account
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: Styles.regular14(context).copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        children: [
                          TextSpan(
                            text: context.read<GlobalCubit>().language == 'ar'
                                ? "ليس لديك حساب ؟ "
                                : "${AppStrings.dontHaveAnAccount.tr(context)} ",
                          ),
                          TextSpan(
                            text: context.read<GlobalCubit>().language == 'ar'
                                ? "إنشاء حساب"
                                : AppStrings.signUp.tr(context),
                            style: Styles.bold14primary(context).copyWith(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                navigate(context, const RegisterView());
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
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
