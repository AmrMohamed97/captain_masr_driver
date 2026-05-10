import '../../../../core/imports/imports.dart';
import '../cubit/rider_share_trip_cubit.dart';
import '../widgets/rider_share_trip_body.dart';

class RiderShareTripView extends StatelessWidget {
  const RiderShareTripView({
    super.key,
    required this.tripId,
  });

  final int tripId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RiderShareTripCubit(
        tripId: tripId,
        riderId: context.read<GlobalCubit>().userModel?.id ?? 0,
      ),
      child:  Scaffold(
        body: RiderShareTripBody(tripId:tripId),
      ),
    );
  }
}
int getChatId({required int tripId, required int riderId}) {
  final a = tripId;
  final b = riderId;
  return ((a + b) * (a + b + 1) ~/ 2) + b;
}