import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../data/models/driver_vehicle_model.dart';
import '../widgets/edit_vehicle_body.dart';

class EditVehicleView extends StatelessWidget {
  const EditVehicleView({
    super.key,
    required this.model,
  });

  final DriverVehicleModel model;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyVehicleCubit()..initEdit(model),
      child: BlocConsumer<MyVehicleCubit, MyVehicleState>(
        listener: (context, state) {
          if (state is EditVehicleESuccessState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.success,
            );
            Navigator.pop(context, true);
          }
          if (state is EditVehicleErrorState) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) {
          return CustomModalProgressIndicator(
            inAsyncCall: state is EditVehicleLoadingState,
            child: const Scaffold(
              body: EditVehicleBody(),
            ),
          );
        },
      ),
    );
  }
}
