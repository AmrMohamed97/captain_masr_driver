import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/partial_star.dart';
import '../../../../core/widgets/seats_number.dart';
import '../../../driver_trip/presentation/widgets/prefernces_items_wrap.dart';
import '../../../home/presentation/views/home_view.dart';
import '../../../preferences/presentation/widgets/preferences_alert_dialog.dart';
import '../../../start_trip/presentation/views/start_trip_view.dart';
import '../../../trips/presentation/widgets/cancel_trip_alert_dialog.dart';
import '../../../trips/presentation/widgets/reason_of_cancel_trip_alert_dialog.dart';
import '../../../wallet/presentation/views/payment_methods_view.dart';
import 'booking_card.dart';
import 'booking_promo_code.dart';
import 'booking_success_alert_dialog.dart';
import 'trip_details_package_details_section.dart';

class TripDetailsBody extends StatelessWidget {
  const TripDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripDetailsCubit, TripDetailsState>(
      builder: (context, state) {
        final cubit = context.read<TripDetailsCubit>();
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
          child: Column(
            children: [
              //! Header
              CustomAppBar(
                title: cubit.isScheduled
                    ? AppStrings.tripDetails.tr(context)
                    : cubit.isClassic
                        ? AppStrings.classicRide.tr(context)
                        : cubit.isGroup
                            ? AppStrings.groupRide.tr(context)
                            : cubit.isShare
                                ? AppStrings.shareRide.tr(context)
                                : cubit.isDelivery
                                    ? AppStrings.delivery.tr(context)
                                    : AppStrings.tripDetails.tr(context),
              ),

              SizedBox(height: 16.rH(context)),

              if (cubit.tripDetails != null)
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      //! Completed Date & Time
                      if (cubit.isCompleted)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 18.rH(context),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 37.rH(context),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.rW(context),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                //! Date
                                CustomSvgPicture(
                                  svg: Assets.imagesCalender,
                                  height: 19.rH(context),
                                ),
                                SizedBox(width: 10.rW(context)),
                                Text(
                                  cubit.formatTripDate(
                                    locale:
                                        context.read<GlobalCubit>().language,
                                  ),
                                  style: Styles.medium14(context).copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                ),
                                const Spacer(),
                                //! Time
                                CustomSvgPicture(
                                  svg: Assets.imagesTime,
                                  height: 19.rH(context),
                                ),
                                SizedBox(width: 10.rW(context)),
                                Text(
                                  cubit.formatTripTime(
                                    locale:
                                        context.read<GlobalCubit>().language,
                                  ),
                                  style: Styles.medium14(context).copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      //! Riders (If Driver & share or group or school Trip)
                      if (context.read<GlobalCubit>().isDriver &&
                          (cubit.isShare || cubit.isGroup))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 56.rH(context),
                              child: Center(
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: List.generate(
                                    cubit.riders.length,
                                    (index) {
                                      return Positioned(
                                        left: 60.rW(context) * index,
                                        right: 60.rW(context),
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                cubit.selectRider(index);
                                              },
                                              child: CircleAvatar(
                                                radius: 24.rH(context),
                                                backgroundColor:
                                                    cubit.selectedRider == index
                                                        ? AppColors.primary
                                                        : AppColors.transparent,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image.asset(
                                                    cubit.riders[index],
                                                    height: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 3.rH(context)),
                                            CircleAvatar(
                                              radius: 2.rH(context),
                                              backgroundColor:
                                                  cubit.selectedRider == index
                                                      ? AppColors.primary
                                                      : AppColors.greyText
                                                          .withOpacity(.5),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "Ahmed & Omar & Yassen",
                              style: Styles.semibold14Primary(context).copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            ),
                          ],
                        ),

                      //! Driver Or User Details
                      if (!cubit.isShare && !cubit.isGroup)
                        Column(
                          children: [
                            //! Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                context.read<GlobalCubit>().isRider
                                    ? cubit.tripDetails!.driverImage ?? ""
                                    : cubit.tripDetails!.riderImage ?? "",
                                height: 80.rH(context),
                                width: 80.rH(context),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    SvgPicture.asset(
                                  Assets.imagesPersonSvg,
                                  color: AppColors.grey,
                                  height: 80.rH(context),
                                ),
                              ),
                            ),
                            SizedBox(height: 11.rH(context)),
                            //! Name
                            Text(
                              context.read<GlobalCubit>().isRider
                                  ? cubit.tripDetails!.driverName ?? ""
                                  : cubit.tripDetails!.riderName ?? "",
                              style: Styles.semibold16Primary(context).copyWith(
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SinglePartialStar(
                                    value: cubit.tripDetails!.driverRating
                                            ?.toDouble() ??
                                        0.0,
                                    starSize: 20.rH(context),
                                  ),
                                  SizedBox(width: 5.rW(context)),
                                  Text(
                                    cubit.tripDetails!.driverRating
                                            ?.toString() ??
                                        "0.0",
                                    style: Styles.regular14(context).copyWith(
                                      color: AppColors.greyText,
                                    ),
                                  ),
                                ],
                              ),
                            //! Preferences
                            if (context.read<GlobalCubit>().isDriver &&
                                cubit.tripDetails!.preferences != null &&
                                !cubit.isDelivery)
                              PreferencesItemsWrap(
                                preferences: cubit.tripDetails!.preferences!,
                              ),
                            //! Sending Or Recieving (If Delivery)
                            if (context.read<GlobalCubit>().isDriver &&
                                cubit.isDelivery)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomSvgPicture(
                                    svg: cubit.tripDetails!.deliverType ==
                                            "sending"
                                        ? Assets.imagesSending
                                        : Assets.imagesRecieving,
                                    height: 18.rH(context),
                                  ),
                                  SizedBox(width: 8.rW(context)),
                                  Text(
                                    cubit.tripDetails!.deliverType == "sending"
                                        ? AppStrings.sending.tr(context)
                                        : AppStrings.receiving.tr(context),
                                    style: Styles.semibold14Primary(context)
                                        .copyWith(
                                      color: AppColors.greyText,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),

                      //! Divider
                      CustomDivider(space: 8.rH(context)),

                      //! Car Details
                      if (context.read<GlobalCubit>().isRider)
                        Row(
                          children: [
                            //! Car Image
                            Image.asset(
                              Assets.imagesTestCar1,
                              height: 27.rH(context),
                            ),
                            SizedBox(width: 11.rW(context)),
                            //! Name & Number
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //! Name
                                  Text(
                                    "${cubit.tripDetails!.vehicleBrand ?? ""} ${cubit.tripDetails!.vehicleModel ?? ""}",
                                    style: Styles.semibold12(context).copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                    ),
                                  ),
                                  SizedBox(height: 1.rH(context)),
                                  //! Number & Color
                                  Text(
                                    "${cubit.tripDetails!.vehicleColor ?? "??"} - ${cubit.tripDetails!.vehiclePlats ?? "??"}",
                                    style: Styles.regular12(context).copyWith(
                                      color: AppColors.greyText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //! Available Seats
                            if (cubit.isGroup || cubit.isScheduled)
                              Column(
                                children: [
                                  Text(
                                    AppStrings.availableSeats.tr(context),
                                    style: Styles.medium12(context).copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                    ),
                                  ),
                                  SizedBox(height: 1.rH(context)),
                                  Text(
                                    "2 ${AppStrings.seats.tr(context)}",
                                    style: Styles.medium14(context).copyWith(
                                      color: AppColors.red,
                                    ),
                                  ),
                                ],
                              ),
                            //! Co-Riders
                            if (cubit.isShare)
                              Column(
                                children: [
                                  Text(
                                    AppStrings.coRiders.tr(context),
                                    style: Styles.medium12(context).copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                    ),
                                  ),
                                  SizedBox(height: 1.rH(context)),
                                  Text(
                                    "3 ${AppStrings.riders.tr(context)}",
                                    style: Styles.medium14(context).copyWith(
                                      color: AppColors.red,
                                    ),
                                  ),
                                ],
                              ),
                            //! Prefernces
                            if (cubit.isClassic)
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        PreferencesAlertDialog(
                                      preferencesModel:
                                          cubit.tripDetails!.preferences,
                                      canEdit: false,
                                      showCantEditTitle: false,
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomSvgPicture(
                                      svg: Assets.imagesPreferences,
                                      height: 24.rH(context),
                                    ),
                                    SizedBox(width: 6.rW(context)),
                                    Text(
                                      AppStrings.preferences.tr(context),
                                      style: Styles.regular14(context).copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),

                      SizedBox(height: 20.rH(context)),

                      //! Destination
                      CustomTable(
                        title: AppStrings.destination.tr(context),
                        child: StartAndEndPoint(
                          startValue: cubit.tripDetails!.pickupAddress ?? "??",
                          endValue: cubit.tripDetails!.dropoffAddress ?? "??",
                          startTitle: AppStrings.gatheringPoint.tr(context),
                        ),
                      ),

                      SizedBox(height: 19.rH(context)),

                      //! Completed Distance & Duration
                      if (cubit.isCompleted)
                        Column(
                          children: [
                            CustomDivider(
                              bottomSpace: 16.rH(context),
                            ),
                            DistanceAndDuration(
                              distance:
                                  cubit.tripDetails!.distanceKm?.toString() ??
                                      "??",
                              duration:
                                  cubit.tripDetails!.timeMinutes?.toString() ??
                                      "??",
                            ),
                            SizedBox(height: 16.rH(context)),
                          ],
                        ),

                      //! Package Details & Note
                      if (cubit.isDelivery)
                        TripDetailsPackageDetailsSection(
                          model: cubit.tripDetails!,
                        ),

                      //! Duration
                      // if (cubit.isGroup || cubit.isScheduled)
                      //   CustomTable(
                      //     title: AppStrings.duration.tr(context),
                      //     child: const DurationFromToRow(
                      //       from: "Tue, 6 April",
                      //       to: "Mon, 12 April",
                      //     ),
                      //   ),

                      if (!cubit.isCompleted) SizedBox(height: 20.rH(context)),

                      //! Booking Card
                      if (!cubit.isAccepted && !cubit.isCompleted)
                        const BookingCard(),

                      //! Days You Want
                      if (cubit.isGroup)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              color: AppColors.greyText.withOpacity(.5),
                            ),
                            SizedBox(height: 18.rH(context)),
                            Text(
                              AppStrings.daysYouWant.tr(context),
                              style: Styles.medium16Primary(context).copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            ),
                            SizedBox(height: 16.rH(context)),
                            SizedBox(
                              height: 70.rH(context),
                              child: ListView.separated(
                                itemCount: 5,
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) {
                                  return SizedBox(width: 12.rW(context));
                                },
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 47.rW(context),
                                    height: 70.rH(context),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(.15),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 24.rH(context),
                                          child: FittedBox(
                                            child: Text(
                                              cubit.daysFromTo[index].day
                                                  .toString(),
                                              style: Styles.semibold18Primary(
                                                      context)
                                                  .copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.color,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 2.rH(context)),
                                        SizedBox(
                                          height: 14.rH(context),
                                          child: FittedBox(
                                            child: Text(
                                              DateFormat('EEE').format(
                                                  cubit.daysFromTo[index]),
                                              style: Styles.semibold18Primary(
                                                      context)
                                                  .copyWith(
                                                color: AppColors.greyText,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 18.rH(context)),
                          ],
                        ),

                      //! Gathering & Returning Time
                      if (cubit.isGroup)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //! Title
                            Text(
                              AppStrings.gatheringAndReturningTime.tr(context),
                              style: Styles.medium16Primary(context).copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            ),
                            SizedBox(height: 10.rH(context)),
                            Row(
                              children: [
                                //! Start
                                Expanded(
                                  child: CustomSelectContainer(
                                    value: "06:27 AM",
                                    onTap: () {},
                                    svg: Assets.imagesTime,
                                    icon: Container(),
                                    borderColor: AppColors.primary,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 18.rW(context),
                                  ),
                                  child: Text(
                                    AppStrings.to.tr(context),
                                    style: Styles.regular14(context).copyWith(
                                      color: AppColors.greyText,
                                    ),
                                  ),
                                ),
                                //! End
                                Expanded(
                                  child: CustomSelectContainer(
                                    value: "12:27 PM",
                                    onTap: () {},
                                    svg: Assets.imagesTime,
                                    icon: Container(),
                                    borderColor: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.rH(context)),
                          ],
                        ),

                      //! Seats Needs
                      if (cubit.isGroup || cubit.isShare)
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.rH(context)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  AppStrings.seatsNeeded.tr(context),
                                  style: Styles.regular16(context).copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                ),
                              ),
                              const SeatsNumber(seatsNumber: 2),
                            ],
                          ),
                        ),

                      //! Total Cost
                      if ((cubit.isAccepted || cubit.isCompleted)&&cubit.tripDetails?.price!=null)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 16.rH(context),
                          ),
                          child: CostRow(
                            cost: cubit.tripDetails!.price ?? 0.0,
                            costBeforeDiscount: null,
                            title: AppStrings.totalCost.tr(context),
                          ),
                        ),

                      //! Completed Cost
                      // if (cubit.isCompleted)
                      //   CustomTable(
                      //     title: AppStrings.cost.tr(context),
                      //     child: Column(
                      //       children: [
                      //         ...List.generate(
                      //           3,
                      //           (index) {
                      //             final List<String> titles = [
                      //               AppStrings.estimatedCost.tr(context),
                      //               AppStrings.tips.tr(context),
                      //               AppStrings.promoCode.tr(context),
                      //             ];
                      //             final List<int> values = [130, 10, 10];
                      //             return Padding(
                      //               padding: EdgeInsets.only(
                      //                 bottom: index != 2 ? 12.rH(context) : 0,
                      //               ),
                      //               child: Row(
                      //                 children: [
                      //                   //! Title
                      //                   Text(
                      //                     titles[index],
                      //                     style:
                      //                         Styles.medium14(context).copyWith(
                      //                       color: AppColors.greyText,
                      //                     ),
                      //                   ),
                      //                   const Spacer(),
                      //                   //! Value
                      //                   Text(
                      //                     "${index == 2 ? "-" : ""}${values[index]} ${AppStrings.egp.tr(context)}",
                      //                     style:
                      //                         Styles.semibold14Primary(context)
                      //                             .copyWith(
                      //                       color: Theme.of(context)
                      //                           .textTheme
                      //                           .bodyLarge
                      //                           ?.color,
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             );
                      //           },
                      //         ),
                      //         //! Divider
                      //         Padding(
                      //           padding: EdgeInsets.symmetric(
                      //             vertical: 12.rH(context),
                      //           ),
                      //           child: Divider(
                      //             color: AppColors.greyText.withOpacity(.5),
                      //           ),
                      //         ),
                      //         //! Total
                      //         Row(
                      //           children: [
                      //             CustomSvgPicture(
                      //               svg: Assets.imagesCashPaper,
                      //               height: 22.rH(context),
                      //             ),
                      //             SizedBox(width: 10.rW(context)),
                      //             Text(
                      //               AppStrings.totalCost.tr(context),
                      //               style: Styles.semibold16Primary(context)
                      //                   .copyWith(
                      //                 color: AppColors.greyText,
                      //               ),
                      //             ),
                      //             const Spacer(),
                      //             Text(
                      //               "130 ${AppStrings.egp.tr(context)}",
                      //               style: Styles.semibold20Primary(context)
                      //                   .copyWith(
                      //                 color: AppColors.red,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),

                      //! Promo Code
                      if (!cubit.isCompleted)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.applyPromoCode.tr(context),
                              style: Styles.regular14(context).copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            ),
                            SizedBox(height: 16.rH(context)),
                            const BookingPromoCode(),
                            SizedBox(height: 24.rH(context)),
                          ],
                        ),
                    ],
                  ),
                ),

              SizedBox(height: 16.rH(context)),

              //! Booking Request & Rebook Button
              if ((cubit.isClassic ||
                      (cubit.isScheduled && !cubit.isAccepted)) &&
                  context.read<GlobalCubit>().isRider &&
                  cubit.tripDetails != null)
                CustomButton(
                  onPressed: () {
                    if (cubit.isCompleted) {
                      navigate(context, const StartTripView());
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => const BookingSuccessAlertDialog(),
                      ).whenComplete(() {
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
                      });
                    }
                  },
                  title: cubit.isCompleted
                      ? AppStrings.rebook.tr(context)
                      : AppStrings.bookingRequest.tr(context),
                ),

              //! Pay & Cancel Button (For Rider)
              if (cubit.isAccepted && context.read<GlobalCubit>().isRider)
                Row(
                  children: [
                    //! Cancel Button
                    Expanded(
                      child: CustomButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => const CancelTripAlertDialog(),
                        ).then((value) {
                          if (value == true) {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  const ReasonOfCancelTripAlertDialog(),
                            ).then((value) {
                              if (value == true) {
                                final globalCubit = context.read<GlobalCubit>();
                                globalCubit.scaffoldKey.currentState
                                    ?.closeDrawer();
                                globalCubit.scaffoldKey =
                                    GlobalKey<ScaffoldState>();
                                globalCubit.navBarController.jumpToTab(0);
                                navigateAndRemoveUntil(
                                  context,
                                  context.read<GlobalCubit>().isRider
                                      ? const BaseView()
                                      : const HomeView(),
                                );
                              }
                            });
                          }
                        }),
                        title: AppStrings.cancel.tr(context),
                        color: AppColors.transparent,
                        borderColor: AppColors.red,
                        textColor: AppColors.red,
                      ),
                    ),
                    SizedBox(width: 16.rW(context)),
                    //! Pay Now Button
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          navigate(
                            context,
                            const PaymentMethodsView(
                                // isBooking: true,
                                ),
                          );
                        },
                        title: AppStrings.payNow.tr(context),
                      ),
                    ),
                  ],
                ),

              //! Start & Delete Trip Buttons (For Driver)
              if (cubit.isScheduled && context.read<GlobalCubit>().isDriver)
                Row(
                  children: [
                    //! Delete
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const CancelTripAlertDialog(),
                          ).then((value) {
                            if (value == true) {
                              Navigator.pop(context);
                            }
                          });
                        },
                        title: AppStrings.delete.tr(context),
                        borderColor: AppColors.red,
                        textColor: AppColors.red,
                        color: AppColors.transparent,
                      ),
                    ),
                    SizedBox(width: 16.rW(context)),
                    //! Start
                    Expanded(
                      child: CustomButton(
                        onPressed: () {},
                        title: AppStrings.start.tr(context),
                      ),
                    ),
                  ],
                ),

              SizedBox(height: 24.rH(context)),
            ],
          ),
        );
      },
    );
  }
}
