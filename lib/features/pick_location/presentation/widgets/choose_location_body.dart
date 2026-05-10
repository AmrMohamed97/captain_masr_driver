import '../../../../core/imports/imports.dart';
import 'choose_location_fields.dart';

class ChooseLocationBody extends StatelessWidget {
  const ChooseLocationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
      child: Column(
        children: [
          //! Header
          CustomAppBar(
            title: AppStrings.chooseLocation.tr(context),
          ),

          SizedBox(height: 26.rH(context)),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: const [
                //! Field
                ChooseLocatioFields(),
              ],
            ),
          ),
          SizedBox(height: 16.rH(context)),

          //! Confirm Button
          BlocBuilder<ChooseLocationCubit, ChooseLocationState>(
            builder: (context, state) {
              final cubit = context.read<ChooseLocationCubit>();
              return CustomButton(
                onPressed: () {
                  Navigator.pop(context, [
                    cubit.selectedStartLocation,
                    cubit.selectedEndLocation,
                    cubit.stopsSelectedLocations,
                  ]);
                },
                title: AppStrings.confirm.tr(context),
              );
            },
          ),
          SizedBox(height: 24.rH(context)),
        ],
      ),
    );
  }
}
