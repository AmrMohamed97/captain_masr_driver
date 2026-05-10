import '../../../../core/imports/imports.dart';

class SelectVehicleColorBottomSheet extends StatelessWidget {
  const SelectVehicleColorBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyVehicleCubit()
        ..init(index: 4, id: null)
        ..getVehcileColors(),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: 300.rH(context),
          minHeight: 300.rH(context),
        ),
        padding: EdgeInsets.only(
          bottom: 24.rH(context),
          left: 16.rW(context),
          right: 16.rW(context),
        ),
        child: BlocBuilder<MyVehicleCubit, MyVehicleState>(
          builder: (context, state) {
            final cubit = context.read<MyVehicleCubit>();
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.selectVehicleColor.tr(context),
                  style: Styles.regular14(context).copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),

                SizedBox(height: 18.rH(context)),

                //! Items
                state is GetVehicleDetailsLoadingState &&
                        cubit.vehicleColors.isEmpty
                    ? const Expanded(
                        child: CustomLoadingIndicator(),
                      )
                    : Expanded(
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: cubit.scrollController,
                          itemCount: cubit.vehicleColors.length,
                          separatorBuilder: (context, index) {
                            return CustomDivider(
                              space: 4.rH(context),
                            );
                          },
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(
                                  context,
                                  cubit.vehicleColors[index],
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.rW(context),
                                ),
                                child: Text(
                                  cubit.vehicleColors[index].name ?? "",
                                  style: Styles.medium14(context).copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                if (state is GetVehicleDetailsLoadingState &&
                    cubit.vehicleBrands.isNotEmpty)
                  Container(
                    height: 30.rH(context),
                    margin: EdgeInsets.symmetric(vertical: 8.rH(context)),
                    child: const CustomLoadingIndicator(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
