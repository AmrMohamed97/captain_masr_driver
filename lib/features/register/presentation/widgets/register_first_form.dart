import 'dart:io';

import 'package:flutter_svg/svg.dart';

import '../../../../core/imports/imports.dart';
import '../cubit/register_cubit.dart';

class RegisterFirstForm extends StatelessWidget {
  const RegisterFirstForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();
        return SingleChildScrollView(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: cubit.firstFormKey,
            child: Column(
              children: [
                //! Profile Image
                if (context.read<GlobalCubit>().isDriver)
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.rH(context)),
                    child: GestureDetector(
                      onTap: () async {
                        cubit.profileImage =
                            await pickImageBottomSheet(context);
                        cubit.pickImage();
                      },
                      child: Center(
                        child: Container(
                          width: 105.rH(context),
                          height: 105.rH(context),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150),
                            border: Border.all(
                              color: AppColors.greyText,
                            ),
                          ),
                          child: cubit.profileImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(150),
                                  child: Image.file(
                                    File(cubit.profileImage!.path),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Center(
                                  child: SvgPicture.asset(
                                    Assets.imagesCamera,
                                    height: 38.rH(context),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                //! User Name
                AuthTextField(
                  controller: cubit.usernameController,
                  title: AppStrings.username.tr(context),
                  hintText: AppStrings.enterUsername.tr(context),
                  svgIcon: Assets.imagesPerson,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppStrings.enterUsername.tr(context);
                    }
                    return null;
                  },
                ),
                //! Email
                AuthTextField(
                  controller: cubit.emailController,
                  title: AppStrings.email.tr(context),
                  hintText: AppStrings.enterYourEmail.tr(context),
                  svgIcon: Assets.imagesEmail,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppStrings.enterYourEmail.tr(context);
                    }
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return AppStrings.invalidEmail.tr(context);
                    }
                    return null;
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
                //! Gender
                CustomDropDownButton(
                  value: cubit.gender,
                  items: [
                    AppStrings.male.tr(context),
                    AppStrings.female.tr(context),
                  ],
                  onChanged: (value) {
                    cubit.gender = value;
                    cubit.genderValue = value == AppStrings.male.tr(context)
                        ? "male"
                        : "female";
                  },
                  title: AppStrings.gender.tr(context),
                  hintText: AppStrings.selectYourGender.tr(context),
                  prefixIcon: SvgPicture.asset(
                    Assets.imagesGender,
                    height: 18.rH(context),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return AppStrings.selectYourGender.tr(context);
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.rH(context)),
                //! ID NUmber
                if (context.read<GlobalCubit>().isDriver)
                  AuthTextField(
                    controller: cubit.idNumberController,
                    title: AppStrings.idNumber.tr(context),
                    hintText: AppStrings.enterYourIdNumber.tr(context),
                    svgIcon: Assets.imagesNationalId,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppStrings.enterYourIdNumber.tr(context);
                      }
                      return null;
                    },
                  ),
                //! Mobile Number
                CustomIntlPhoneField(
                  controller: cubit.phoneController,
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
                  onCountryChanged: (country) {
                    cubit.selectedCountry = country;
                  },
                ),
                //! Confirm Button
                CustomButton(
                  onPressed: () {
                    cubit.validationToggle(true);
                    FocusScope.of(context).unfocus();
                    if (cubit.firstFormKey.currentState!.validate()) {
                      if (context.read<GlobalCubit>().isRider) {
                        cubit.userRegister();
                      } else {
                        cubit.validationToggle(false);
                        cubit.changePage(1);
                      }
                    }
                  },
                  title: context.read<GlobalCubit>().isRider
                      ? AppStrings.signUp.tr(context)
                      : AppStrings.cOntinue.tr(context),
                ),
                SizedBox(height: 16.rH(context)),
                //! Already Have Account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.alreadyHaveAnAccount.tr(context),
                      style: Styles.regular14(context).copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    SizedBox(width: 10.rW(context)),
                    GestureDetector(
                      onTap: () {
                        navigateReplacement(context, const LoginView());
                      },
                      child: Text(
                        AppStrings.login.tr(context),
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
