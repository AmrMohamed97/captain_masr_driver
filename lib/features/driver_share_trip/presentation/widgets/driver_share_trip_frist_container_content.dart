import 'dart:async';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_cached_network_image.dart';
import '../../../chat/presentation/views/chat_view.dart';
import '../../../rider_share_trip/presentation/views/rider_share_trip_view.dart';
import '../cubit/driver_share_trip_cubit.dart';
import 'arrival_share_down_time_timer.dart';
import 'down_time_timer_share.dart';
import 'driver_share_trip_buttons.dart';
import 'up_time_timer_share.dart';

class DriverShareTripFirstContainerContent extends StatefulWidget {
  final int tripId;
  const DriverShareTripFirstContainerContent({
    super.key,
    required this.tripId,
  });
  @override
  State<DriverShareTripFirstContainerContent> createState() =>
      _DriverShareTripFirstContainerContentState();
}

class _DriverShareTripFirstContainerContentState
    extends State<DriverShareTripFirstContainerContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverShareTripCubit, DriverShareTripState>(
      builder: (context, state) {
        final cubit = context.read<DriverShareTripCubit>();

        return Column(
          children: [
            //! Title
            Text(
              cubit.isDriverSelected
                  ? AppStrings.yourTrip.tr(context)
                  : AppStrings.tripDetails.tr(context),
              style: Styles.semibold16Primary(context).copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            SizedBox(height: 14.rH(context)),
            Row(
              children: [
                //! Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CustomCachedNetworkImage(
                    imageUrl: cubit.isDriverSelected
                        ? (context
                                .read<GlobalCubit>()
                                .userModel
                                ?.profilePicture ??
                            "")
                        : (cubit.tripDetails!.riderImage ?? ""),
                    w: 46.rH(context),
                    h: 46.rH(context),
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => CustomSvgPicture(
                      svg: Assets.imagesPersonSvg,
                      height: 46.rH(context),
                    ),
                  ),
                ),
                SizedBox(width: 8.rW(context)),
                //! Name & Preferences
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cubit.isDriverSelected
                            ? (context
                                    .read<GlobalCubit>()
                                    .userModel
                                    ?.username ??
                                "")
                            : (cubit.tripDetails!.riderName ?? ""),
                        style: Styles.medium15(context).copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      SizedBox(height: 2.rH(context)),
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
                        chatId: getChatId(
                            tripId: widget.tripId,
                            riderId: cubit.tripDetails!
                                .riderId!), //cubit.tripDetails!.id!,
                        senderId: cubit.tripDetails!.driverId!,
                        receiverId: cubit.tripDetails!.riderId!,
                        senderName: cubit.tripDetails!.driverName!,
                        receiverName: cubit.tripDetails!.riderName!,
                        receiverImage: cubit.tripDetails!.riderImage ?? '',
                        resolvedRequestType: 'share trip',
                        // cubit.tripDetails!.tripType ?? '',
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 14.rH(context)),
              child: Divider(
                color: AppColors.grey.withOpacity(.5),
              ),
            ),
            //! Remaining Distance & Duration
            Row(
              children: [
                Text(
                  cubit.isDriverWaiting
                      ? AppStrings.arrivedAndWaiting
                      : AppStrings.arrivesIn.tr(context),
                  style: Styles.medium15(context).copyWith(
                    color: AppColors.greyText,
                  ),
                ),
                const Spacer(),
                CustomSvgPicture(
                  svg: Assets.imagesTime,
                  height: 15.rH(context),
                ),
                SizedBox(width: 8.rW(context)),
                if (cubit.isDriverWaiting)
                  UpTimeTimerShare(
                    arrivedTime: cubit.tripDetails!.arrivedAt != null
                        ? DateTime.parse("${cubit.tripDetails!.arrivedAt!}Z")
                            .toLocal()
                        : cubit.driverarrivalTime ?? DateTime.now(),
                  )
                else if (cubit.travelTimeSeconds != null)
                  ArrivalShareDownTimeTimer(
                      initialSeconds: cubit.travelTimeSeconds!)
                else
                  DownTimeTimerShare(
                    timeMinutes: cubit.tripDetails!.timeMinutes!,
                  ),
              ],
            ),
            SizedBox(height: 8.rH(context)),
            //! Distance Bar
            if (cubit.isTripStarted)
              CarMovementViewShare(
                initialSeconds: (cubit.travelTimeSeconds ??
                        (cubit.tripDetails!.timeMinutes! * 60))
                    .toInt(),
              )
            else if (!cubit.isDriverWaiting)
              LinearProgressIndicator(
                value: cubit.calculateRemainigArrivalTimeValue(),
                minHeight: 8.rH(context),
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                backgroundColor: AppColors.grey,
                borderRadius: BorderRadius.circular(6),
              ),
            if (!cubit.isTripStarted) SizedBox(height: 18.rH(context)),
            //! Buttons
            const DriverShareTripButtons(),
          ],
        );
      },
    );
  }
}

class CarMovementViewShare extends StatefulWidget {
  const CarMovementViewShare({
    super.key,
    required this.initialSeconds,
  });

  final int initialSeconds;

  @override
  State<CarMovementViewShare> createState() => _CarMovementViewShareState();
}

class _CarMovementViewShareState extends State<CarMovementViewShare> {
  int totalSeconds = 0;
  int remainingSeconds = 0;
  bool isLoading = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    totalSeconds = widget.initialSeconds;
    remainingSeconds = totalSeconds;
    if (totalSeconds > 0) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(covariant CarMovementViewShare oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSeconds != widget.initialSeconds) {
      setState(() {
        totalSeconds = widget.initialSeconds;
        remainingSeconds = totalSeconds;
      });
      _startTimer();
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
