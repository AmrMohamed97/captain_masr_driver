import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../home/presentation/views/home_view.dart';
import '../cubit/driver_trip_cubit.dart';
import '../widgets/driver_share_trip_request_alert_dialog.dart';
import '../widgets/driver_trip_body.dart';
import '../widgets/driver_trip_completed_alert_dialog.dart';
import '../widgets/on_my_way_arrived_alert_dialog.dart';
import '../widgets/on_my_way_rider_request_alert_dialog.dart';

class DriverTripView extends StatelessWidget {
  const DriverTripView({
    super.key,
    required this.tripId,
    this.isClassicTrip = false,
    this.isGroupTrip = false,
    this.isShareTrip = false,
    this.isDeliveryTrip = false,
    this.isOnMyWay = false,
  });

  final int tripId;
  final bool isClassicTrip, isGroupTrip, isShareTrip, isDeliveryTrip, isOnMyWay;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DriverTripCubit(
        isClassicTrip: isClassicTrip,
        isGroupTrip: isGroupTrip,
        isShareTrip: isShareTrip,
        isOnMyWay: isOnMyWay,
        isDeliveryTrip: isDeliveryTrip,
        driverLocation: context.read<GlobalCubit>().userLocation,
        tripId: tripId,
      ),
      child: BlocConsumer<DriverTripCubit, DriverTripState>(
        listener: (context, state) {
          if (state is DriverCompleteShareTripState) {
            showDialog(
              context: context,
              builder: (context) => const OnMyWayArrivedAlertDialog(),
            );
          }
          if (state is DriverTripSuccessState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.success,
            );
          }
          if (state is DriverTripErrorState) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
            );
          }
          if (state is OnMyWayRiderJoinRequestState) {
            showDialog(
              context: context,
              builder: (context) => const OnMyWayRiderRequestAlertDialog(),
            ).then(
              (value) {
                if (value == true) {
                  // context.read<DriverTripCubit>().addRider();
                }
              },
            );
          }
          if (state is NewRiderJoinState) {
            showDialog(
              context: context,
              barrierColor: AppColors.transparent,
              builder: (context) => DriverShareTripRequestAlertDialog(
                tripDetails: state.tripDetails,
              ),
            ).then(
              (value) {
                if (value == true) {
                  context
                      .read<DriverTripCubit>()
                      .acceptShareTripRider(state.tripDetails);
                }
              },
            );
          }
          if (state is DriverCancelTripSuccessState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.success,
            );
            final globalCubit = context.read<GlobalCubit>();
            globalCubit.navBarController.jumpToTab(0);
            navigateAndRemoveUntil(
              context,
              context.read<GlobalCubit>().isRider
                  ? const BaseView()
                  : const HomeView(),
            );
          }
          // if (state is RideCompleteState &&
          //     context.read<RiderTripCubit>().hasPayed == true) {
          //   bool isDelivery = context.read<RiderTripCubit>().isDelivery;
          //   showDialog(
          //     context: context,
          //     barrierDismissible: false,
          //     builder: (context) => RateRideAlertDialog(
          //       isDelivery: isDelivery,
          //     ),
          //   );
          // }

          // if (state is AlmostArriveState) {
          //   showDialog(
          //     context: context,
          //     barrierDismissible: false,
          //     builder: (context) => const PayNowAlertDialog(),
          //   ).whenComplete(() {
          //     context.read<RiderTripCubit>().hasPayed = true;
          //     if (context.read<RiderTripCubit>().isTripCompleted == true) {
          //       showDialog(
          //         context: context,
          //         barrierDismissible: false,
          //         builder: (context) => const RateRideAlertDialog(),
          //       );
          //     }
          //   });
          // }
          if (state is DriverTripCancelledFromRiderState) {
            showToast(
              context,
              message: AppStrings.tripHasCancelledByRider.tr(context),
              state: ToastStates.warning,
            );
            final globalCubit = context.read<GlobalCubit>();
            globalCubit.navBarController.jumpToTab(0);
            navigateAndRemoveUntil(
              context,
              context.read<GlobalCubit>().isRider
                  ? const BaseView()
                  : const HomeView(),
            );
          }
          //! Trip Completed
          if (state is DriverTripCompletedState) {
            // BlocProvider.of<HomeCubit>(context).getDriverTodaySummary();
            final cubit = context.read<DriverTripCubit>();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => DriverTripCompletedAlertDialog(
                completeTripResponseModel: state.completeTripResponseModel,
                model: cubit.tripDetails!,
                completedTripsToday: ((BlocProvider.of<GlobalCubit>(context)
                            .driverTodaySummary
                            ?.tripCount ??
                        0) +
                    1), // state.tripCompletedToday ,
                isDeliveryTrip: cubit.isDeliveryTrip,
                continueTrip: cubit.riders.length > 1 ||
                    cubit.isOnMyWay ||
                    cubit.isShareTrip,
              ),
            ).then((value) {
              if (value == true) {
                cubit.removeRider();
                cubit.selectDriver(true);
                cubit.remainingDistanceNum = (cubit.totalDistanceNum ?? 1) - .5;
                // Timer is now handled automatically by _startStatusTimer
              }
            });
          }
        },
        builder: (context, state) {
          return const Scaffold(
            resizeToAvoidBottomInset: false,
            body: DriverTripBody(),
          );
        },
      ),
    );
  }
}
