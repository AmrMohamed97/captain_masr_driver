import '../../../../core/imports/imports.dart';
import '../widgets/package_details_body.dart';

class PackageDetailsView extends StatelessWidget {
  const PackageDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeliveryCubit(),
      child: Scaffold(
        body: BlocConsumer<DeliveryCubit, DeliveryState>(
          listener: (context, state) {},
          builder: (context, state) {
            return CustomModalProgressIndicator(
              inAsyncCall: state is DeliveryGetVehicleCategoriesLoadingState,
              child: const PackageDetailsBody(),
            );
          },
        ),
      ),
    );
  }
}
