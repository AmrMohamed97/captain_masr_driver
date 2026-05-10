import '../../../../core/imports/imports.dart';
import '../widgets/pick_location_body.dart';

class PickLocationView extends StatelessWidget {
  const PickLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChooseLocationCubit(
        isRider: context.read<GlobalCubit>().isRider,
        selectionMode: SelectionMode.pickup,
      )..getCurrentLocation(),
      child: const Scaffold(
        body: PickLocationBody(),
      ),
    );
  }
}
