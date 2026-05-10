import 'package:flutter_svg/svg.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/partial_star.dart';
import '../../../driver_trip/presentation/widgets/prefernces_items_wrap.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';
import '../../../trip_details/presentation/views/trip_details_view.dart';

class HomeTripCard extends StatelessWidget {
  const HomeTripCard({
    super.key,
    required this.model,
  });

  final TripDetailsModel model;

  @override
  Widget build(BuildContext context) {
    final isRider = context.read<GlobalCubit>().isRider;
    return GestureDetector(
      onTap: () {
        navBarNavigate(
          context: context,
          widget: TripDetailsView(
            tripId: model.rideId ?? 0,
            isAccepted: false,
            isCompleted: true,
            isClassic: model.tripType == "classic trip",
            isGroup: false,
            isShare: false,
            isDelivery: model.tripType == "delivery",
            isScheduled: false,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 16.rH(context)),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 2.rH(context)),
              blurRadius: 11,
              color: AppColors.black.withOpacity(.14),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                bottom: 1.rH(context),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 17.rH(context),
                horizontal: 16.rW(context),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //! User Details & Cost
                  Row(
                    children: [
                      //! User Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          isRider
                              ? model.driverImage ?? ""
                              : model.riderImage ?? "",
                          height: 46.rH(context),
                          width: 46.rH(context),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              SvgPicture.asset(
                            Assets.imagesPersonSvg,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                      SizedBox(width: 9.rW(context)),

                      //! Name & Rating
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //! Name
                            Text(
                              isRider
                                  ? model.driverName ?? ""
                                  : model.riderName ?? "",
                              style: Styles.semibold16Primary(context).copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            ),
                            SizedBox(height: 2.rH(context)),
                            //! Rating
                            if (isRider)
                              Row(
                                children: [
                                  SinglePartialStar(
                                    value:
                                        model.driverRating?.toDouble() ?? 0.0,
                                    starSize: 18.rH(context),
                                  ),
                                  SizedBox(width: 7.rW(context)),
                                  Text(
                                    "${model.driverRating?.toStringAsFixed(3) ?? 0.0}",
                                    style: Styles.regular14(context).copyWith(
                                      color: AppColors.greyText,
                                    ),
                                  ),
                                ],
                              ),
                            //! Preferences
                            if (!isRider && model.preferences != null)
                              PreferencesItemsWrap(
                                preferences: model.preferences!,
                              ),
                          ],
                        ),
                      ),

                      SizedBox(width: 9.rW(context)),

                      //! Cost
                      Text(
                        "${model.price ?? "??"} ${AppStrings.egp.tr(context)}",
                        style: Styles.semibold20Primary(context).copyWith(
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  ),

                  //! Divider
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.rH(context)),
                    child: Divider(
                      color: AppColors.greyText.withOpacity(.15),
                    ),
                  ),

                  //! Gatharing & End Point
                  StartAndEndPoint(
                    startValue: model.pickupAddress ?? "...",
                    endValue: model.dropoffAddress ?? "...",
                    startTitle: AppStrings.startPoint.tr(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
