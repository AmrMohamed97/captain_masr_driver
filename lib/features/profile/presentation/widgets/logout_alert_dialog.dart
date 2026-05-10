import '../../../../core/imports/imports.dart';
import '../../../splash/presentation/views/choose_role_view.dart';

class LogoutAlertDialog extends StatelessWidget {
  const LogoutAlertDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      elevation: 0,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //! Upper Section
          Container(
            width: 343.rW(context),
            padding: EdgeInsets.symmetric(
              vertical: 16.rH(context),
            ),
            decoration: const BoxDecoration(
              color: Color(0xffC64949),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //! Title
                Text(
                  AppStrings.logout.tr(context),
                  style: Styles.medium20white(context),
                ),

                SizedBox(height: 16.rH(context)),

                //! Icon
                Container(
                  width: 83.rH(context),
                  height: 83.rH(context),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: AppColors.white,
                    ),
                  ),
                  child: Center(
                    child: Transform.flip(
                      flipX: context.read<GlobalCubit>().language == "en"
                          ? true
                          : false,
                      child: CustomSvgPicture(
                        svg: Assets.imagesLogout,
                        color: AppColors.white,
                        height: 35.rH(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //! Lower Section
          Container(
            width: 343.rW(context),
            padding: EdgeInsets.symmetric(
              vertical: 24.rH(context),
              horizontal: 26.rW(context),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //! Title
                Text(
                  AppStrings.areYouSureYouWantToLogout.tr(context),
                  style: Styles.medium16Primary(context).copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 25.rH(context)),

                //! Buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          context.read<GlobalCubit>().stopUpdatingDriverLocation();
                          context.read<GlobalCubit>().driverOnline=false;
                          if (context.read<GlobalCubit>().isRider) {
                            context
                                .read<GlobalCubit>()
                                .navBarController
                                .jumpToTab(0);
                          }
                          sl<Cache>().removeKey(AppConstants.token);
                          sl<Cache>().removeKey(AppConstants.role);
                          sl<Cache>().removeKey(AppConstants.user);
                          context.read<GlobalCubit>().getUserData();
                          navigateAndRemoveUntil(
                            context,
                            const ChooseRoleView(),
                          );
                        },
                        title: AppStrings.yes.tr(context),
                        color: AppColors.transparent,
                        borderColor: AppColors.primary,
                        textColor: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 25.rW(context)),
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        title: AppStrings.no.tr(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
