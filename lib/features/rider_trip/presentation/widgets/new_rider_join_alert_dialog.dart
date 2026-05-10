import '../../../../core/imports/imports.dart';

class NewRiderJoinAlertDialog extends StatelessWidget {
  const NewRiderJoinAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      elevation: 0,
      content: Container(
        width: 344.rW(context),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 24.rH(context)),

            //! Title
            Text(
              AppStrings.aNewRiderJoinToYou.tr(context),
              style: Styles.semibold21Primary(context),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.rH(context)),

            //! Subtitle
            Text(
              AppStrings.yourDriverHasAcceptedAnotherRider.tr(context),
              style: Styles.regular14(context).copyWith(
                color: AppColors.greyText,
              ),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 12.rH(context)),

            //! Image
            Image.asset(
              Assets.imagesNewRiderJoinPng,
              height: 180.rH(context),
            ),

            //! Bottom Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 25.rH(context)),

                  //! Title
                  Text(
                    AppStrings.nowYourRideFareIs.tr(context),
                    style: Styles.semibold14Primary(context).copyWith(
                      color: AppColors.white,
                    ),
                  ),

                  SizedBox(height: 8.rH(context)),

                  //! New Price
                  Container(
                    height: 59.rH(context),
                    padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomSvgPicture(
                          svg: Assets.imagesDiscount,
                          height: 24.rH(context),
                        ),
                        SizedBox(width: 5.rW(context)),
                        //! New Price
                        Text(
                          "80 ${AppStrings.egp.tr(context)} ",
                          style: Styles.medium20white(context).copyWith(
                            color: AppColors.red,
                          ),
                        ),
                        //! Old Price
                        Text(
                          "100 ${AppStrings.egp.tr(context)}",
                          style: Styles.medium20white(context).copyWith(
                            color: AppColors.greyText,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: AppColors.greyText,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.rH(context)),

                  //! Continue Trip
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      AppStrings.continueTrip.tr(context),
                      style: Styles.semibold18Primary(context).copyWith(
                        color: AppColors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.white,
                      ),
                    ),
                  ),

                  SizedBox(height: 21.rH(context)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
