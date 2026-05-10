import '../../../../core/imports/imports.dart';
import '../widgets/available_trips_body.dart';

class AvailableTripsView extends StatelessWidget {
  const AvailableTripsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AvailableTripsBody(),
    );
  }
}
