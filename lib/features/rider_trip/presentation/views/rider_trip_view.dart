import '../../../../core/imports/imports.dart';
import '../cubit/rider_trip_cubit.dart';
import '../widgets/rider_trip_body.dart';

class RiderTripView extends StatelessWidget {
  const RiderTripView({
    super.key,
    required this.tripId,
    this.isShareRide = false,
    this.isDelivery = false,
  });

  final int tripId;
  final bool isShareRide, isDelivery;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RiderTripCubit(
        isDelivery: isDelivery,
        isShareRide: isShareRide,
        tripId: tripId,
        riderId: context.read<GlobalCubit>().userModel?.id ?? 0,
      ),
      child: const Scaffold(
        body: RiderTripBody(),
      ),
    );
  }
}
