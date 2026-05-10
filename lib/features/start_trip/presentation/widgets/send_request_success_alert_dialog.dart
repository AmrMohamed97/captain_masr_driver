import '../../../../core/imports/imports.dart';
import '../../../home/presentation/views/home_view.dart';

class SendRequestSuccessAlertDialog extends StatefulWidget {
  const SendRequestSuccessAlertDialog({
    super.key,
  });

  @override
  State<SendRequestSuccessAlertDialog> createState() =>
      _SendRequestSuccessAlertDialogState();
}

class _SendRequestSuccessAlertDialogState
    extends State<SendRequestSuccessAlertDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        final globalCubit = context.read<GlobalCubit>();
        globalCubit.scaffoldKey.currentState?.closeDrawer();
        globalCubit.scaffoldKey = GlobalKey<ScaffoldState>();
        globalCubit.navBarController.jumpToTab(0);
        navigateAndRemoveUntil(
          context,
          context.read<GlobalCubit>().isRider
              ? const BaseView()
              : const HomeView(),
        );
      },
    );
  }

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
                AppStrings.tripRequest.tr(context),
                style: Styles.semibold21Primary(context),
              ),
              //! Svg
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.rH(context)),
                child: CustomSvgPicture(
                  svg: Assets.imagesDone,
                  height: 64.rH(context),
                ),
              ),
              //! Subtitle
              Text(
                AppStrings.yourRequestHasBeenSent.tr(context),
                style: Styles.regular16(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.rH(context)),
              Text(
                AppStrings.weWillNotifyYouWhenYourRequestIsAccepted.tr(context),
                style: Styles.medium14(context).copyWith(
                  color: AppColors.greyText,
                ),
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
