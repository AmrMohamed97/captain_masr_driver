import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../widgets/my_vehicle_body.dart';

class MyVehicleView extends StatelessWidget {
  const MyVehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyVehicleCubit()..getDriverVehicle(),
      child: Scaffold(
        body: BlocConsumer<MyVehicleCubit, MyVehicleState>(
          listener: (context, state) {
            if (state is GetDriverVehicleErrorState) {
              showToast(
                context,
                message: state.error,
                state: ToastStates.error,
              );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return CustomModalProgressIndicator(
              inAsyncCall: state is GetDriverVehicleLoadingState,
              child: const MyVehicleBody(),
            );
          },
        ),
      ),
    );
  }
}
