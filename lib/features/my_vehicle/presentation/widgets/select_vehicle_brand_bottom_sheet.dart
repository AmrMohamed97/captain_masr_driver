import '../../../../core/imports/imports.dart';

class SelectVehicleBrandBottomSheet extends StatelessWidget {
  const SelectVehicleBrandBottomSheet({
    super.key,
    required this.typeId,
  });

  final int typeId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyVehicleCubit()
        ..init(index: 2, id: typeId)
        ..getVehcileBrands(id: typeId),
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
                  AppStrings.selectVehicleBrand.tr(context),
                  style: Styles.regular14(context).copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),

                SizedBox(height: 18.rH(context)),

                //! Items
                state is GetVehicleDetailsLoadingState &&
                        cubit.vehicleBrands.isEmpty
                    ? const Expanded(
                        child: CustomLoadingIndicator(),
                      )
                    : Expanded(
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: cubit.scrollController,
                          itemCount: cubit.vehicleBrands.length,
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
                                  cubit.vehicleBrands[index],
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.rW(context),
                                ),
                                child: Text(
                                  cubit.vehicleBrands[index].name ?? "",
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
