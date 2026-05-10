import '../../../../core/imports/imports.dart';
import '../../../base/presentation/views/base_view.dart';

class TripEndedDialog extends StatelessWidget {
  const TripEndedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        elevation: 0,
        content: Container(
          width: 344.rW(context),
          padding: EdgeInsets.symmetric(
            horizontal: 16.rW(context),
            vertical: 24.rH(context),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //! Title
              Text(
                AppStrings.tripIsCompleted.tr(context),
                style: Styles.semibold21Primary(context),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.rH(context)),
              //! Icon
              CustomSvgPicture(
                svg: Assets.imagesCongratulationSvg,
                height: 100.rH(context),
              ),
              SizedBox(height: 24.rH(context)),
              //! Message
              Text(
                AppStrings.youHaveReachedYourFinalDestinationSuccessfully.tr(context),
                style: Styles.medium16Primary(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.rH(context)),
              //! Confirm Button
              CustomButton(
                onPressed: () {
                  final globalCubit = context.read<GlobalCubit>();
                  globalCubit.scaffoldKey.currentState?.closeDrawer();
                  globalCubit.scaffoldKey = GlobalKey<ScaffoldState>();
                  globalCubit.navBarController.jumpToTab(0);
                  navigateAndRemoveUntil(
                    context,
                    const BaseView(),
                  );
                },
                title: AppStrings.goBack.tr(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
