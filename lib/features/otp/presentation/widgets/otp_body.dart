
import '../../../../core/imports/imports.dart';
import 'otp_pinput.dart';

class OtpBody extends StatelessWidget {
  const OtpBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtpCubit, OtpState>(
      builder: (context, state) {
        final cubit = context.read<OtpCubit>();
        
        // Helper to mask phone numbers like: 012*****30
        String maskPhone(String phone) {
          if (phone.length < 7) return phone;
          return "${phone.substring(0, 3)}*****${phone.substring(phone.length - 2)}";
        }

        String subtitleText = context.read<GlobalCubit>().language == 'ar'
            ? (cubit.email != null
                ? "برجاء ادخال الرمز الذى تم ارساله عن طريق البريد الإلكتروني"
                : "برجاء ادخال الرمز الذى تم ارساله عن طريق الهاتف ${cubit.phone != null ? maskPhone(cubit.phone!) : ''}")
            : (cubit.email != null
                ? "${AppStrings.enterYheVerificationCodeWeJustSentToYourEmailAddress.tr(context)}: ${cubit.email}"
                : "${AppStrings.enterYheVerificationCodeWeJustSentToYourMobile.tr(context)}: ${cubit.phone}");

        return Column(
          children: [
            //! Header
            AuthHeaderRed(
              showBackButton: true,
              onBackTap: () {
                Navigator.pop(context);
              },
            ),

            //! White Card Form
            Expanded(
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
                      //! Timer in red
                      if (cubit.remainingSeconds != 0)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 24.rH(context)),
                            child: Text(
                              "${(cubit.remainingSeconds ~/ 60).toString().padLeft(2, "0")}:${(cubit.remainingSeconds % 60).toString().padLeft(2, "0")}",
                              style: Styles.bold20(context).copyWith(
                                color: AppColors.primary,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),

                      //! Title: ادخال الكود
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          context.read<GlobalCubit>().language == 'ar'
                              ? "ادخال الكود"
                              : AppStrings.oTPVerification.tr(context),
                          style: Styles.bold20(context).copyWith(
                            color: AppColors.textColor,
                            fontSize: 22 ,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.rH(context)),

                      //! Subtitle
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          subtitleText,
                          style: Styles.regular14(context).copyWith(
                            color: AppColors.greyText,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(height: 32.rH(context)),

                      //! Otp Field
                      const OtpPinput(),

                      SizedBox(height: 24.rH(context)),

                      //! Resend Otp
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            if (cubit.remainingSeconds == 0) {
                              cubit.resendOtp(
                                isRider: context.read<GlobalCubit>().isRider,
                              );
                            }
                          },
                          child: Text(
                            context.read<GlobalCubit>().language == 'ar'
                                ? "ارسال الكود مرة أخرى"
                                : "Resend Code",
                            style: Styles.bold14primary(context).copyWith(
                              color: cubit.remainingSeconds == 0
                                  ? AppColors.primary
                                  : AppColors.greyText,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 32.rH(context)),

                      //! Verify Button (تأكيد)
                      CustomButton(
                        onPressed: () {
                          if (cubit.otp?.length == 4) {
                            if (cubit.isForgetPassword) {
                              cubit.userCheckOtp();
                            } else if (cubit.email != null) {
                              cubit.verifyChangeEmail();
                            } else if (cubit.isChangePhone) {
                              cubit.verifyChangePhone();
                            } else {
                              cubit.userVerifyOtp();
                            }
                          }
                        },
                        title: AppStrings.confirm.tr(context),
                        borderRadius: BorderRadius.circular(30),
                        height: 52.rH(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
