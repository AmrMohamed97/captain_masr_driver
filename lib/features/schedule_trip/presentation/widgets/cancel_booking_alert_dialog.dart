import '../../../../core/imports/imports.dart';

class CancelBookingAlertDialog extends StatelessWidget {
  const CancelBookingAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
              AppStrings.cancelBooking.tr(context),
              style: Styles.semibold21Primary(context),
            ),

            SizedBox(height: 12.rH(context)),

            //! Icon
            CustomSvgPicture(
              svg: Assets.imagesError,
              height: 64.rH(context),
            ),

            SizedBox(height: 12.rH(context)),

            //! Subtitle
            Text(
              AppStrings.areYouSureYouWantToCancelThisBooking.tr(context),
              style: Styles.regular16(context).copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),

            SizedBox(height: 22.rH(context)),

            //! Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    title: AppStrings.yes.tr(context),
                    color: AppColors.transparent,
                    textColor: AppColors.primary,
                    borderColor: AppColors.primary,
                    height: 41.rH(context),
                  ),
                ),
                SizedBox(width: 20.rW(context)),
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    title: AppStrings.no.tr(context),
                    height: 41.rH(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
