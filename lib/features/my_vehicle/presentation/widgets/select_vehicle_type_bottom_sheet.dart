import '../../../../core/imports/imports.dart';

class SelectVehicleTypeBottomSheet extends StatelessWidget {
  const SelectVehicleTypeBottomSheet({
    super.key,
    required this.vehicleCategoryId,
  });

  final int vehicleCategoryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyVehicleCubit()
        ..init(index: 1, id: vehicleCategoryId)
        ..getVehcileTypes(id: vehicleCategoryId),
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
                  AppStrings.selectVehicleType.tr(context),
                  style: Styles.regular14(context).copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),

                SizedBox(height: 18.rH(context)),

                //! Items
                state is GetVehicleDetailsLoadingState &&
                        cubit.vehicleTypes.isEmpty
                    ? const Expanded(
                        child: CustomLoadingIndicator(),
                      )
                    : Expanded(
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: cubit.scrollController,
                          itemCount: cubit.vehicleTypes.length,
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
                                  cubit.vehicleTypes[index],
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.rW(context),
                                ),
                                child: Text(
                                  cubit.vehicleTypes[index].name ?? "",
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
                    cubit.vehicleTypes.isNotEmpty)
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
