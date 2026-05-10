import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../delivery/data/models/delivery_details_model.dart';
import '../../../driver_share_trip/presentation/views/driver_share_trip_view.dart';
// import '../../../driver_trip/presentation/views/driver_trip_view.dart';
import '../../../find_driver/presentation/views/find_driver_view.dart';
import '../cubit/start_trip_cubit/start_trip_cubit.dart';
import '../widgets/start_trip_body.dart';

class StartTripView extends StatelessWidget {
  const StartTripView({
    super.key,
    this.isShareRide = false,
    this.isDelivery = false,
    this.isDailyRideNow = false,
    this.driverOnMyWay = false,
    this.deliveryDetailsModel,
  });

  final bool isShareRide, isDelivery, isDailyRideNow, driverOnMyWay;
  final DeliveryDetailsModel? deliveryDetailsModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StartTripCubit()
        ..isShareRide = isShareRide
        ..isDailyRideNow = isDailyRideNow
        ..driverOnMyWay = driverOnMyWay
        ..isDelivery = isDelivery
        ..deliveryDetailsModel = deliveryDetailsModel
        ..getVehicleCategories(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<StartTripCubit, StartTripState>(
          listener: (context, state) {
            if (state is DriverPostShareTripSuccessState) {
              showToast(
                context,
                message: state.message,
                state: ToastStates.success,
              );
              navigate(
                //ToDo
                context,
                DriverShareTripView(
                  tripId: state.tripId,
                  // isShareTrip: true,
                  // isOnMyWay: true,
                ),
              );
            }
            if (state is RiderRequestTripSuccessState) {
              navigateReplacement(
                context,
                FindDriverView(
                  isShareRide: context.read<StartTripCubit>().isShareRide,
                  isDelivery: context.read<StartTripCubit>().isDelivery,
                  tripDetails: context.read<StartTripCubit>().details!,
                ),
              );
              return;
            }
            if (state is RiderRequestTripErrorState) {
              showToast(
                context,
                message: state.error,
                state: ToastStates.error,
              );
            }
            if (state is CalculateEstimatedErrorState) {
              showToast(
                context,
                message: state.error,
                state: ToastStates.error,
              );
            }
            if (state is StartTripErrorState) {
              showToast(
                context,
                message: state.error,
                state: ToastStates.error,
              );
            }
          },
          builder: (context, state) {
            return CustomModalProgressIndicator(
              inAsyncCall: state is StartTripLoadingState,
              child: const StartTripBody(),
            );
          },
        ),
      ),
    );
  }
}
