import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/imports/imports.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';

class DriverShareTripRequestAlertDialogShare extends StatelessWidget {
  const DriverShareTripRequestAlertDialogShare({
    super.key,
    required this.tripDetails,
  });

  final TripDetailsModel tripDetails;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.transparent,
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
                  AppStrings.shareTrips.tr(context),
                  style: Styles.semibold16Primary(context).copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 21.rH(context)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.rW(context),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //! Rider Details & Cost
                  Row(
                    children: [
                      //! Rider Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          tripDetails.riderImage ?? "",
                          height: 46.rH(context),
                          width: 46.rH(context),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              SvgPicture.asset(
                            Assets.imagesPersonSvg,
                            height: 46.rH(context),
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                      SizedBox(width: 9.rW(context)),
                      //! Name & Prefernces
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //! Name
                            Text(
                              tripDetails.riderName ?? "",
                              style: Styles.semibold14Primary(context).copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            ),
                            SizedBox(height: 4.rH(context)),
                            //! Prefernces
                            // const PreferncesItemsWrap(
                            //   items: [
                            //     Assets.imagesAirConditioner,
                            //     Assets.imagesMusic,
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.rW(context)),
                      //! Cost
                      Text(
                        "${tripDetails.price ?? "??"} ${AppStrings.egp.tr(context)}",
                        style: Styles.semibold20Primary(context).copyWith(
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  ),
                  //! Divider
                  CustomDivider(
                    topSpace: 16.rH(context),
                    bottomSpace: 12.rH(context),
                  ),
                  //! Start & End Points
                  StartAndEndPoint(
                    startValue: tripDetails.pickupAddress ?? "",
                    endValue: tripDetails.dropoffAddress ?? "",
                    startTitle: AppStrings.startPoint.tr(context),
                  ),
                  //! Divider
                  CustomDivider(space: 12.rH(context)),
                  //! Distance & Duration
                  DistanceAndDuration(
                    distance: tripDetails.distanceKm?.toString() ?? "??",
                    duration: tripDetails.timeMinutes?.toString() ?? "??",
                  ),
                  SizedBox(height: 16.rH(context)),
                  //! Buttons
                  Row(
                    children: [
                      //! Decline
                      Expanded(
                        child: CustomButton(
                          onPressed: () => Navigator.pop(context,false),
                          title: AppStrings.decline.tr(context),
                          color: AppColors.transparent,
                          textColor: AppColors.primary,
                          borderColor: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 22.rW(context)),
                      //! Accept
                      Expanded(
                        child: CustomButton(
                          onPressed: () => Navigator.pop(context, true),
                          title: AppStrings.accept.tr(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.rH(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
