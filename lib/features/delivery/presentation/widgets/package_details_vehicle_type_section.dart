import 'package:flutter_svg/svg.dart';

import '../../../../core/imports/imports.dart';

class PackageDetailsVehcileTypeSection extends StatelessWidget {
  const PackageDetailsVehcileTypeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryCubit, DeliveryState>(
      builder: (context, state) {
        final cubit = context.read<DeliveryCubit>();
        return Column(
          children: [
            //! Title
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                "${AppStrings.selectTheVehicleType.tr(context)}:",
                style: Styles.medium14(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            SizedBox(height: 10.rH(context)),
            //! List View
            AnimatedCrossFade(
              firstChild: SizedBox(
                height: 74.rH(context),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: List.generate(
                    cubit.vehicleCategories.length,
                    (index) => Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: index != 0 ? 10.rW(context) : 0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => cubit.chooseVhecileCategory(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 67.rW(context),
                              height: 50.rH(context),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.rW(context),
                                vertical: 8.rH(context),
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                border: Border.all(
                                  color: cubit.vehicleCategories[index].id ==
                                          cubit.selectedVehicleCategoryId
                                      ? AppColors.primary
                                      : AppColors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 2.rH(context)),
                                    blurRadius: 7,
                                    color: Theme.of(context).shadowColor,
                                  ),
                                ],
                              ),
                              child: cubit.vehicleCategories[index].logo
                                          ?.contains(".svg") ??
                                      false
                                  ? SvgPicture.network(
                                      cubit.vehicleCategories[index].logo ?? "",
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                        Icons.error,
                                        color: AppColors.grey,
                                      ),
                                    )
                                  : Image.network(
                                      cubit.vehicleCategories[index].logo ?? "",
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                        Icons.error,
                                        color: AppColors.grey,
                                      ),
                                    ),
                            ),
                          ),
                          Text(
                            cubit.vehicleCategories[index].name ?? "",
                            style: Styles.regular12(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              secondChild: Container(),
              crossFadeState: cubit.vehicleCategories.isNotEmpty
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
            ),

            SizedBox(height: 26.rH(context)),
          ],
        );
      },
    );
  }
}
