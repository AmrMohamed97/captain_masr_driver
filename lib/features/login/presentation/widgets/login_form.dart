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
          child: Form(
            key: cubit.formKey,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                //! Phone
                CustomIntlPhoneField(
                  controller: cubit.phoneController,
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
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.rH(context)),
                //! Login Button
                const LoginButton(),
                SizedBox(height: 18.rH(context)),
                //! Dont Have Account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.dontHaveAnAccount.tr(context),
                      style: Styles.regular14(context).copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    SizedBox(width: 10.rW(context)),
                    GestureDetector(
                      onTap: () {
                        navigateReplacement(context, const RegisterView());
                      },
                      child: Text(
                        AppStrings.signUp.tr(context),
                        style: Styles.regular14(context).copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
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
