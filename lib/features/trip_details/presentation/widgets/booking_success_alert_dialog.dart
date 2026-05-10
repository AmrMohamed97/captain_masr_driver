import '../../../../core/imports/imports.dart';

class BookingSuccessAlertDialog extends StatefulWidget {
  const BookingSuccessAlertDialog({super.key});

  @override
  State<BookingSuccessAlertDialog> createState() =>
      _BookingSuccessAlertDialogState();
}

class _BookingSuccessAlertDialogState extends State<BookingSuccessAlertDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      elevation: 0,
      content: Container(
        width: 344.rW(context),
        padding: EdgeInsets.symmetric(
          vertical: 24.rH(context),
          horizontal: 16.rW(context),
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
            //! Icon
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
    );
  }
}
