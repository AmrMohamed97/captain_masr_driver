import '../../../../core/imports/imports.dart';

class DeleteSavedLocationAlertDialog extends StatelessWidget {
  const DeleteSavedLocationAlertDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      elevation: 0,
      content: Container(
        width: 343.rW(context),
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
              AppStrings.areYouSureYouWantToDeleteThisPlace.tr(context),
              style: Styles.medium16Primary(context).copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 22.rH(context)),
            //! Button
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    title: AppStrings.yes.tr(context),
                    textColor: AppColors.primary,
                    borderColor: AppColors.primary,
                    color: AppColors.transparent,
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
    );
  }
}
