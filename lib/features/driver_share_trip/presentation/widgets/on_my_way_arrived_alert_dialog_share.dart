import '../../../../core/imports/imports.dart';
import '../../../home/presentation/views/home_view.dart';

class OnMyWayArrivedAlertDialogShare extends StatefulWidget {
  const OnMyWayArrivedAlertDialogShare({super.key});

  @override
  State<OnMyWayArrivedAlertDialogShare> createState() =>
      _OnMyWayArrivedAlertDialogShareState();
}

class _OnMyWayArrivedAlertDialogShareState extends State<OnMyWayArrivedAlertDialogShare> {
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
            horizontal: 19.rW(context),
            vertical: 19.rH(context),
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
                AppStrings.youHaveArrived.tr(context),
                style: Styles.semibold22Primary(context),
              ),
              //! Icon
              Padding(
                padding: EdgeInsets.only(
                  top: 13.rH(context),
                  bottom: 23.rH(context),
                ),
                child: CustomSvgPicture(
                  svg: Assets.imagesLocationDone,
                  height: 72.rH(context),
                ),
              ),
              //! Subtitle
              Text(
                AppStrings.youHaveReachedYourFinalDestinationSuccessfully
                    .tr(context),
                style: Styles.semibold16Primary(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
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
