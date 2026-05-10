import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/seats_number.dart';

class OnMyWayRiderRequestAlertDialog extends StatelessWidget {
  const OnMyWayRiderRequestAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      elevation: 0,
      insetPadding: EdgeInsets.zero,
      alignment: Alignment.topCenter,
      backgroundColor: AppColors.transparent,
      content: Container(
        width: 344.rW(context),
        margin: EdgeInsets.only(top: 24.rH(context)),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //! Header
            Container(
              width: double.infinity,
              height: 46.rH(context),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Text(
                  AppStrings.newRider.tr(context),
                  style: Styles.semibold16Primary(context).copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            //! Content
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.rW(context),
              ),
              child: Column(
                children: [
                  SizedBox(height: 21.rH(context)),
                  //! Riders Details & Cost
                  Row(
                    children: [
                      //! Rider Image
                      CircleAvatar(
                        radius: 23.rH(context),
                        backgroundColor: AppColors.transparent,
                        child: Image.network(
                          Assets.imagesTestProfile2,
                          fit: BoxFit.cover,
                          height: 46.rH(context),
                        ),
                      ),
                      SizedBox(width: 9.rW(context)),
                      //! Name & Preferences
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ahmed Ali",
                              style: Styles.semibold14Primary(context).copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            ),
                            SizedBox(height: 4.rH(context)),
                            // const PreferncesItemsWrap(
                            //   items: [
                            //     Assets.imagesAirConditioner,
                            //     Assets.imagesMusic,
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(width: 9.rW(context)),
                      //! Cost
                      Text(
                        "100 ${AppStrings.egp.tr(context)}",
                        style: Styles.semibold20Primary(context).copyWith(
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.rH(context)),
                  //! Seats Needed
                  Row(
                    children: [
                      Text(
                        AppStrings.seatsNeeded.tr(context),
                        style: Styles.regular14(context).copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      const Spacer(),
                      const SeatsNumber(seatsNumber: 2),
                    ],
                  ),
                  //! Divider
                  CustomDivider(space: 12.rH(context)),
                  //! Start & End Point
                  StartAndEndPoint(
                    startValue: "Elnasr street, Elmaadi, Cairo",
                    endValue: "Elbatrawy street,  Nasr City , Cairo",
                    startTitle: AppStrings.startPoint.tr(context),
                  ),
                  //! Divider
                  CustomDivider(space: 12.rH(context)),
                  //! Distance & Duration
                  const DistanceAndDuration(
                    distance: "8.5",
                    duration: "15",
                  ),
                  SizedBox(height: 16.rH(context)),
                  //! Buttons
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          title: AppStrings.decline.tr(context),
                          color: AppColors.transparent,
                          textColor: AppColors.primary,
                          borderColor: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 22.rW(context)),
                      Expanded(
                        child: CustomButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          title: AppStrings.accept.tr(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 13.rH(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
