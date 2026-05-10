import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';
import '../../../rider_trip/presentation/views/rider_trip_view.dart';
import '../widgets/find_driver_body.dart';

class FindDriverView extends StatelessWidget {
  const FindDriverView({
    super.key,
    this.isShareRide = false,
    this.isDelivery = false,
    required this.tripDetails,
    this.createdAt,
  });

  final bool isShareRide, isDelivery;
  final TripDetailsModel tripDetails;
  final String? createdAt;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FindDriverCubit(
        tripDetails: tripDetails,
        isDelivery: isDelivery,
        isShareRide: isShareRide,
        createdAt: createdAt,
      ),
      child: BlocConsumer<FindDriverCubit, FindDriverState>(
        listener: (context, state) {
          if (state is FindDriverCancelTripSuccessState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.success,
            );
            Navigator.pop(context);
          }
          if (state is FindDriverCancelTripErrorState) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
            );
          }
          if (state is AcceptDriverSuccessState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.success,
            );
            final cubit = context.read<FindDriverCubit>();
            navigateReplacement(
                context,
                RiderTripView(
                  isShareRide: cubit.isShareRide,
                  isDelivery: cubit.isDelivery,
                  tripId: cubit.tripDetails?.rideId ?? 0,
                ));
          }
          if (state is AcceptDriverErrorState) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: CustomModalProgressIndicator(
              inAsyncCall: state is FindDriverCancelTripLoadingState ||
                  state is AcceptRequestLoadingState,
              child: const FindDriverBody(),
            ),
          );
        },
      ),
    );
  }
}
