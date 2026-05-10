import '../../../../core/imports/imports.dart';

class RiderRegisterCongratulationAlertDialog extends StatefulWidget {
  const RiderRegisterCongratulationAlertDialog({
    super.key,
  });

  @override
  State<RiderRegisterCongratulationAlertDialog> createState() =>
      _RiderRegisterCongratulationAlertDialogState();
}

class _RiderRegisterCongratulationAlertDialogState
    extends State<RiderRegisterCongratulationAlertDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        navigateAndRemoveUntil(context, const BaseView());
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
          width: 329.rW(context),
          padding: EdgeInsets.symmetric(
            horizontal: 24.rW(context),
            vertical: 24.rH(context),
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //! Header Title
              Text(
                AppStrings.congratulations.tr(context),
                style: Styles.semibold22Primary(context),
              ),
              SizedBox(height: 24.rH(context)),
              //! Icon
              CustomSvgPicture(
                svg: Assets.imagesReiderRegisterCongratulations,
                height: 140.rH(context),
              ),
              SizedBox(height: 24.rH(context)),
              //! Title
              Text(
                AppStrings.youraccountIsNowReadyToUse.tr(context),
                style: Styles.semibold16Primary(context).copyWith(
                  color: AppColors.textColor,
                ),
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.rH(context)),
              //! Subtitle
              Text(
                AppStrings.youWillBeRedirectedToTheHomePageShortly.tr(context),
                style: Styles.regular16(context).copyWith(
                  color: AppColors.greyText,
                ),
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.rH(context)),
              const CustomLoadingIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
