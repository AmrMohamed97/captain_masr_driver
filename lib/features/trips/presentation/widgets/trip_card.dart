import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/partial_star.dart';
import '../../../driver_trip/presentation/widgets/prefernces_items_wrap.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';

class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.model,
    this.tripTitle,
    this.bottomWidget,
    this.onTap,
    this.cancelOnTrip,
    this.isOngoing = false,
  });

  final TripDetailsModel model;
  final String? tripTitle;
  final Widget? bottomWidget;
  final Function()? onTap, cancelOnTrip;
  final bool isOngoing;

  String formatDateTime(String dateTimeString, String locale) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final String formatted =
        DateFormat("EEE, d MMMM | h:mm a", locale).format(dateTime);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            //! Type & Date
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 12.rH(context),
                horizontal: 16.rW(context),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //! Ride Type
                  if (model.type != "round_trip")
                    Text(
                      tripTitle ??
                          (model.tripType == "classic trip"
                              ? AppStrings.classicRide.tr(context)
                              : model.tripType == "group"
                                  ? AppStrings.groupRide.tr(context)
                                  : model.tripType == "share"
                                      ? AppStrings.shareRide.tr(context)
                                      : model.tripType == "delivery"
                                          ? AppStrings.delivery.tr(context)
                                          : ""),
                      style: Styles.semibold16Primary(context).copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  if (!isOngoing && model.type != "round_trip")
                    SizedBox(width: 8.rW(context)),
                  //! Date
                  if (!isOngoing)
                    Expanded(
                      child: Text(
                        model.createdAt != null
                            ? formatDateTime(
                                model.createdAt!,
                                context.read<GlobalCubit>().language,
                              )
                            : "",
                        style: Styles.semibold14Primary(context).copyWith(
                          color: AppColors.white,
                        ),
                        textAlign: model.type != "round_trip"
                            ? TextAlign.center
                            : TextAlign.end,
                      ),
                    ),
                ],
              ),
            ),
            //! Content
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
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //! User Details & Cost
                  if (model.status != "pending")
                    Row(
                      children: [
                        //! User Image
                        if ((!(model.tripType == "share" ||
                                model.tripType == "group" ||
                                model.tripType == "school")) &&
                            (model.driverName == null &&
                                context.read<GlobalCubit>().isRider))
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              context.read<GlobalCubit>().isRider
                                  ? model.driverImage ?? ""
                                  : model.riderImage ?? "",
                              height: 46.rH(context),
                              width: 46.rH(context),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  SvgPicture.asset(
                                Assets.imagesPersonSvg,
                                color: AppColors.grey,
                                height: 46.rH(context),
                              ),
                            ),
                          ),

                        SizedBox(width: 9.rW(context)),

                        //! Users Images & Names (If share, group, school)
                        // if (context.read<GlobalCubit>().isDriver &&
                        //     (model.tripType == "share" ||
                        //         model.tripType == "group" ||
                        //         model.tripType == "school"))
                        //   Expanded(
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         SizedBox(
                        //           height: 52.rH(context),
                        //           child: Stack(
                        //             children: List.generate(
                        //               3,
                        //               (index) {
                        //                 final List<String> images = [
                        //                   Assets.imagesTestProfile1,
                        //                   Assets.imagesTestProfile2,
                        //                   Assets.imagesTestProfileImage,
                        //                 ];
                        //                 return PositionedDirectional(
                        //                   start: 30.rW(context) * index,
                        //                   child: CircleAvatar(
                        //                     radius: 24.rH(context),
                        //                     backgroundColor: AppColors.primary,
                        //                     child: ClipRRect(
                        //                       borderRadius:
                        //                           BorderRadius.circular(50),
                        //                       child: Image.asset(
                        //                         images[index],
                        //                         height: 48.rH(context),
                        //                         fit: BoxFit.cover,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 );
                        //               },
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(height: 6.rH(context)),
                        //         Text(
                        //           "Ahmed & Omar & Yassen",
                        //           style:
                        //               Styles.semibold14Primary(context).copyWith(
                        //             color: Theme.of(context)
                        //                 .textTheme
                        //                 .bodyLarge
                        //                 ?.color,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),

                        //! Name & (Rating Or Preferences)
                        if (!(model.tripType == "share" ||
                            model.tripType == "group" ||
                            model.tripType == "school"))
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //! Name
                                if (model.driverName == null &&
                                    context.read<GlobalCubit>().isRider)
                                  Text(
                                    context.read<GlobalCubit>().isRider
                                        ? model.driverName ?? "??"
                                        : model.riderName ?? "??",
                                    style: Styles.semibold16Primary(context)
                                        .copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                    ),
                                  ),
                                SizedBox(height: 2.rH(context)),
                                //! Rating
                                if (context.read<GlobalCubit>().isRider)
                                  Row(
                                    children: [
                                      SinglePartialStar(
                                        value: model.driverRating?.toDouble() ??
                                            0.0,
                                        starSize: 18.rH(context),
                                      ),
                                      SizedBox(width: 7.rW(context)),
                                      Text(
                                        "${model.driverRating?.toStringAsFixed(3) ?? 0.0}",
                                        style:
                                            Styles.regular14(context).copyWith(
                                          color: AppColors.greyText,
                                        ),
                                      ),
                                    ],
                                  ),
                                //! Preferences
                                if (context.read<GlobalCubit>().isDriver &&
                                    model.preferences != null &&
                                    !(model.tripType == "delivery"))
                                  PreferencesItemsWrap(
                                    preferences: model.preferences!,
                                  ),
                                //! Sending Or Recieving
                                if (context.read<GlobalCubit>().isDriver &&
                                    model.tripType == "delivery")
                                  Row(
                                    children: [
                                      CustomSvgPicture(
                                        svg: model.deliverType == "sending"
                                            ? Assets.imagesSending
                                            : Assets.imagesRecieving,
                                        height: 16.rH(context),
                                      ),
                                      SizedBox(width: 8.rW(context)),
                                      Text(
                                        model.deliverType == "sending"
                                            ? AppStrings.sending.tr(context)
                                            : AppStrings.receiving.tr(context),
                                        style:
                                            Styles.medium14(context).copyWith(
                                          color: AppColors.greyText,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),

                        SizedBox(width: 9.rW(context)),

                        //! Cost
                        if (context.read<GlobalCubit>().isRider)
                          Text(
                            "${model.price ?? 0} ${AppStrings.egp.tr(context)}",
                            style: Styles.semibold20Primary(context).copyWith(
                              color: AppColors.red,
                            ),
                          ),
                      ],
                    ),

                  //! Divider
                  if (model.status != "pending")
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.rH(context)),
                      child: Divider(
                        color: AppColors.greyText.withOpacity(.15),
                      ),
                    ),

                  //! Car Details
                  if (context.read<GlobalCubit>().isRider &&
                      model.status != "pending")
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 16.rH(context),
                      ),
                      child: Row(
                        children: [
                          //! Car Image
                          Image.asset(
                            Assets.imagesTestCar1,
                            height: 27.rH(context),
                          ),
                          SizedBox(width: 11.rW(context)),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //! Car Model
                                Text(
                                  "${model.vehicleBrand ?? "??"} ${model.vehicleModel ?? "??"}",
                                  style: Styles.semibold12(context).copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                ),
                                Text(
                                  "${model.vehicleColor ?? "??"} - ${model.vehiclePlats ?? "??"}",
                                  style: Styles.regular14(context).copyWith(
                                    color: AppColors.greyText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.rW(context)),
                          //! Available Seats
                          // if (model.seats != null)
                          //   Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Text(
                          //         AppStrings.availableSeats.tr(context),
                          //         style: Styles.medium12(context).copyWith(
                          //           color: Theme.of(context)
                          //               .textTheme
                          //               .bodyLarge
                          //               ?.color,
                          //         ),
                          //       ),
                          //       SizedBox(height: 1.rH(context)),
                          //       Text(
                          //         "${model.seats} ${AppStrings.seats.tr(context)}",
                          //         style: Styles.medium14(context).copyWith(
                          //           color: AppColors.red,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                        ],
                      ),
                    ),

                  //! Start & End Point
                  StartAndEndPoint(
                    startValue: model.pickupAddress ?? "??",
                    endValue: model.dropoffAddress ?? "??",
                    startTitle: AppStrings.startPoint.tr(context),
                  ),

                  //! Form And To
                  if (model.type == "round_trip")
                    Padding(
                      padding: EdgeInsets.only(top: 16.rH(context)),
                      child: Row(
                        spacing: 10.rW(context),
                        children: [
                          //! Icon
                          SvgPicture.asset(
                            Assets.imagesCalender,
                            color: AppColors.primary,
                          ),
                          //! Date From
                          Text(
                            model.dateFrom ?? "???",
                            style: Styles.regular14(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          Text(
                            AppStrings.to.tr(context),
                            style: Styles.regular14(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          //! Date To
                          Text(
                            model.dateTo ?? "???",
                            style: Styles.regular14(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ),

                  //! Time
                  if (model.type == "round_trip" && model.time != null)
                    Padding(
                      padding: EdgeInsets.only(top: 8.rH(context)),
                      child: Row(
                        spacing: 10.rW(context),
                        children: [
                          //! Icon
                          SvgPicture.asset(
                            Assets.imagesTime,
                            color: AppColors.primary,
                          ),
                          //! Time
                          Text(
                            formatDateTime(
                              model.time!,
                              context.read<GlobalCubit>().language,
                            ).split("|")[1],
                            style: Styles.regular14(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ),

                  //! Searching For Driver
                  if (isOngoing && model.status == "pending")
                    Padding(
                      padding: EdgeInsets.only(top: 16.rH(context)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.lookingForDrivers.tr(context),
                            style: Styles.bold16(context).copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(
                            height: 24.rH(context),
                            child: const CustomLoadingIndicator(),
                          ),
                        ],
                      ),
                    ),

                  //! Cancel Button
                  if (isOngoing)
                    Padding(
                      padding: EdgeInsets.only(top: 25.rH(context)),
                      child: CustomButton(
                        onPressed: cancelOnTrip ?? () {},
                        title: AppStrings.cancel.tr(context),
                        color: Theme.of(context).cardColor,
                        textColor: AppColors.red,
                        borderColor: AppColors.red,
                      ),
                    ),

                  bottomWidget ?? Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
