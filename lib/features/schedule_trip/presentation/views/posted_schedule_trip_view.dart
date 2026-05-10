import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../driver_share_trip/presentation/views/driver_share_trip_view.dart';
import '../../../home/presentation/views/home_view.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';
import '../widgets/posted_schedule_trip_body.dart';

class PostedScheduleTripView extends StatelessWidget {
  const PostedScheduleTripView({
    super.key,
    required this.trip,
  });

  final TripDetailsModel trip;

  @override
  Widget build(BuildContext context) {
    // print("====================trip id======================================");
    // print("postedTrip!.id: ${trip.id}");
    return BlocProvider(
      create: (context) {
        final cubit = ScheduleTripCubit(
          isRider: context.read<GlobalCubit>().isRider,
          postedTrip: trip,
          isPostedTrip: true,
        );
        // cubit.initStatus();
        cubit.initRequestsRealTime(
          isRider: context.read<GlobalCubit>().isRider,
        );
        cubit.initTodayStatusRealTime(context.read<GlobalCubit>().isRider);
        cubit.initTodayRiderStatusRealTime(
            isRider: context.read<GlobalCubit>().isRider,
            riderId: context.read<GlobalCubit>().userModel?.id);
        // ...init status of trip from server
        return cubit;
      },
      child: BlocConsumer<ScheduleTripCubit, ScheduleTripState>(
        listener: (context, state) {
          if (state is DriverStartScheduleTripSuccessState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.success,
            );
            if (context.read<GlobalCubit>().isDriver) {
              //change from DriverTripView to DriverShareTripView
              navigateReplacement(
                context,
                DriverShareTripView(
                  tripId: state.tripId,
                  // isOnMyWay: true,
                  // isShareTrip: true,
                ),
              );
            }
            // else {
            //   ....
            // }
          }
          if (state is ScheduleTripSuccessState) {
            state.message != null
                ? showToast(
                    context,
                    message: state.message!,
                    state: ToastStates.success,
                  )
                : null;
          }
          if (state is DriverCancelScheduleSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showToast(
                context,
                message: state.message,
                state: ToastStates.success,
              );
              context.read<GlobalCubit>().scaffoldKey =
                  GlobalKey<ScaffoldState>();
              navigateAndRemoveUntil(
                context,
                const HomeView(),
              );
            });
          }
          if (state is ScheduleTripErrorState) {
            showToast(
              context,
              message: state.errorMessage,
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) => Scaffold(
          body: CustomModalProgressIndicator(
            inAsyncCall: state is ScheduleTripLoadingState,
            child: const PostedScheduleTripBody(),
          ),
        ),
      ),
    );
  }
}
