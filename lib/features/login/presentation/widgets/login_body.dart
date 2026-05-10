import '../../../../core/imports/imports.dart';
import '../../../splash/presentation/views/choose_role_view.dart';
import 'login_form.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.rH(context)),
      child: Column(
        children: [
          //! Header
          AuthHeader(
            popOnTap: () {
              navigateAndRemoveUntil(context, const ChooseRoleView());
            },
            title: AppStrings.welcomeBack.tr(context),
            subtitle: context.read<GlobalCubit>().isRider
                ? AppStrings.letsGetYouMoving.tr(context)
                : AppStrings.letsHitTheRoad.tr(context),
          ),

          //! Form
          const LoginForm()
        ],
      ),
    );
  }
}
