import '../../../../core/imports/imports.dart';
import '../views/edit_vehicle_view.dart';
import 'my_vheicle_form.dart';

class MyVehicleBody extends StatelessWidget {
  const MyVehicleBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyVehicleCubit, MyVehicleState>(
      builder: (context, state) {
        final cubit = context.read<MyVehicleCubit>();
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
          child: Column(
            children: [
              //! Header
              CustomAppBar(
                title: AppStrings.myVehicle.tr(context),
              ),

              SizedBox(height: 26.rH(context)),

              //! Form
              if (cubit.driverVehicleModel != null) const MyVehicleForm(),

              SizedBox(height: 16.rH(context)),

              //! Edit button
              if (cubit.driverVehicleModel != null)
                CustomButton(
                  onPressed: () {
                    navigate(
                      context,
                      EditVehicleView(
                        model: cubit.driverVehicleModel!,
                      ),
                      then: (value) {
                        if (value == true) {
                          cubit.getDriverVehicle();
                        }
                      },
                    );
                  },
                  title: AppStrings.edit.tr(context),
                ),

              SizedBox(height: 36.rH(context)),
            ],
          ),
        );
      },
    );
  }
}
