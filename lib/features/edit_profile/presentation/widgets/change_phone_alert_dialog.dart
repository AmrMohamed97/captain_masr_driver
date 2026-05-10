import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../otp/presentation/views/otp_view.dart';

class ChangePhoneAlertDialog extends StatelessWidget {
  const ChangePhoneAlertDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileCubit(),
      child: BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state is UpdatePhoneSuccessState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.success,
            );
            navigateReplacement(
              context,
              OtpView(
                isChangePhone: true,
                countryCode: context
                        .read<EditProfileCubit>()
                        .selectedCountry
                        ?.dialCode ??
                    "20",
                phone: context.read<EditProfileCubit>().mobileController.text,
              ),
            );
          }
          if (state is UpdatePhoneErrorState) {
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
            inAsyncCall: state is UpdatePhoneLoadingState,
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
                        AppStrings.changeMobileNumber.tr(context),
                        style: Styles.semibold21Primary(context),
                      ),

                      SizedBox(height: 10.rH(context)),

                      //! Text Field
                      CustomIntlPhoneField(
                        controller: cubit.mobileController,
                        validator: (value) {
                          if (value == null) {
                            return AppStrings.enteryYouMobileNumber.tr(context);
                          } else if ((cubit.selectedCountry?.maxLength ?? 10) !=
                              cubit.mobileController.text.length) {
                            return AppStrings.invalidPhoneNumber.tr(context);
                          } else if (value.number ==
                              context.read<GlobalCubit>().userModel?.phone) {
                            return AppStrings.enterDifferentMobileNumber
                                .tr(context);
                          } else {
                            return null;
                          }
                        },
                        onCountryChanged: (country) {
                          cubit.selectedCountry = country;
                        },
                      ),

                      //! Change Button
                      CustomButton(
                        onPressed: () {
                          if (cubit.formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            cubit.updatePhone();
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
