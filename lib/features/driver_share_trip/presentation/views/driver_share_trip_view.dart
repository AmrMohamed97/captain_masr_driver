import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../home/presentation/views/home_view.dart';
import '../cubit/driver_share_trip_cubit.dart';
import '../widgets/driver_share_trip_request_alert_dialog.dart';
import '../widgets/driver_share_trip_body.dart';
import '../widgets/driver_share_trip_completed_alert_dialog.dart';
import '../widgets/on_my_way_arrived_alert_dialog_share.dart';

class DriverShareTripView extends StatelessWidget {
  const DriverShareTripView({
    super.key,
    required this.tripId,
  });

  final int tripId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DriverShareTripCubit(
        tripId: tripId,
      ),
      child: BlocConsumer<DriverShareTripCubit, DriverShareTripState>(
        listener: (context, state) {
          if (state is DriverShareCompleteShareTripState) {
            showDialog(
              context: context,
              builder: (context) => const OnMyWayArrivedAlertDialogShare(),
            );
          }
          if (state is DriverShareTripSuccessState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.success,
            );
          }
          if (state is DriverShareTripErrorState) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
            );
          }
          if (state is NewShareRiderJoinState) {
            if (BlocProvider.of<GlobalCubit>(context).isDriver) {
              showDialog(
                context: context,
                barrierColor: AppColors.transparent,
                builder: (context) => DriverShareTripRequestAlertDialogShare(
                  tripDetails: state.tripDetails,
                ),
              ).then(
                (value) {
                  if (value == true) {
                    context
                        .read<DriverShareTripCubit>()
                        .acceptShareTripRider(state.tripDetails);
                  }
                  if (value == false) {
                    context
                        .read<DriverShareTripCubit>()
                        .declineRiderRequest(requestId: state.tripDetails.id!);
                  }
                },
              );
            }
          }
          if (state is DriverCancelShareTripSuccessState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.success,
            );
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
          if (state is DriverShareTripCancelledFromRiderState) {
            showToast(
              context,
              message: AppStrings.tripHasCancelledByRider.tr(context),
              state: ToastStates.warning,
            );
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
          //! Trip Completed
          if (state is DriverShareTripCompletedState) {
            final cubit = context.read<DriverShareTripCubit>();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => DriverShareTripCompletedAlertDialog(
                completeTripResponseModel: state.completeTripResponseModel,
                model: state.tripDetails!, // cubit.tripDetails!,
                // completedTripsToday: null,
                isDeliveryTrip: false,
                continueTrip: true,
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
          return   Scaffold(
            resizeToAvoidBottomInset: false,
            body: DriverShareTripBody(tripId:tripId),
          );
        },
      ),
    );
  }
}
