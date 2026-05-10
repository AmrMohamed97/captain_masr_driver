import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/imports/imports.dart';
import '../../../chat/presentation/views/chat_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../cubit/driver_trip_cubit.dart';
import 'arrival_down_time_timer.dart';
import 'down_time_timer.dart';
import 'driver_trip_buttons.dart';
import 'prefernces_items_wrap.dart';
import 'up_time_timer.dart';

class DriverTripFirstContainerContent extends StatefulWidget {
  const DriverTripFirstContainerContent({
    super.key,
    // required this.driverId,
    // required this.dropoffLat,
    // required this.dropoffLng,
    // required this.isTripStarted,
  });
  // final int? driverId;
  // final double dropoffLat;
  // final double dropoffLng;
  // final bool isTripStarted;
  @override
  State<DriverTripFirstContainerContent> createState() =>
      _DriverTripFirstContainerContentState();
}

class _DriverTripFirstContainerContentState
    extends State<DriverTripFirstContainerContent> {
  // int? arrivalTime;
  // @override
  // void initState() {
  //   super.initState();
  //   // startTimer();
  // }

  // void startTimer() {
  //   if (widget.isTripStarted) {
  //     // Check initially in case tripDetails is already loaded
  //     if (widget.driverId != null) {
  //       MapsHelper.getArrivalTime(
  //         dropoffLat: widget.dropoffLat,
  //         dropoffLng: widget.dropoffLng,
  //         driverId: widget.driverId!,
  //       ).then((mints) {
  //         if (mints != null && mounted) {
  //           setState(() {
  //             arrivalTime = mints;
  //           });
  //         }
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverTripCubit, DriverTripState>(
      builder: (context, state) {
        final cubit = context.read<DriverTripCubit>();
        return Column(
          children: [
            //! Title
            Text(
              AppStrings.yourTrip.tr(context),
              style: Styles.semibold16Primary(context).copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            SizedBox(height: 8.rH(context)),
            //! Rider Details, Contact
            Row(
              children: [
                CircleAvatar(
                  radius: 23.rH(context),
                  backgroundColor: AppColors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      cubit.tripDetails!.riderImage ?? "",
                      width: 46.rH(context),
                      height: 46.rH(context),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
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
                        cubit.tripDetails!.riderName ?? "",
                        style: Styles.semibold14Primary(context).copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      SizedBox(height: 2.rH(context)),
                      //! Preferences
                      if (!cubit.isDeliveryTrip &&
                          cubit.tripDetails?.preferences != null)
                        PreferencesItemsWrap(
                          preferences: cubit.tripDetails!.preferences!,
                        ),
                      //! Sending Or Recieving
                      if (cubit.isDeliveryTrip)
                        SendingOrRecievingRow(
                          sending: cubit.tripDetails!.deliverType == 'sending',
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
                        senderId: cubit.tripDetails!.driverId!,
                        receiverId: cubit.tripDetails!.riderId!,
                        senderName: cubit.tripDetails!.driverName!,
                        receiverName: cubit.tripDetails!.riderName!,
                        receiverImage: cubit.tripDetails!.riderImage??'',
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
                        ((cubit.tripDetails!.riderPhoneCode ?? "") +
                                (cubit.tripDetails!.riderPhone ?? ""))
                            .toString());
                  },
                  color: AppColors.red.withOpacity(.15),
                ),
              ],
            ),
            //! Divider
            CustomDivider(space: 12.rH(context)),
            //! Arrive In
            //هنا بعرض التيمر يتاع الثلاث حالات الوصول للراكب و انتظاره و بداية الرحلة
            Row(
              children: [
                //! Title
                Text(
                  cubit.isTripStarted
                      ? AppStrings.tripStarted.tr(context)
                      : cubit.isDriverWaiting
                          ? AppStrings.arrivedAndWaiting.tr(context)
                          : AppStrings.youWllArriveIn.tr(context),
                  style: Styles.regular16(context).copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
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
                            final data =
                                snapshot.data!.value as Map<dynamic, dynamic>;
                            final lat =
                                double.tryParse(data['latitude'].toString()) ??
                                    0.0;
                            final lng =
                                double.tryParse(data['longitude'].toString()) ??
                                    0.0;

                            return ArrivalDownTimeTimer(
                              origin: LatLng(lat, lng),
                              destination: LatLng(
                                double.parse(cubit.tripDetails!.dropoffLatitude
                                    .toString()),
                                double.parse(cubit.tripDetails!.dropoffLongitude
                                    .toString()),
                              ),
                            );
                          }
                          return DownTimeTimer(
                              timeMinutes: cubit.tripDetails!.timeMinutes!);
                        },
                      )
                    : cubit.isDriverWaiting
                        ? UpTimeTimer(
                            arrivedTime: cubit.tripDetails!.arrivedAt != null
                                ? DateTime.parse(cubit.tripDetails!.arrivedAt!)
                                    .toLocal()
                                : DateTime.now(),
                          )
                        : FutureBuilder<DataSnapshot>(
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
                                        data['latitude'].toString()) ??
                                    0.0;
                                final lng = double.tryParse(
                                        data['longitude'].toString()) ??
                                    0.0;

                                return ArrivalDownTimeTimer(
                                  origin: LatLng(lat, lng),
                                  destination: LatLng(
                                    double.parse(cubit
                                        .tripDetails!.pickupLatitude
                                        .toString()),
                                    double.parse(cubit
                                        .tripDetails!.pickupLongitude
                                        .toString()),
                                  ),
                                );
                              }
                              return SizedBox(
                                height: 15.rH(context),
                                width: 15.rH(context),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              );
                            },
                          )
                // ArrivalDownTimeTimer(
                //         origin:cubit.tripDetails!.driverId!,
                //         destination: LatLng(
                //           double.parse(cubit.tripDetails!.pickupLatitude
                //               .toString()),
                //           double.parse(cubit
                //               .tripDetails!.pickupLongitude
                //               .toString()),
                //         ),
                //       )

                // : Text(
                //     cubit.formatDuration(),
                //     style: Styles.medium15(context).copyWith(
                //       color: Theme.of(context)
                //           .textTheme
                //           .bodyLarge
                //           ?.color,
                //     ),
                //   ),
              ],
            ),
            SizedBox(height: 8.rH(context)),
            //! Time Bar
            if (!cubit.isDriverWaiting && !cubit.isTripStarted)
              LinearProgressIndicator(
                value: cubit.calculateRemainigArrivalTimeValue(),
                minHeight: 8.rH(context),
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                backgroundColor: AppColors.grey,
                borderRadius: BorderRadius.circular(6),
              ),
            //! Distance Bar
            if (cubit.isTripStarted)
              CarMovementView(
                dropoffLat:
                    double.parse(cubit.tripDetails!.dropoffLatitude.toString()),
                dropoffLng: double.parse(
                    cubit.tripDetails!.dropoffLongitude.toString()),
                driverId: cubit.tripDetails!.driverId!,
              ),
            if (!cubit.isTripStarted) SizedBox(height: 18.rH(context)),
            //! Buttons
            const DriverTripButtons(),
          ],
        );
      },
    );
  }
}

class CarMovementView extends StatefulWidget {
  const CarMovementView({
    super.key,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.driverId,
  });

  final double dropoffLat;
  final double dropoffLng;
  final int driverId;

  @override
  State<CarMovementView> createState() => _CarMovementViewState();
}

class _CarMovementViewState extends State<CarMovementView> {
  int totalSeconds = 0;
  int remainingSeconds = 0;
  bool isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchArrivalTime();
  }

  void _fetchArrivalTime() async {
    final minutes = await MapsHelper.getArrivalTime(
      dropoffLat: widget.dropoffLat,
      dropoffLng: widget.dropoffLng,
      driverId: widget.driverId,
    );

    if (mounted) {
      setState(() {
        totalSeconds = (minutes ?? 0) * 60;
        remainingSeconds = totalSeconds;
        isLoading = false;
      });
      if (totalSeconds > 0) {
        _startTimer();
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        _timer?.cancel();
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
    if (isLoading) {
      return SizedBox(
        height: 50.rH(context),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      );
    }

    double progress = totalSeconds == 0
        ? 1.0
        : (totalSeconds - remainingSeconds) / totalSeconds;
    progress = progress.clamp(0.0, 1.0);

    final double containerWidth = 295.rW(context);
    final double carWidth = 22.rH(context);

    return SizedBox(
      height: 50.rH(context),
      width: containerWidth,
      child: Stack(
        alignment: Alignment.center,
        children: [
          LinearProgressIndicator(
            value: progress,
            minHeight: 8.rH(context),
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            backgroundColor: AppColors.grey,
            borderRadius: BorderRadius.circular(6),
          ),
          AnimatedPositionedDirectional(
            duration: const Duration(seconds: 1),
            start: progress * (containerWidth - carWidth),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 11.rH(context),
                  backgroundColor: AppColors.grey,
                  child: CircleAvatar(
                    radius: 10.rH(context),
                    backgroundColor: AppColors.primary,
                    child: CircleAvatar(
                      radius: 9.rH(context),
                      backgroundColor: AppColors.primary,
                      child: const CustomSvgPicture(
                        svg: Assets.imagesSliderCar,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
