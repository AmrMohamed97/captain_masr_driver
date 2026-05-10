import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../rider_share_trip/presentation/views/rider_share_trip_view.dart';
import '../../data/models/rider_share_trip_data_model.dart';
import '../cubit/available_share_trip_cubit/available_share_trips_cubit.dart';
import '../widgets/available_share_trip_body.dart';

class AvailableShareTripsView extends StatelessWidget {
  const AvailableShareTripsView({
    super.key,
    required this.model,
    this.isScheduled = false,
  });

  final RiderShareTripDataModel model;
  final bool isScheduled;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AvailableShareTripsCubit(isScheduled: isScheduled)
        ..shareTripData = model
        ..riderSearchShareRides()//search for available share trips on server
        ..initPagination()
        ..initRealtime(riderId: context.read<GlobalCubit>().userModel?.id ?? 0),
      child: BlocConsumer<AvailableShareTripsCubit, AvailableShareTripsState>(
        listener: (context, state) {
          if (state is AvailableShareTripsErrorState) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
            );
          }
          if (state is AvailableShareTripsSuccessState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.success,
            );
          }
          if (state is DriverAcceptTrip) {
            showToast(
              context,
              message: AppStrings.driverAcceptedYourRequest.tr(context),
              state: ToastStates.success,
            );
            navigateReplacement(
              context,
              RiderShareTripView(
                tripId: state.tripId,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: CustomModalProgressIndicator(
              inAsyncCall: state is AvailableShareTripsLoadingState,
              child: const AvailableShareTripBody(),
            ),
          );
        },
      ),
    );
  }
}
