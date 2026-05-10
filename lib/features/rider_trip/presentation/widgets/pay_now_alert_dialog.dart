import '../../../../core/imports/imports.dart';

class PayNowAlertDialog extends StatelessWidget {
  const PayNowAlertDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      elevation: 0,
      content: Container(
        width: 344.rW(context),
        padding: EdgeInsets.symmetric(
          horizontal: 36.rW(context),
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
              AppStrings.youAreAlmostThere.tr(context),
              style: Styles.semibold21Primary(context),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.rH(context)),
            //! Icon
            CustomSvgPicture(
              svg: Assets.imagesPayNow,
              height: 61.rH(context),
            ),
            SizedBox(height: 12.rH(context)),
            //! Subtitle
            Text(
              AppStrings.makeYourPaymentNowAndEnjoySmoothFinish.tr(context),
              style: Styles.regular16(context).copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 22.rH(context)),
            //! Pay Now Button
            CustomButton(
              onPressed: () => Navigator.pop(context),
              title: AppStrings.payNow.tr(context),
            ),
          ],
        ),
      ),
    );
  }
}
