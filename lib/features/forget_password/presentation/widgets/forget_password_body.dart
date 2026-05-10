import '../../../../core/imports/imports.dart';
import 'forget_password_form.dart';

class ForgetPasswordBody extends StatelessWidget {
  const ForgetPasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.rW(context)),
      child: Column(
        children: [
          //! Header
          AuthHeader(
            title: AppStrings.forgetPassword.tr(context),
            subtitle: AppStrings.dontWorryWeHaveGotYouCovered.tr(context),
          ),

          //! Form
          const ForgetPasswordForm(),
        ],
      ),
    );
  }
}
