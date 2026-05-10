import 'package:flutter/gestures.dart';

import '../../../../core/imports/imports.dart';
import 'otp_pinput.dart';

class OtpBody extends StatelessWidget {
  const OtpBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtpCubit, OtpState>(
      builder: (context, state) {
        final cubit = context.read<OtpCubit>();
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.rW(context)),
          child: Form(
            key: cubit.formKey,
            child: Column(
              children: [
                //! Header
                AuthHeader(
                  title: AppStrings.oTPVerification.tr(context),
                  subtitle: cubit.email != null
                      ? AppStrings
                          .enterYheVerificationCodeWeJustSentToYourEmailAddress
                          .tr(context)
                      : AppStrings
                          .enterYheVerificationCodeWeJustSentToYourMobile
                          .tr(context),
                ),

                //! Otp Field
                const OtpPinput(),

                SizedBox(height: 32.rH(context)),

                //! Verify Button
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
                  title: AppStrings.verify,
                ),

                SizedBox(height: 16.rH(context)),

                //! Timer
                if (cubit.remainingSeconds != 0)
                  Text(
                    "${(cubit.remainingSeconds ~/ 60)}:${(cubit.remainingSeconds % 60).toString().padLeft(2, "0")}",
                    style: Styles.semibold16Primary(context),
                  ),

                //! Resend Otp
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: AppStrings.didntReceiveCode.tr(context),
                        style: Styles.semibold11(context).copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      const TextSpan(text: " "),
                      TextSpan(
                        text: AppStrings.resend.tr(context),
                        style: Styles.bold14primary(context).copyWith(
                          color: cubit.remainingSeconds == 0
                              ? AppColors.primary
                              : AppColors.greyText,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            if (cubit.remainingSeconds == 0) {
                              cubit.resendOtp(
                                isRider: context.read<GlobalCubit>().isRider,
                              );
                            }
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
