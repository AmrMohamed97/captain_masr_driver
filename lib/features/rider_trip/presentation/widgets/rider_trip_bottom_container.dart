import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_bottom_dragable_container.dart';
import '../../../../core/widgets/partial_star.dart';
import '../../../chat/presentation/views/chat_view.dart';
import '../../../driver_trip/presentation/widgets/arrival_down_time_timer.dart';
// import '../../../driver_trip/presentation/widgets/car_movement_view.dart';
import '../../../driver_trip/presentation/widgets/driver_trip_frist_container_content.dart';
import '../../../driver_trip/presentation/widgets/up_time_timer.dart';
import '../../../preferences/presentation/widgets/preferences_alert_dialog.dart';
import '../../../trips/presentation/widgets/cancel_trip_alert_dialog.dart';
import '../../../trips/presentation/widgets/reason_of_cancel_trip_alert_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import '../cubit/rider_trip_cubit.dart';

class RiderTripBottomContainer extends StatelessWidget {
  const RiderTripBottomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiderTripCubit, RiderTripState>(
      buildWhen: (previous, current) {
        return true;
      },
      builder: (context, state) {
        final cubit = context.read<RiderTripCubit>();
        return cubit.tripDetails != null
            ? CustomBottomDragableContainer(
                startExpanded: false,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    //! Drag Handler
                    Center(
                      child: Container(
                        width: 74.rW(context),
                        height: 4.rH(context),
                        margin: EdgeInsets.symmetric(vertical: 11.rH(context)),
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                        ),
                      ),
                    ),

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
                      child: Column(
                        children: [
                          //! Title
                          Text(
                            AppStrings.yourTrip.tr(context),
                            style: Styles.semibold16Primary(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          SizedBox(height: 8.rH(context)),
                          //! Driver, Contact
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 23.rH(context),
                                backgroundColor: AppColors.transparent,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    cubit.tripDetails!.driverImage ?? "",
                                    height: 46.rH(context),
                                    width: 46.rH(context),
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            SvgPicture.asset(
                                      Assets.imagesPersonSvg,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 9.rW(context)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //! Name
                                    Text(
                                      cubit.tripDetails!.driverName ?? "",
                                      style: Styles.semibold14Primary(context)
                                          .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color,
                                      ),
                                    ),
                                    SizedBox(height: 2.rH(context)),
                                    //! Rate
                                    Row(
                                      children: [
                                        SinglePartialStar(
                                          value: cubit.tripDetails!.driverRating
                                                  ?.toDouble() ??
                                              0,
                                          starSize: 16.rH(context),
                                        ),
                                        SizedBox(width: 5.rW(context)),
                                        Text(
                                          cubit.tripDetails!.driverRating
                                                  ?.toString() ??
                                              "0.0",
                                          style: Styles.regular12(context)
                                              .copyWith(
                                            color: AppColors.greyText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              //! Chat
                              CustomCricleButton(
                                svg: Assets.imagesChat,
                                onTap: () {
                                  navigate(
                                    context,
                                    ChatView(
                                      chatId: cubit.tripDetails!.id!,
                                      senderId: cubit.tripDetails!.riderId!,
                                      receiverId: cubit.tripDetails!.driverId!,
                                      senderName: cubit.tripDetails!.riderName!,
                                      receiverName: cubit.tripDetails!.driverName!,
                                      receiverImage: cubit.tripDetails!.driverImage??'',
                                      resolvedRequestType: cubit.tripDetails!.tripType ?? 'classic',
                                    ),
                                  );
                                },
                                color: AppColors.green.withOpacity(.15),
                              ),
                              SizedBox(width: 8.rW(context)),
                              //! Phone
                              CustomCricleButton(
                                svg: Assets.imagesPhoneCall,
                                onTap: () {
                                  context.read<GlobalCubit>().phoneLinkLauncher(
                                      ((cubit.tripDetails!.driverPhoneCode ??
                                                  "") +
                                              (cubit.tripDetails!.driverPhone ??
                                                  ""))
                                          .toString());
                                },
                                color: AppColors.red.withOpacity(.15),
                              ),
                            ],
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
                          //! Car Type & Cost
                          Row(
                            children: [
                              //! Car Image
                              Image.asset(
                                cubit.isDelivery
                                    ? Assets.imagesDeliveryTripCard
                                    : Assets.imagesTestCar1,
                                height: 27.rH(context),
                              ),
                              SizedBox(width: 11.rW(context)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //! Vehicle Brand & Model
                                    Text(
                                      "${cubit.tripDetails!.vehicleBrand ?? ""} ${cubit.tripDetails!.vehicleModel ?? ""}",
                                      style:
                                          Styles.semibold12(context).copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color,
                                      ),
                                    ),
                                    SizedBox(height: 1.rH(context)),
                                    //! Vehicle Color & Plate
                                    Text(
                                      "${cubit.tripDetails!.vehicleColor ?? ""} - ${cubit.tripDetails!.vehiclePlats ?? ""}",
                                      style: Styles.regular12(context).copyWith(
                                        color: AppColors.greyText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //! Cost
                              Text(
                                "${cubit.tripDetails!.price ?? "??"} ${AppStrings.egp.tr(context)}",
                                style:
                                    Styles.semibold20Primary(context).copyWith(
                                  color: AppColors.red,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 18.rH(context)),
                          //! Arrive In
                          Row(
                            children: [
                              //! Title
                              Text(
                                cubit.isTripStarted
                                    ? AppStrings.tripStarted.tr(context)
                                    : cubit.isDriverWaiting
                                        ? AppStrings.imWatingYou.tr(context)
                                        : AppStrings.arrivesIn.tr(context),
                                style: Styles.regular16(context).copyWith(
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
                              cubit.isTripStarted
                                  ? FutureBuilder<DataSnapshot>(
                                      future: FirebaseDatabase.instance
                                          .ref()
                                          .child(
                                              'driver_locations/${cubit.tripDetails!.driverId}')
                                          .get(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data!.value != null) {
                                          final data = snapshot.data!.value
                                              as Map<dynamic, dynamic>;
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
                                                  .tripDetails!.dropoffLatitude
                                                  .toString()),
                                              double.parse(cubit
                                                  .tripDetails!.dropoffLongitude
                                                  .toString()),
                                            ),
                                          );
                                        }
                                        return SizedBox(
                                          height: 15.rH(context),
                                          width: 15.rH(context),
                                          child:
                                              const CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        );
                                      },
                                    )
                                  : cubit.isDriverWaiting
                                      ? UpTimeTimer(
                                          arrivedTime:
                                              cubit.tripDetails!.arrivedAt !=
                                                      null
                                                  ? DateTime.parse(cubit
                                                          .tripDetails!
                                                          .arrivedAt!)
                                                      .toLocal()
                                                  : DateTime.now(),
                                        )
                                      : cubit.tripDetails!.driverId != null
                                          ? FutureBuilder<DataSnapshot>(
                                              future: FirebaseDatabase.instance
                                                  .ref()
                                                  .child(
                                                      'driver_locations/${cubit.tripDetails!.driverId}')
                                                  .get(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData &&
                                                    snapshot.data!.value !=
                                                        null) {
                                                  final data = snapshot
                                                          .data!.value
                                                      as Map<dynamic, dynamic>;
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
                                                          .pickupLatitude
                                                          .toString()),
                                                      double.parse(cubit
                                                          .tripDetails!
                                                          .pickupLongitude
                                                          .toString()),
                                                    ),
                                                  );
                                                }
                                                return SizedBox(
                                                  height: 15.rH(context),
                                                  width: 15.rH(context),
                                                  child:
                                                      const CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  ),
                                                );
                                              },
                                            )
                                          : Text(
                                              cubit.formatDuration(),
                                              style: Styles.medium15(context)
                                                  .copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.color,
                                              ),
                                            ),
                            ],
                          ),
                          SizedBox(height: 8.rH(context)),
                          //! Time Bar
                          if (!cubit.isDriverWaiting && !cubit.isTripStarted)
                            LinearProgressIndicator(
                              value: cubit.calculateRemainigArrivalTimeValue(),
                              minHeight: 8.rH(context),
                              valueColor:
                                  const AlwaysStoppedAnimation(AppColors.grey),
                              backgroundColor: AppColors.grey,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          //! Distance Bar
                          if (cubit.isTripStarted)
                            // CarMovementView(
                            //   startTimeMinutes:
                            //       cubit.tripDetails!.timeMinutes ?? 0,
                            // ),
                            CarMovementView(
                              dropoffLat: double.parse(cubit
                                  .tripDetails!.dropoffLatitude
                                  .toString()),
                              dropoffLng: double.parse(cubit
                                  .tripDetails!.dropoffLongitude
                                  .toString()),
                              driverId: cubit.tripDetails!.driverId!,
                            ),
                          // if (!cubit.isTripStarted)
                          SizedBox(height: 18.rH(context)),
                          //! Cancel Trip
                          // if (!cubit.isTripStarted)
                          CustomButton(
                            onPressed: () async {
                              final bool? value = await showDialog(
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
                                  if (value != null && value is List) {
                                    cubit.cancelTrip(
                                      cancelReasons: value[0],
                                      notes: value[1],
                                    );
                                  }
                                });
                              }
                            },
                            title: AppStrings.cancelTrip.tr(context),
                            color: AppColors.transparent,
                            textColor: AppColors.red,
                            borderColor: AppColors.red,
                            height: 46.rH(context),
                          ),
                          //! Trip Code
                          if (!cubit.isTripStarted)
                            Padding(
                              padding: EdgeInsets.only(top: 18.rH(context)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //! Trip Code
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${AppStrings.tripCode.tr(context)}:",
                                        style:
                                            Styles.regular16(context).copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.color,
                                        ),
                                      ),
                                      SizedBox(width: 9.rW(context)),
                                      Text(
                                        cubit.tripDetails?.tripCode
                                                ?.toString() ??
                                            "??",
                                        style: Styles.bold16(context).copyWith(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.rH(context)),
                                  //! Hint
                                  Text(
                                    AppStrings
                                        .shareThisCodeWithYourDriverWhenTheyArive
                                        .tr(context),
                                    style: Styles.regular14(context).copyWith(
                                      color: AppColors.greyText,
                                    ),
                                    overflow: TextOverflow.clip,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    //! Second Container
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 20.rH(context),
                        horizontal: 18.rW(context),
                      ),
                      margin: EdgeInsets.only(bottom: 10.rH(context)),
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
                                    "??",
                            duration:
                                cubit.tripDetails!.timeMinutes?.toString() ??
                                    "??",
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
                                cubit.tripDetails!.pickupAddress ?? "??",
                            endValue: cubit.tripDetails!.dropoffAddress ?? "??",
                          ),
                          SizedBox(height: 12.rH(context)),
                          //! Prefernces
                          if (!cubit.isDelivery)
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          PreferencesAlertDialog(
                                        canEdit: false,
                                        preferencesModel:
                                            cubit.tripDetails?.preferences,
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      CustomSvgPicture(
                                        svg: Assets.imagesPreferences,
                                        height: 24.rH(context),
                                      ),
                                      SizedBox(width: 6.rW(context)),
                                      Text(
                                        AppStrings.preferences.tr(context),
                                        style:
                                            Styles.regular14(context).copyWith(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container();
      },
    );
  }
}
