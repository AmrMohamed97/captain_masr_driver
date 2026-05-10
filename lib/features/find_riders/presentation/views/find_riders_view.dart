import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
// import '../../../driver_trip/presentation/views/driver_trip_view.dart';
import '../../../driver_trip/presentation/views/driver_trip_view.dart';
import '../widgets/find_riders_body.dart';
import '../widgets/find_riders_error_widget.dart';

class FindRidersView extends StatelessWidget {
  const FindRidersView({super.key, this.acceptedTripTypeIds = const []});

  final List<int> acceptedTripTypeIds;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FindRidersCubit(
        context,
        driverId: context.read<GlobalCubit>().userModel?.id ?? 0,
        acceptedTripTypeIds: acceptedTripTypeIds,
      ),
      child: BlocConsumer<FindRidersCubit, FindRidersState>(
        listener: (context, state) {
          if (state is RequestAcceptedState) {
            navigateReplacement(
              context,
              DriverTripView(
                tripId: state.tripId,
                isClassicTrip: state.tripType == "classic",
                isDeliveryTrip: state.tripType == "delivery",
              ),
            );
            showToast(
              context,
              message: AppStrings.yourRideRequestHasBeenAccepted.tr(context),
              state: ToastStates.success,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: state is RealTimeErrorState
                ? const FindRidersErrorWidget()
                : const FindRidersBody(),
          );
        },
      ),
    );
  }
}
