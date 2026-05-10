import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_bottom_dragable_container.dart';
import '../../../trip_details/presentation/views/cashed_images.dart';
import '../../../trips/presentation/widgets/cancel_trip_alert_dialog.dart';
import '../../../trips/presentation/widgets/reason_of_cancel_trip_alert_dialog.dart';
import '../cubit/driver_trip_cubit.dart';
import 'arrival_down_time_timer.dart';
import 'down_time_timer.dart';
import 'driver_trip_frist_container_content.dart';
import 'driver_trip_on_my_way_riders_and_driver.dart';
import 'driver_trip_riders_and_cost_row.dart';

class DriverTripBottomSection extends StatefulWidget {
  const DriverTripBottomSection({
    super.key,
    // required this.driverId,
    // required this.dropoffLat,
    // required this.dropoffLng,
  });
  // final int? driverId;
  // final double dropoffLat;
  // final double dropoffLng;
  @override
  State<DriverTripBottomSection> createState() =>
      _DriverTripBottomSectionState();
}

class _DriverTripBottomSectionState extends State<DriverTripBottomSection> {
  // int? arrivalTime;

  // @override
  // void initState() {
  //   super.initState();
  //   // Check initially in case tripDetails is already loaded
  //   if (widget.driverId != null) {
  //     MapsHelper.getArrivalTime(
  //       dropoffLat: widget.dropoffLat,
  //       dropoffLng: widget.dropoffLng,
  //       driverId: widget.driverId!,
  //     ).then((mints) {
  //       if (mints != null && mounted) {
  //         setState(() {
  //           arrivalTime = mints;
  //         });
  //       }
  //     });
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverTripCubit, DriverTripState>(
      builder: (context, state) {
        final cubit = context.read<DriverTripCubit>();

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
                        if (cubit.isShareTrip &&
                            cubit.riders.length > 1 &&
                            !cubit.isOnMyWay)
                          const DriverTripRidersAndCostRow(),

                        //! Driver & Riders
                        if (cubit.isOnMyWay)
                          const DriverTripOnMyWayRidersAndDriver(),

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
                          child: cubit.isOnMyWay && cubit.isDriverSelected
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
                                              // Text(
                                              //   cubit.formatDuration(),
                                              //   style: Styles.medium15(context)
                                              //       .copyWith(
                                              //     color: Theme.of(context)
                                              //         .textTheme
                                              //         .bodyLarge
                                              //         ?.color,
                                              //   ),
                                              // ),
                                              FutureBuilder<DataSnapshot>(
                                                future: FirebaseDatabase
                                                    .instance
                                                    .ref()
                                                    .child(
                                                        'driver_locations/${cubit.tripDetails!.driverId}')
                                                    .get(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData &&
                                                      snapshot.data!.value !=
                                                          null) {
                                                    final data =
                                                        snapshot.data!.value
                                                            as Map<dynamic,
                                                                dynamic>;
                                                    final lat = double.tryParse(
                                                            data['latitude']
                                                                .toString()) ??
                                                        0.0;
                                                    final lng = double.tryParse(
                                                            data['longitude']
                                                                .toString()) ??
                                                        0.0;

                                                    return ArrivalDownTimeTimer(
                                                      origin: LatLng(lat, lng),
                                                      destination: LatLng(
                                                        double.parse(cubit
                                                            .tripDetails!
                                                            .dropoffLatitude
                                                            .toString()),
                                                        double.parse(cubit
                                                            .tripDetails!
                                                            .dropoffLongitude
                                                            .toString()),
                                                      ),
                                                    );
                                                  }
                                                  return DownTimeTimer(
                                                      timeMinutes: cubit
                                                          .tripDetails!
                                                          .timeMinutes!);
                                                },
                                              )
                                            ],
                                          ),

                                          //! Distance Bar
                                          if (cubit.isTripStarted)
                                            CarMovementView(
                                              dropoffLat: double.parse(cubit
                                                  .tripDetails!.dropoffLatitude
                                                  .toString()),
                                              dropoffLng: double.parse(cubit
                                                  .tripDetails!.dropoffLongitude
                                                  .toString()),
                                              driverId:
                                                  cubit.tripDetails!.driverId!,
                                            )
                                          // SizedBox(
                                          //   height: 30.rH(context),
                                          //   width: 295.rW(context),
                                          //   child: Stack(
                                          //     alignment: Alignment.center,
                                          //     children: [
                                          //       LinearProgressIndicator(
                                          //         value: cubit
                                          //             .calculateRemainingDistanceValue(),
                                          //         minHeight: 8.rH(context),
                                          //         semanticsValue:
                                          //             cubit.remainingDistance,
                                          //         semanticsLabel:
                                          //             cubit.remainingDistance,
                                          //         valueColor:
                                          //             const AlwaysStoppedAnimation(
                                          //                 AppColors.primary),
                                          //         backgroundColor:
                                          //             AppColors.grey,
                                          //         borderRadius:
                                          //             BorderRadius.circular(
                                          //                 6),
                                          //       ),
                                          //       AnimatedPositionedDirectional(
                                          //         duration: const Duration(
                                          //             milliseconds: 300),
                                          //         start: (cubit
                                          //                 .calculateRemainingDistanceValue() *
                                          //             (295.rW(context) -
                                          //                 22.rW(context))),
                                          //         child: Column(
                                          //           children: [
                                          //             CircleAvatar(
                                          //               radius:
                                          //                   11.rH(context),
                                          //               backgroundColor:
                                          //                   AppColors.grey,
                                          //               child: CircleAvatar(
                                          //                 radius:
                                          //                     10.rH(context),
                                          //                 backgroundColor:
                                          //                     AppColors
                                          //                         .primary,
                                          //                 child: CircleAvatar(
                                          //                   radius:
                                          //                       9.rH(context),
                                          //                   backgroundColor:
                                          //                       AppColors
                                          //                           .primary,
                                          //                   child:
                                          //                       const CustomSvgPicture(
                                          //                     svg: Assets
                                          //                         .imagesSliderCar,
                                          //                   ),
                                          //                 ),
                                          //               ),
                                          //             ),
                                          //           ],
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
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
                                                    cubit.cancelShareTrip(
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
                              : const DriverTripFirstContainerContent(),
                        ),
//this second container is for the trip details like distance and duration and start and end point and the cost if exist=+> for all trips
                        //! Second Container
                        Container(
                          width: double.infinity,
                          height: cubit.isDeliveryTrip ? 410.rH(context) : null,
                          padding: EdgeInsets.symmetric(
                            vertical: 20.rH(context),
                            horizontal: 18.rW(context),
                          ),
                          margin: EdgeInsets.only(bottom: 16.rH(context)),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //! Distance & Duration
                                DistanceAndDuration(
                                  distance: cubit.tripDetails!.distanceKm
                                          ?.toString() ??
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //! Divider
                                      CustomDivider(space: 16.rH(context)),
                                      //! Package Details
                                      Row(
                                        children: [
                                          //! Type of Shipment
                                          if (cubit.tripDetails!.deliverItem !=
                                              null)
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    AppStrings.typeOfShipment
                                                        .tr(context),
                                                    style: Styles.medium14(
                                                            context)
                                                        .copyWith(
                                                            // color: AppColors.greyText,
                                                            ),
                                                  ),
                                                  SizedBox(
                                                      height: 8.rH(context)),
                                                  Row(
                                                    children: [
                                                      CustomSvgPicture(
                                                        svg: Assets
                                                            .imagesPackage,
                                                        height: 16.rH(context),
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              12.rH(context)),
                                                      Text(
                                                        cubit.tripDetails!
                                                                .deliverItem ??
                                                            "??",
                                                        style: Styles.medium14(
                                                                context)
                                                            .copyWith(
                                                          color: AppColors
                                                              .greyText,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (cubit.tripDetails!.deliverType !=
                                                  null &&
                                              cubit.tripDetails!
                                                      .deliverItemSize !=
                                                  null)
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
                                          if (cubit.tripDetails!
                                                  .deliverItemSize !=
                                              null)
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    AppStrings.sizeOfShipment
                                                        .tr(context),
                                                    style: Styles.medium14(
                                                            context)
                                                        .copyWith(
                                                            // color: AppColors.greyText,
                                                            ),
                                                  ),
                                                  SizedBox(
                                                      height: 8.rH(context)),
                                                  Text(
                                                    cubit.tripDetails!
                                                            .deliverItemSize ??
                                                        "??",
                                                    style:
                                                        Styles.medium14(context)
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
                                          cubit
                                              .tripDetails!.notes!.isNotEmpty &&
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
                                                      // color: AppColors.greyText,
                                                      ),
                                            ),
                                            SizedBox(height: 10.rH(context)),
                                            // CustomSelectContainer(
                                            //   value: cubit.tripDetails!.notes,
                                            //   onTap: () {},
                                            //   borderColor:
                                            //       AppColors.transparent,
                                            //   icon: Container(),
                                            //   fillColor: AppColors.grey
                                            //       .withOpacity(.25),
                                            // ),
                                            Text(
                                              cubit.tripDetails!.notes!,
                                              style: Styles.medium12(context)
                                                  .copyWith(
                                                color: AppColors.greyText,
                                              ),
                                              maxLines: 310,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      SizedBox(height: 16.rH(context)),

                                      //! Image of the package
                                      if (cubit.tripDetails!.deliveryImage !=
                                              null &&
                                          cubit.tripDetails!.deliveryImage!
                                              .isNotEmpty &&
                                          cubit.tripDetails!.deliveryImage !=
                                              " ")
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              AppStrings.deliveryImage
                                                  .tr(context),
                                              style: Styles.medium14(context)
                                                  .copyWith(
                                                color: AppColors.greyText,
                                              ),
                                            ),
                                            SizedBox(height: 10.rH(context)),
                                            CachedImage(
                                              width: 70,
                                              height: 60,
                                              radius: 4,
                                              url: cubit
                                                  .tripDetails!.deliveryImage!,
                                              showImageOnTap: true,
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
