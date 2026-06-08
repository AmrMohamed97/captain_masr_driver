import '../../../../core/imports/imports.dart';

class ForgetPasswordForm extends StatelessWidget {
  const ForgetPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
      builder: (context, state) {
        final cubit = context.read<ForgetPasswordCubit>();
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
              key: cubit.formState,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.rW(context), vertical: 24.rH(context)),
                children: [
                  // Title: نسيت كلمة المرور؟
                  Center(
                    child: Text(
                      AppStrings.forgetPassword.tr(context),
                      style: Styles.bold20(context).copyWith(
                        color: AppColors.primary,
                        fontSize: 22 ,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.rH(context)),

                  // Subtitle: يرجى ادخال رقم الهاتف لارسال رمز التحقق
                  Center(
                    child: Text(
                      context.read<GlobalCubit>().language == 'ar'
                          ? "يرجى ادخال رقم الهاتف لارسال رمز التحقق"
                          : AppStrings.dontWorryWeHaveGotYouCovered.tr(context),
                      style: Styles.regular14(context).copyWith(
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 32.rH(context)),

                  //! Phone field
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

                  SizedBox(height: 24.rH(context)),

                  //! Send Otp Button (تأكيد)
                  CustomButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (cubit.formState.currentState!.validate()) {
                        cubit.userForgetPassword();
                      }
                    },
                    title: AppStrings.confirm.tr(context),
                    borderRadius: BorderRadius.circular(30),
                    height: 52.rH(context),
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
