import '../../../../core/imports/imports.dart';

class CancelTripAlertDialog extends StatelessWidget {
  const CancelTripAlertDialog({
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
          horizontal: 16.rW(context),
          vertical: 24.rH(context),
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //! Title
            Text(
              AppStrings.cancelTrip.tr(context),
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
              AppStrings.areYouSureYouWantToCancelThisTrip.tr(context),
              style: Styles.regular14(context).copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 22.rH(context)),

            //! Buttons
            Row(
              children: [
                //! Yes
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    title: AppStrings.yes.tr(context),
                    textColor: AppColors.primary,
                    borderColor: AppColors.primary,
                    color: Theme.of(context).cardColor,
                  ),
                ),
                SizedBox(width: 22.rW(context)),
                //! No
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
    );
  }
}
