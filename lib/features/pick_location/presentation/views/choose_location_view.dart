import '../../../../core/imports/imports.dart';
import '../../data/models/selected_location_model.dart';
import '../widgets/choose_location_body.dart';

class ChooseLocationView extends StatelessWidget {
  const ChooseLocationView({
    super.key,
    this.startLocation,
    this.endLocation,
    this.stops,
    required this.selectionMode,
  });

  final SelectedLocationModel? startLocation, endLocation;
  final List<SelectedLocationModel>? stops;
  final SelectionMode selectionMode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChooseLocationCubit(
        isRider: context.read<GlobalCubit>().isRider,
        selectionMode: selectionMode,
      )
        ..getSavedLocations()
        ..getRecentLocations()
        ..passLocations(
          startLocation: startLocation,
          endLocation: endLocation,
          stopsLocations: stops ?? [],
        ),
      child: const Scaffold(
        body: ChooseLocationBody(),
      ),
    );
  }
}
