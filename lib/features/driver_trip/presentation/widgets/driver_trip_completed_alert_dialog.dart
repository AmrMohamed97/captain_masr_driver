import 'package:flutter_svg/svg.dart';

import '../../../../core/imports/imports.dart';
import '../../../home/presentation/views/home_view.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';
import '../../data/models/complete_trip_response_model.dart';

class DriverTripCompletedAlertDialog extends StatelessWidget {
  const DriverTripCompletedAlertDialog({
    super.key,
    required this.model,
    this.completedTripsToday,
    this.isDeliveryTrip = false,
    this.continueTrip = true,
    this.completeTripResponseModel,
  });
  final CompleteTripResponseModel? completeTripResponseModel;
  final int? completedTripsToday;
  final TripDetailsModel model;
  final bool isDeliveryTrip, continueTrip;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        elevation: 0,
        insetPadding: EdgeInsets.zero,
        content: Container(
          width: 344.rW(context),
          padding: EdgeInsets.symmetric(
            horizontal: 16.rW(context),
            vertical: 19.rH(context),
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
                AppStrings.tripIsCompleted.tr(context),
                style: Styles.semibold21Primary(context),
              ),
              SizedBox(height: 25.rH(context)),
              //! Icon
              CustomSvgPicture(
                svg: isDeliveryTrip
                    ? Assets.imagesPackageDone
                    : Assets.imagesLocationDone,
                height: 78.rH(context),
              ),
              SizedBox(height: 25.rH(context)),
              //! Subtitle
              Text(
                AppStrings.youHaveCompleted.tr(context),
                style: Styles.semibold20Primary(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              SizedBox(height: 9.rH(context)),
              //! Trips Today
              if (completedTripsToday != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      completedTripsToday!.toString(),
                      style: Styles.semibold22Primary(context).copyWith(
                        color: AppColors.red,
                      ),
                    ),
                    SizedBox(width: 9.rW(context)),
                    Text(
                      AppStrings.tripsToday.tr(context),
                      style: Styles.medium15(context).copyWith(
                        color: AppColors.greyText,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 12.rH(context)),
              //! Trip Details
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 10.rW(context),
                  vertical: 11.rH(context),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //! Title
                    Text(
                      AppStrings.tripDetails.tr(context),
                      style: Styles.semibold16Primary(context).copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    SizedBox(height: 20.rH(context)),
                    //! Rider Details
                    Row(
                      children: [
                        //! Rider Image
                        CircleAvatar(
                          radius: 23.rH(context),
                          backgroundColor: AppColors.transparent,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              model.riderImage ?? "",
                              errorBuilder: (context, error, stackTrace) =>
                                  SvgPicture.asset(
                                Assets.imagesPersonSvg,
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 9.rW(context)),
                        //! Name & Prefernces
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.riderName ?? "??",
                                style:
                                    Styles.semibold14Primary(context).copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                ),
                              ),
                              SizedBox(height: 4.rH(context)),
                              //! Preferences
                              if (!isDeliveryTrip)
                                Wrap(
                                  direction: Axis.horizontal,
                                  children: List.generate(
                                    4,
                                    (index) {
                                      return (model.preferences?.coolRide !=
                                                      true &&
                                                  index == 0) ||
                                              (model.preferences?.quietRide !=
                                                      true &&
                                                  index == 1) ||
                                              (model.preferences
                                                          ?.smokingFriendly !=
                                                      true &&
                                                  index == 2) ||
                                              (model.preferences?.petsFree !=
                                                      true &&
                                                  index == 3)
                                          ? const SizedBox.shrink()
                                          : Container(
                                              width: 22.rW(context),
                                              height: 22.rH(context),
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                end: 5.rW(context),
                                                top: 4.rH(context),
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.grey3
                                                    .withOpacity(.25),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Center(
                                                child: SizedBox(
                                                  height: 16.rH(context),
                                                  width: 16.rW(context),
                                                  child: CustomSvgPicture(
                                                    svg: (switch (index) {
                                                      0 => Assets
                                                          .imagesAirConditioner,
                                                      1 => Assets.imagesMusic,
                                                      2 => Assets.imagesSmoking,
                                                      3 => Assets.imagesPets,
                                                      _ => "",
                                                    }),
                                                  ),
                                                ),
                                              ),
                                            );
                                    },
                                  ),
                                ),
                              //! Sending Or Recieving
                              if (isDeliveryTrip)
                                Row(
                                  children: [
                                    CustomSvgPicture(
                                      svg: Assets.imagesSending,
                                      height: 18.rH(context),
                                    ),
                                    SizedBox(width: 8.rW(context)),
                                    Text(
                                      AppStrings.sending.tr(context),
                                      style: Styles.semibold14Primary(context)
                                          .copyWith(
                                        color: AppColors.greyText,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        SizedBox(width: 9.rW(context)),
                        //! Distance & Duration
                        Column(
                          children: [
                            //! Distance
                            Row(
                              children: [
                                CustomSvgPicture(
                                  svg: Assets.imagesPinLocation,
                                  height: 17.rH(context),
                                  color: AppColors.red,
                                ),
                                SizedBox(width: 8.rH(context)),
                                Text(
                                  "${model.distanceKm ?? "??"} ${AppStrings.km.tr(context)}"
                                    ..tr(context),
                                  style: Styles.medium12(context).copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 9.5.rH(context)),
                            //! Duration
                            Row(
                              children: [
                                CustomSvgPicture(
                                  svg: Assets.imagesTime,
                                  height: 17.rH(context),
                                  color: AppColors.yellow,
                                ),
                                SizedBox(width: 8.rH(context)),
                                Text(
                                  "${model.timeMinutes ?? "??"} ${AppStrings.min.tr(context)}"
                                    ..tr(context),
                                  style: Styles.medium12(context).copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    //! Divider
                    CustomDivider(
                      topSpace: 13.rH(context),
                      bottomSpace: 16.rH(context),
                    ),
                    //! Start & End Point
                    StartAndEndPoint(
                      startValue: model.pickupAddress ?? "??",
                      endValue: model.dropoffAddress ?? "??",
                      startTitle: AppStrings.startPoint.tr(context),
                    ),
                    SizedBox(height: 4.rH(context)),
                  ],
                ),
              ),
              SizedBox(height: 12.rH(context)),
              //! Costs
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 8.rW(context),
                  vertical: 11.rH(context),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    3,
                    (index) {
                      final payment = completeTripResponseModel?.data?.payment;
                      String formatNum(num? value) {
                        if (value == null) return '0';
                        return value
                            .toStringAsFixed(3)
                            .replaceAll(RegExp(r'\.?0+$'), '');
                      }

                      String formatStr(String? s) {
                        if (s == null) return '0';
                        final n = num.tryParse(s);
                        return n != null ? formatNum(n) : s;
                      }

                      final List<String> titles = [
                        AppStrings.totalCost,
                        AppStrings.systemCut,
                        AppStrings.driverEarning,
                      ];
                      final List<String> values = [
                        formatStr(payment?.total ?? model.price?.toString()),
                        formatNum(payment?.systemCut),
                        formatNum(payment?.driverEarning),
                      ];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index != 2 ? 12.rH(context) : 0,
                        ),
                        child: Row(
                          children: [
                            //! Title
                            Text(
                              titles[index].tr(context),
                              style: Styles.medium14(context).copyWith(
                                color: AppColors.greyText,
                              ),
                            ),
                            SizedBox(width: 8.rW(context)),
                            //! Value
                            Expanded(
                              child: Text(
                                "${values[index]} ${AppStrings.egp.tr(context)}",
                                style:
                                    Styles.semibold14Primary(context).copyWith(
                                  color: index == 2
                                      ? AppColors.red
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.rH(context)),
              //! Ok Button
              CustomButton(
                onPressed: () {
                  if (continueTrip) {
                    Navigator.pop(context, true);
                  } else {
                    final globalCubit = context.read<GlobalCubit>();
                    globalCubit.scaffoldKey.currentState?.closeDrawer();
                    globalCubit.scaffoldKey = GlobalKey<ScaffoldState>();
                    globalCubit.navBarController.jumpToTab(0);
                    navigateAndRemoveUntil(
                      context,
                      context.read<GlobalCubit>().isRider
                          ? const BaseView()
                          : const HomeView(),
                    );
                  }
                },
                title: AppStrings.oK.tr(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
