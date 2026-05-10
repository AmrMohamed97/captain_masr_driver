import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../core/widgets/title_with_background.dart';
import '../../../driver_share_trip/presentation/views/driver_share_trip_view.dart';
import '../../../rider_share_trip/presentation/views/rider_share_trip_view.dart';
import '../../../trips/presentation/widgets/cancel_trip_alert_dialog.dart';
import '../../../trips/presentation/widgets/reason_of_cancel_trip_alert_dialog.dart';
import '../views/schedule_trip_request_view.dart';
import 'schedule_trip_map_section.dart';

class PostedScheduleTripBody extends StatefulWidget {
  const PostedScheduleTripBody({super.key});

  @override
  State<PostedScheduleTripBody> createState() => _PostedScheduleTripBodyState();
}

class _PostedScheduleTripBodyState extends State<PostedScheduleTripBody> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        context.read<ScheduleTripCubit>().update();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleTripCubit, ScheduleTripState>(
      builder: (context, state) {
        final cubit = context.read<ScheduleTripCubit>();

        bool isStartEnabled = false;
        final String? todayStatus = cubit.effectiveTodayStatus;
        if (todayStatus == 'started' || todayStatus == 'start') {
          isStartEnabled = true;
        } else if (todayStatus == 'pending' && cubit.postedTrip?.time != null) {
          // Remove the 'Z' so Dart parses the exact numbers as Local Time
          // without applying any timezone offset (like +02:00)
          final timeString = cubit.postedTrip!.time!.replaceAll('Z', '');
          final tripParsed = DateTime.tryParse(timeString);
          if (tripParsed != null) {
            final now = DateTime.now();
            // Since this is a recurring schedule, we ignore the date in the parsed string
            // and build a timestamp for today using the scheduled time.
            final tripTimeToday = DateTime(
              now.year,
              now.month,
              now.day,
              tripParsed.hour,
              tripParsed.minute,
            );

            final diff = now.difference(tripTimeToday).inMinutes;
            if (diff >= -10 && diff <= 15) {
              isStartEnabled = true;
            }
          }
        }
        print(
            'status=========================================================');
        // print(cubit.realtimeRiderTodayStatus);
        print(cubit.postedTrip!.days);
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.rW(context),
          ),
          child: Column(
            children: [
              //! Header
              CustomAppBar(
                title: AppStrings.scheduleTrip.tr(context),
                trailing: cubit.postedTrip != null
                    ? GestureDetector(
                        onTap: () => navigate(
                          context,
                          BlocProvider.value(
                            value: cubit,
                            child: const ScheduleTripRequestView(),
                          ),
                        ),
                        child: Badge(
                          isLabelVisible: cubit.newRequests.isNotEmpty,
                          smallSize: 12.rH(context),
                          label: Text(
                            cubit.newRequests.length.toString(),
                            style: Styles.medium10white(context),
                          ),
                          child: CircleAvatar(
                            radius: 19.rH(context),
                            backgroundColor: AppColors.primary,
                            child: const CustomSvgPicture(
                              svg: Assets.imagesRequestsFilled,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              SizedBox(height: 26.rH(context)),

              if (cubit.postedTrip != null)
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      //! Map Section
                      ScheduleTripMap(
                        latLng: LatLng(
                          cubit.postedTrip!.pickupLatitude ?? 0,
                          cubit.postedTrip!.pickupLongitude ?? 0,
                        ),
                      ),

                      SizedBox(height: 16.rH(context)),

                      //! Destination
                      TitleWithBackground(
                        title: AppStrings.destination.tr(context),
                      ),

                      SizedBox(height: 16.rH(context)),

                      //! Gatharing & End Point
                      StartAndEndPoint(
                        startValue: cubit.postedTrip!.pickupAddress ?? "???",
                        endValue: cubit.postedTrip!.dropoffAddress ?? "???",
                      ),

                      SizedBox(height: 16.rH(context)),

                      //! Duration
                      TitleWithBackground(
                        title: AppStrings.duration.tr(context),
                      ),

                      SizedBox(height: 16.rH(context)),

                      Row(
                        children: [
                          CustomSvgPicture(
                            svg: Assets.imagesCalender,
                            height: 24.rH(context),
                          ),
                          SizedBox(width: 16.rW(context)),
                          //! Form
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.from.tr(context),
                                  style: Styles.medium14(context).copyWith(
                                    color: AppColors.greyText,
                                  ),
                                ),
                                SizedBox(height: 7.rH(context)),
                                Text(
                                  cubit.postedTrip!.dateFrom != null
                                      ? cubit.postedTrip!.dateFrom!
                                      : cubit.postedTrip!.date != null
                                          ? DateFormat('dd-MM-yyyy').format(
                                              DateTime.parse(
                                                  cubit.postedTrip!.date!))
                                          : '??',
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
                          Container(
                            height: 35.rH(context),
                            margin: EdgeInsets.symmetric(
                                horizontal: 36.rW(context)),
                            width: 1,
                            color: AppColors.greyText,
                          ),
                          //! To
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.to.tr(context),
                                  style: Styles.medium14(context).copyWith(
                                    color: AppColors.greyText,
                                  ),
                                ),
                                SizedBox(height: 7.rH(context)),
                                Text(
                                  cubit.postedTrip!.dateTo != null
                                      ? cubit.postedTrip!.dateTo!
                                      : cubit.postedTrip!.date != null
                                          ? DateFormat('dd-MM-yyyy').format(
                                              DateTime.parse(
                                                  cubit.postedTrip!.date!))
                                          : '??',
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
                          SizedBox(width: 30.rW(context)),
                        ],
                      ),

                      SizedBox(height: 16.rH(context)),

                      Divider(
                        color: AppColors.greyText.withOpacity(.5),
                      ),

                      SizedBox(height: 16.rH(context)),

                      //! Selected Days
                      // Text(
                      //   AppStrings.daysYouWant.tr(context),
                      //   style: Styles.medium16Primary(context).copyWith(
                      //     color: Theme.of(context).textTheme.bodyLarge?.color,
                      //   ),
                      // ),

                      // SizedBox(height: 8.rH(context)),

                      // SizedBox(
                      //   height: 86.rH(context),
                      //   child: ListView.separated(
                      //     padding: EdgeInsets.zero,
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: 7,
                      //     separatorBuilder: (context, index) {
                      //       return SizedBox(width: 12.rW(context));
                      //     },
                      //     itemBuilder: (context, index) {
                      //       return Center(
                      //         child: Container(
                      //           height: 69.rH(context),
                      //           width: 47.rW(context),
                      //           decoration: BoxDecoration(
                      //             color: AppColors.primary.withOpacity(.15),
                      //             borderRadius: BorderRadius.circular(16),
                      //             border: Border.all(
                      //               color: AppColors.primary,
                      //             ),
                      //           ),
                      //           child: Column(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               SizedBox(
                      //                 height: 24.rH(context),
                      //                 child: FittedBox(
                      //                   child: Text(
                      //                     DateTime.now()
                      //                         .add(Duration(days: index))
                      //                         .day
                      //                         .toString(),
                      //                     style:
                      //                         Styles.semibold18Primary(context)
                      //                             .copyWith(
                      //                       color: Theme.of(context)
                      //                           .textTheme
                      //                           .bodyLarge
                      //                           ?.color,
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //               SizedBox(height: 2.rH(context)),
                      //               SizedBox(
                      //                 height: 14.rH(context),
                      //                 child: FittedBox(
                      //                   child: Text(
                      //                     DateFormat('EEE').format(
                      //                         DateTime.now()
                      //                             .add(Duration(days: index))),
                      //                     style:
                      //                         Styles.semibold18Primary(context)
                      //                             .copyWith(
                      //                       color: AppColors.greyText,
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),

                      // SizedBox(height: 16.rH(context)),

                      //! Gathering & Return Time
                      Text(
                        AppStrings.startHour.tr(context),
                        style: Styles.medium16Primary(context).copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),

                      SizedBox(height: 8.rH(context)),

                      Row(
                        children: [
                          Expanded(
                            child: CustomSelectContainer(
                              value: cubit.postedTrip!.time != null
                                  ? DateFormat('hh:mm a').format(
                                      DateTime.parse(cubit.postedTrip!.time!))
                                  : '??',
                              // cubit.postedTrip?.time != null
                              // ? formatTime(
                              //     time: cubit.postedTrip!.time!,
                              //     language:
                              //         context.read<GlobalCubit>().language,
                              //   )
                              //     : "???",
                              svg: Assets.imagesTime,
                              onTap: () {},
                              icon: const SizedBox.shrink(),
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(
                          //       horizontal: 16.rW(context)),
                          //   child: Text(
                          //     AppStrings.to.tr(context),
                          //     style: Styles.semibold16Primary(context).copyWith(
                          //       color: AppColors.greyText,
                          //     ),
                          //   ),
                          // ),
                          // Expanded(
                          //   child: CustomSelectContainer(
                          //     value: "12:27 PM",
                          //     svg: Assets.imagesTime,
                          //     onTap: () {},
                          //   ),
                          // ),
                        ],
                      ),

                      SizedBox(height: 26.rH(context)),

                      //! Available Seats
                      Row(
                        children: [
                          Text(
                            AppStrings.availableSeats.tr(context),
                            style: Styles.medium16Primary(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.rW(context)),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                CustomSvgPicture(
                                  svg: Assets.imagesSeat,
                                  height: 24.rH(context),
                                ),
                                Container(
                                  height: 24.rH(context),
                                  width: 1,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10.rW(context),
                                  ),
                                  color: AppColors.white,
                                ),
                                Text(
                                  cubit.postedTrip!.seatsNeeded?.toString() ??
                                      cubit.postedTrip?.seatsAvailable
                                          ?.toString() ??
                                      cubit.postedTrip!.seatsIds?.length
                                          .toString() ??
                                      "???",
                                  style:
                                      Styles.medium16Primary(context).copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.rH(context)),

                      // CostPerSeatContainer(
                      //   value: 530,
                      // ),

                      SizedBox(height: 36.rH(context)),
                    ],
                  ),
                ),

              SizedBox(height: 13.rH(context)),

              //!  Buttons
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
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  const ReasonOfCancelTripAlertDialog(),
                            ).then((value) {
                              if (value != null && value is List) {
                                cubit.driverCancelAllScheduleTrip(
                                  reason: value[0],
                                  notes: value[1],
                                );
                              }
                            });
                          }
                        });
                      },
                      title: cubit.postedTrip?.status != "pending"
                          ? AppStrings.cancel.tr(context)
                          : AppStrings.delete.tr(context),
                      borderColor: AppColors.red,
                      textColor: AppColors.red,
                      color: AppColors.transparent,
                    ),
                  ),
                  SizedBox(width: 16.rW(context)),
                  context.read<GlobalCubit>().isRider
                      ? Expanded(
                          child: CustomButton(
                            enabled: (cubit.postedTrip!.days == null ||
                                    isTodayInList(cubit.postedTrip!.days!)) &&
                                (cubit.driverStatus == "started" ||
                                    cubit.driverStatus == "start") &&
                                cubit.effectiveTodayStatus != null &&
                                (cubit.effectiveTodayStatus == "accepted" ||
                                    cubit.effectiveTodayStatus ==
                                        "driver_arrived" ||
                                    (cubit.effectiveTodayStatus == "started" ||
                                        cubit.effectiveTodayStatus == "start")),
                            onPressed: () {
                              if (cubit.postedTrip!.days == null
                                  ? true
                                  : isTodayInList(cubit.postedTrip!.days!)) {
                                // print(' ==================');
                                // print(cubit.postedTrip!.id);
                                navigateReplacement(
                                  context,
                                  RiderShareTripView(
                                    tripId: cubit.postedTrip!.id!,
                                  ),
                                );
                              } else {
                                showToast(
                                  context,
                                  message: AppStrings
                                      .todayIsNotWithinTheTripsScheduledDates
                                      .tr(context),
                                  state: ToastStates.info,
                                );
                              }
                            },
                            title: cubit.effectiveTodayStatus == null ||
                                    (cubit.effectiveTodayStatus == "pending" &&
                                        (cubit.postedTrip!.days!.first !=
                                            DateFormat('YYYY-MM-DD')
                                                .format(DateTime.now())))
                                // ||((cubit.postedTrip!.days == null &&
                                //                 cubit.realtimeRiderTodayStatus ==
                                //                     null) ||
                                //             (cubit.postedTrip!.days != null &&
                                //                 isTodayInList(
                                //                     cubit.postedTrip!.days!) &&
                                //                 cubit.realtimeRiderTodayStatus ==
                                //                     null))
                                ? AppStrings.waitingDriverApproval.tr(context)
                                : (cubit.postedTrip!.days != null &&
                                        !isTodayInList(cubit.postedTrip!.days!))
                                    ? AppStrings.notAvailableForToday
                                        .tr(context)
                                    : (cubit.postedTrip!.days == null ||
                                                isTodayInList(
                                                    cubit.postedTrip!.days!)) &&
                                            (cubit.driverStatus == "started" ||
                                                cubit.driverStatus ==
                                                    "start") &&
                                            cubit.effectiveTodayStatus !=
                                                null &&
                                            (cubit.effectiveTodayStatus ==
                                                    "accepted" ||
                                                cubit.effectiveTodayStatus ==
                                                    "driver_arrived" ||
                                                (cubit.effectiveTodayStatus ==
                                                        "started" ||
                                                    cubit.effectiveTodayStatus ==
                                                        "start"))
                                        ? AppStrings.joinTrip.tr(context)
                                        : cubit.effectiveTodayStatus ==
                                                "completed"
                                            ? AppStrings.completed.tr(context)
                                            : (cubit.effectiveTodayStatus ==
                                                        "cancelled" ||
                                                    cubit.effectiveTodayStatus ==
                                                        "canceled")
                                                ? AppStrings.cancelled.tr(context)
                                                : AppStrings.waitingDriverToStartTrip.tr(context),
                            // cubit.effectiveTodayStatus == null
                            //     ? "request pending"
                            //     : cubit.effectiveTodayStatus == "accepted"
                            //         ? "waiting for driver..."
                            //         : cubit.effectiveTodayStatus == "completed"
                            //             ? 'completed'
                            //             : cubit.effectiveTodayStatus ==
                            //                         "cancelled" ||
                            //                     cubit.effectiveTodayStatus ==
                            //                         "canceled"
                            //                 ? "trip cancelled"
                            //                 : "join trip",
                            borderColor: AppColors.primary,
                            textColor: AppColors.primary,
                            color: AppColors.transparent,
                          ),
                        )
                      :
                      //! Start
                      Expanded(
                          child: CustomButton(
                            enabled: isStartEnabled,
                            onPressed: () {
                              // print('==================');
                              // print(cubit.postedTrip!.days);
                              // print('==================');
                              // cubit.postedTrip!.driverPhone
                              // cubit.postedTrip!.driverPhoneCode
                              // cubit.postedTrip!.id
                              // navigateReplacement(
                              //   context,
                              //   RiderShareTripView(
                              //     driverId: cubit.postedTrip!.driverId!,
                              //     dropoffLatitude: cubit.postedTrip!.dropoffLatitude!,
                              //     dropoffLongitude:
                              //         cubit.postedTrip!.dropoffLongitude!,
                              //     pickupLatitude: cubit.postedTrip!.pickupLatitude!,
                              //     pickupLongitude: cubit.postedTrip!.pickupLongitude!,
                              //   ),
                              // );
                              // print('=======');
                              // print(cubit.postedTrip?.time);
                              // print(cubit.postedTrip?.todayStatus);
                              // print(cubit.postedTrip?.id);

                              if (context.read<GlobalCubit>().isDriver &&
                                  cubit.effectiveTodayStatus == "pending") {
                                cubit.driverStartScheduleTrip();
                              } else if (context.read<GlobalCubit>().isRider &&
                                  cubit.effectiveTodayStatus == "pending") {
                                if (isTodayInList(cubit.postedTrip!.days!)) {
                                  showToast(
                                    context,
                                    message: AppStrings
                                        .waitingDriverToStartScheduledTrip
                                        .tr(context),
                                    state: ToastStates.info,
                                  );
                                } else {
                                  showToast(
                                    context,
                                    message: AppStrings
                                        .todayIsNotWithinTheTripsScheduledDates
                                        .tr(context),
                                    state: ToastStates.info,
                                  );
                                }
                              } else if (context.read<GlobalCubit>().isDriver &&
                                  (cubit.effectiveTodayStatus == "started" ||
                                      cubit.effectiveTodayStatus == "start")) {
                                navigateReplacement(
                                  context,
                                  DriverShareTripView(
                                    tripId: cubit.postedTrip!.id!,
                                    // isOnMyWay: true,
                                    // isShareTrip: true,
                                  ),
                                );
                              } else if (context.read<GlobalCubit>().isRider &&
                                  (cubit.effectiveTodayStatus == "started" ||
                                      cubit.effectiveTodayStatus == "start")) {
                                if (cubit.postedTrip!.days == null
                                    ? true
                                    : cubit.postedTrip!.days == null
                                        ? true
                                        : isTodayInList(
                                            cubit.postedTrip!.days!)) {
                                  // print(' ==================');
                                  // print(cubit.postedTrip!.id);
                                  navigateReplacement(
                                    context,
                                    RiderShareTripView(
                                      tripId: cubit.postedTrip!.id!,
                                    ),
                                    // RiderTripView(
                                    //   tripId: cubit.postedTrip!.id!,
                                    //   isShareRide: true,
                                    // ),

                                    // RiderShareTripView(
                                    //   driverId: cubit.postedTrip!.driverId!,
                                    //   dropoffLatitude:
                                    //       cubit.postedTrip!.dropoffLatitude!,
                                    //   dropoffLongitude:
                                    //       cubit.postedTrip!.dropoffLongitude!,
                                    //   pickupLatitude:
                                    //       cubit.postedTrip!.pickupLatitude!,
                                    //   pickupLongitude:
                                    //       cubit.postedTrip!.pickupLongitude!,
                                    //   tripDetails: cubit.postedTrip!,
                                    // ),
                                  );
                                } else {
                                  showToast(
                                    context,
                                    message: AppStrings
                                        .todayIsNotWithinTheTripsScheduledDates
                                        .tr(context),
                                    state: ToastStates.info,
                                  );
                                }
                              }
                            },
                            title: cubit.effectiveTodayStatus == "pending"
                                ? AppStrings.start.tr(context)
                                : (cubit.effectiveTodayStatus == "started" ||
                                        cubit.effectiveTodayStatus == "start")
                                    ? AppStrings.continueTrip.tr(context)
                                    : AppStrings.completed.tr(context),
                          ),
                        ),
                ],
              ),

              SizedBox(height: 26.rH(context)),
            ],
          ),
        );
      },
    );
  }

  bool isTodayInList(List<String> dates) {
    // فورمات التاريخ
    final formatter = DateFormat('yyyy-MM-dd');

    // تاريخ اليوم بنفس الفورمات
    final String today = formatter.format(DateTime.now());

    // check لو موجود
    return dates.contains(today);
  }
}
