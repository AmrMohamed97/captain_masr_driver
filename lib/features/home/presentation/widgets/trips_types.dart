import 'package:captain_masr_driver/features/home/presentation/cubit/home_cubit.dart';
import 'package:captain_masr_driver/features/home/presentation/widgets/home_driver_preferences.dart';

import '../../../../core/imports/imports.dart';

class TripsTypes extends StatelessWidget {
  const TripsTypes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(AppStrings.tripsTypes.tr(context)),
      ),
      body: BlocProvider(
        create: (context) => HomeCubit(isDriver: true),
        child: const HomeDriverPreferences(),
      ),
    );
  }
}
