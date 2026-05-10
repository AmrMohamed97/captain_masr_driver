import '../../../../core/imports/imports.dart';

class ForgetPasswordForm extends StatelessWidget {
  const ForgetPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
      builder: (context, state) {
        final cubit = context.read<ForgetPasswordCubit>();
        return Expanded(
          child: Form(
            key: cubit.formState,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                //! Email
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

                SizedBox(height: 16.rH(context)),

                //! Send Otp Button
                CustomButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (cubit.formState.currentState!.validate()) {
                      cubit.userForgetPassword();
                    }
                  },
                  title: AppStrings.sendOTP.tr(context),
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
