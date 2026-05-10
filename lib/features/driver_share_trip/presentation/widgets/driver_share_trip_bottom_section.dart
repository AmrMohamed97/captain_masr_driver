import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_bottom_dragable_container.dart';
import '../../../trips/presentation/widgets/cancel_trip_alert_dialog.dart';
import '../../../trips/presentation/widgets/reason_of_cancel_trip_alert_dialog.dart';
import '../cubit/driver_share_trip_cubit.dart';
import 'arrival_share_down_time_timer.dart';
import 'down_time_timer_share.dart';
import 'driver_share_trip_frist_container_content.dart';

class DriverShareTripBottomSection extends StatefulWidget {
  final int tripId;
  const DriverShareTripBottomSection({
    super.key,
    required this.tripId,
  });
  @override
  State<DriverShareTripBottomSection> createState() =>
      _DriverShareTripBottomSectionState();
}

class _DriverShareTripBottomSectionState
    extends State<DriverShareTripBottomSection> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverShareTripCubit, DriverShareTripState>(
      builder: (context, state) {
        final cubit = context.read<DriverShareTripCubit>();

        return cubit.tripDetails != null
            ? CustomBottomDragableContainer(
                startExpanded: false,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    //! Drag Handler
                    Center(
                      child: Container(
                        width: 74.rW(context),
                        height: 4.rH(context),
                        margin: EdgeInsets.symmetric(vertical: 11.rH(context)),
                        decoration: const BoxDecoration(
                          color: AppColors.greyText,
                        ),
                      ),
                    ),

                    //! Content
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //! Riders (if more 1)
                        // if (!cubit.isDriverSelected)
                        // const DriverShareTripRidersAndCostRow(),

                        //! First Container
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.rW(context),
                            vertical: 17.rH(context),
                          ),
                          margin: EdgeInsets.only(bottom: 10.rH(context)),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: cubit.isDriverSelected
                              ? Column(
                                  children: [
                                    //! Title
                                    Text(
                                      AppStrings.you.tr(context),
                                      style: Styles.semibold16Primary(context)
                                          .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.symmetric(
                                        vertical: 18.rH(context),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8.rH(context),
                                        horizontal: 8.rW(context),
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.grey.withOpacity(.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          //! Arrive In
                                          Row(
                                            children: [
                                              //! Title
                                              Text(
                                                AppStrings.tripStarted
                                                    .tr(context),
                                                style: Styles.regular16(context)
                                                    .copyWith(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.color,
                                                ),
                                              ),
                                              const Spacer(),
                                              CustomSvgPicture(
                                                svg: Assets.imagesTime,
                                                height: 15.rH(context),
                                              ),
                                              SizedBox(width: 8.rW(context)),

                                              //timer for driver to arrive to the end of share trip
                                              if (cubit.travelTimeSeconds !=
                                                  null)
                                                ArrivalShareDownTimeTimer(
                                                  initialSeconds:
                                                      cubit.travelTimeSeconds!,
                                                )
                                              else
                                                DownTimeTimerShare(
                                                  timeMinutes: cubit
                                                      .tripDetails!
                                                      .timeMinutes!,
                                                ),
                                            ],
                                          ),
                                          //car movment bar
                                          //! Distance Bar
                                          CarMovementViewShare(
                                            initialSeconds:
                                                (cubit.travelTimeSeconds ??
                                                        (cubit.tripDetails!
                                                                .timeMinutes! *
                                                            60))
                                                    .toInt(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //cancel and complete share trip buttons for driver
                                    //! Buttons
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomButton(
                                            onPressed: () async {
                                              final bool? value =
                                                  await showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    const CancelTripAlertDialog(),
                                              );
                                              if (value == true) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      const ReasonOfCancelTripAlertDialog(),
                                                ).then((value) {
                                                  if (value != null &&
                                                      value is List) {
                                                    cubit.cancelAllScheduleTrip(
                                                      cancelReasons: value[0],
                                                      notes: value[1],
                                                    );
                                                  }
                                                });
                                              }
                                            },
                                            title:
                                                AppStrings.cancel.tr(context),
                                            borderColor: AppColors.red,
                                            textColor: AppColors.red,
                                            color: AppColors.transparent,
                                          ),
                                        ),
                                        SizedBox(width: 16.rW(context)),
                                        Expanded(
                                          child: CustomButton(
                                            onPressed: () {
                                              cubit.completeShareTrip();
                                              // showDialog(
                                              //   context: context,
                                              //   barrierDismissible: false,
                                              //   builder: (context) =>
                                              //       const OnMyWayArrivedAlertDialog(),
                                              // );
                                            },
                                            title:
                                                AppStrings.arrived.tr(context),
                                            // enabled: cubit
                                            //             .remainingDistanceNum !=
                                            //         null &&
                                            //     cubit.remainingDistanceNum! <
                                            //         (100 / 1000),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              :   DriverShareTripFirstContainerContent(tripId: widget.tripId,),
                        ),
//this second container is for the trip details like distance and duration and start and end point and the cost if exist=+> for all trips
                        //! Second Container
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 20.rH(context),
                            horizontal: 18.rW(context),
                          ),
                          margin: EdgeInsets.only(bottom: 16.rH(context)),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //! Distance & Duration
                              DistanceAndDuration(
                                distance:
                                    cubit.tripDetails!.distanceKm?.toString() ??
                                        "",
                                duration: cubit.tripDetails!.timeMinutes
                                        ?.toString() ??
                                    "",
                              ),
                              //! Divider
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.rH(context),
                                ),
                                child: Divider(
                                  color: AppColors.greyText.withOpacity(.5),
                                ),
                              ),
                              //! Start & End Point
                              StartAndEndPoint(
                                startValue:
                                    cubit.tripDetails!.pickupAddress ?? "",
                                endValue:
                                    cubit.tripDetails!.dropoffAddress ?? "",
                              ),
                              //! Dlivery Details
                              if (cubit.isDeliveryTrip)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //! Divider
                                    CustomDivider(space: 16.rH(context)),
                                    //! Package Details
                                    Row(
                                      children: [
                                        //! Type of Shipment
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                AppStrings.typeOfShipment
                                                    .tr(context),
                                                style: Styles.medium14(context)
                                                    .copyWith(
                                                  color: AppColors.greyText,
                                                ),
                                              ),
                                              SizedBox(height: 8.rH(context)),
                                              Row(
                                                children: [
                                                  CustomSvgPicture(
                                                    svg: Assets.imagesPackage,
                                                    height: 16.rH(context),
                                                  ),
                                                  SizedBox(
                                                      width: 12.rH(context)),
                                                  Text(
                                                    cubit.tripDetails!
                                                            .deliverType ??
                                                        "??",
                                                    style:
                                                        Styles.medium14(context)
                                                            .copyWith(
                                                      color: AppColors.greyText,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 1,
                                          height: 34.rH(context),
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 16.rW(context),
                                          ),
                                          color: AppColors.greyText
                                              .withOpacity(.5),
                                        ),
                                        //! Size of Shipment
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                AppStrings.sizeOfShipment
                                                    .tr(context),
                                                style: Styles.medium14(context)
                                                    .copyWith(
                                                  color: AppColors.greyText,
                                                ),
                                              ),
                                              SizedBox(height: 8.rH(context)),
                                              Text(
                                                cubit.tripDetails!
                                                        .deliverItemSize ??
                                                    "??",
                                                style: Styles.medium14(context)
                                                    .copyWith(
                                                  color: AppColors.greyText,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16.rH(context)),
                                    //! Additional Note
                                    if (cubit.tripDetails!.notes != null &&
                                        cubit.tripDetails!.notes!.isNotEmpty &&
                                        cubit.tripDetails!.notes != " ")
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppStrings.additionNotes
                                                .tr(context),
                                            style: Styles.medium14(context)
                                                .copyWith(
                                              color: AppColors.greyText,
                                            ),
                                          ),
                                          SizedBox(height: 10.rH(context)),
                                          CustomSelectContainer(
                                            value: cubit.tripDetails!.notes,
                                            onTap: () {},
                                            borderColor: AppColors.transparent,
                                            icon: Container(),
                                            fillColor:
                                                AppColors.grey.withOpacity(.25),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              //! Cost
                              if (cubit.tripDetails!.price != null &&
                                  cubit.tripDetails!.price! > 0)
                                CostRow(
                                  cost: cubit.tripDetails!.price?.toDouble(),
                                  color: AppColors.transparent,
                                  title: AppStrings.cost.tr(context),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Container();
      },
    );
  }
}
