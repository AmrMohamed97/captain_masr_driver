import '../../../../core/imports/imports.dart';
import '../../../my_vehicle/data/models/vehicle_brand_model.dart';
import '../../../my_vehicle/data/models/vehicle_color_model.dart';
import '../../../my_vehicle/data/models/vehicle_model_model.dart';
import '../../../my_vehicle/data/models/vehicle_type_model.dart';
import '../../../my_vehicle/presentation/widgets/custom_bottom_sheet_select_container.dart';
import '../../../my_vehicle/presentation/widgets/select_vehicle_brand_bottom_sheet.dart';
import '../../../my_vehicle/presentation/widgets/select_vehicle_color_bottom_sheet.dart';
import '../../../my_vehicle/presentation/widgets/select_vehicle_model_bottom_sheet.dart';
import '../../../my_vehicle/presentation/widgets/select_vehicle_type_bottom_sheet.dart';
import '../cubit/register_cubit.dart';

class RegisterSecondForm extends StatelessWidget {
  const RegisterSecondForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();
        return SingleChildScrollView(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: cubit.secondFormKey,
            child: Column(
              children: [
                //! Vehicle Categories
                state is GetVehicleCategoriesLoadingState
                    ? Center(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 16.rH(context)),
                          child: SizedBox(
                            height: 30.rH(context),
                            child: const CustomLoadingIndicator(),
                          ),
                        ),
                      )
                    : cubit.vehicleCategories.isEmpty
                        ? GestureDetector(
                            onTap: () {
                              cubit.getVehicleCategories();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.rW(context),
                                vertical: 8.rH(context),
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(
                                Icons.refresh,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 80.rH(context),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: List.generate(
                                cubit.vehicleCategories.length,
                                (index) {
                                  return Padding(
                                    padding: EdgeInsetsDirectional.only(
                                      end: 8.rW(context),
                                    ),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            cubit.selectedVehicleCategoryId =
                                                cubit.vehicleCategories[index]
                                                    .id;
                                            cubit.selectedVehicleType = null;
                                            cubit.selectedVehicleBrand = null;
                                            cubit.selectedVehicleModel = null;
                                            cubit.selectItem();
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            width: 67.rW(context),
                                            height: 50.rH(context),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.rW(context),
                                                vertical: 8.rH(context)),
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).cardColor,
                                              border: Border.all(
                                                width: 2,
                                                color: cubit
                                                            .vehicleCategories[
                                                                index]
                                                            .id ==
                                                        cubit
                                                            .selectedVehicleCategoryId
                                                    ? AppColors.primary
                                                    : AppColors.transparent,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              boxShadow: [
                                                BoxShadow(
                                                  offset:
                                                      Offset(0, 2.rH(context)),
                                                  blurRadius: 7,
                                                  color: Theme.of(context)
                                                      .shadowColor,
                                                ),
                                              ],
                                            ),
                                            child: Image.network(
                                              cubit.vehicleCategories[index]
                                                      .logo ??
                                                  "",
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return const Icon(
                                                  Icons.error,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8.rH(context)),
                                        Text(
                                          cubit.vehicleCategories[index].name ??
                                              "",
                                          style: Styles.regular12(context)
                                              .copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                //! Vehicle Type
                CustomBottomSheetSelectContainer(
                  enabled: cubit.selectedVehicleCategoryId != null,
                  svg: Assets.imagesVehicleType,
                  value: cubit.selectedVehicleType?.name,
                  title: AppStrings.vehicleType.tr(context),
                  hint: AppStrings.selectVehicleType.tr(context),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      isScrollControlled: true,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      builder: (context) => SelectVehicleTypeBottomSheet(
                        vehicleCategoryId: cubit.selectedVehicleCategoryId!,
                      ),
                    ).then((model) {
                      if (model != null && model is VehicleTypeModel) {
                        cubit.selectedVehicleType = model;
                        cubit.selectedVehicleBrand = null;
                        cubit.selectedVehicleModel = null;
                        cubit.selectItem();
                      }
                    });
                  },
                  validationText:
                      cubit.selectedVehicleType == null && cubit.showValidation
                          ? AppStrings.selectVehicleType.tr(context)
                          : null,
                ),
                SizedBox(height: 16.rH(context)),
                //! Vehicle Brand
                CustomBottomSheetSelectContainer(
                  enabled: cubit.selectedVehicleType != null,
                  svg: Assets.imagesVehicleBrand,
                  value: cubit.selectedVehicleBrand?.name,
                  title: AppStrings.vehicleBrand.tr(context),
                  hint: AppStrings.selectVehicleBrand.tr(context),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      isScrollControlled: true,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      builder: (context) => SelectVehicleBrandBottomSheet(
                        typeId: cubit.selectedVehicleType!.id!,
                      ),
                    ).then((model) {
                      if (model != null && model is VehicleBrandModel) {
                        cubit.selectedVehicleBrand = model;
                        cubit.selectedVehicleModel = null;
                        cubit.selectItem();
                      }
                    });
                  },
                  validationText:
                      cubit.selectedVehicleBrand == null && cubit.showValidation
                          ? AppStrings.selectVehicleBrand.tr(context)
                          : null,
                ),
                SizedBox(height: 16.rH(context)),
                //! Vehicle Model
                CustomBottomSheetSelectContainer(
                  enabled: cubit.selectedVehicleBrand != null,
                  svg: Assets.imagesVehicleModel,
                  value: cubit.selectedVehicleModel?.name,
                  title: AppStrings.vehicleModel.tr(context),
                  hint: AppStrings.selectVehicleModel.tr(context),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      isScrollControlled: true,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      builder: (context) => SelectVehicleModelBottomSheet(
                        brandId: cubit.selectedVehicleBrand!.id!,
                      ),
                    ).then((model) {
                      if (model != null && model is VehicleModelModel) {
                        cubit.selectedVehicleModel = model;
                        cubit.selectItem();
                      }
                    });
                  },
                  validationText:
                      cubit.selectedVehicleModel == null && cubit.showValidation
                          ? AppStrings.selectVehicleModel.tr(context)
                          : null,
                ),
                SizedBox(height: 16.rH(context)),
                //! Vehicle Color
                CustomBottomSheetSelectContainer(
                  enabled: true,
                  svg: Assets.imagesVehicleColor,
                  value: cubit.selectedVehicleColor?.name,
                  title: AppStrings.vehicleColor.tr(context),
                  hint: AppStrings.selectVehicleColor.tr(context),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      isScrollControlled: true,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      builder: (context) =>
                          const SelectVehicleColorBottomSheet(),
                    ).then((model) {
                      if (model != null && model is VehicleColorModel) {
                        cubit.selectedVehicleColor = model;
                        cubit.selectItem();
                      }
                    });
                  },
                  validationText:
                      cubit.selectedVehicleColor == null && cubit.showValidation
                          ? AppStrings.selectVehicleColor.tr(context)
                          : null,
                ),
                SizedBox(height: 16.rH(context)),
                //! Plate Number
                AuthTextField(
                  controller: cubit.plateNumberController,
                  title: AppStrings.plateNumber.tr(context),
                  hintText: AppStrings.enterPlateNumber.tr(context),
                  svgIcon: Assets.imagesPlateNumber,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppStrings.enterPlateNumber.tr(context);
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.rH(context)),
                //! Continue Button
                CustomButton(
                  onPressed: () {
                    cubit.validationToggle(true);
                    if (cubit.secondFormKey.currentState!.validate() &&
                        cubit.selectedVehicleType != null &&
                        cubit.selectedVehicleBrand != null &&
                        cubit.selectedVehicleModel != null &&
                        cubit.selectedVehicleColor != null) {
                      cubit.validationToggle(false);
                      cubit.changePage(2);
                    }
                  },
                  title: AppStrings.cOntinue.tr(context),
                ),
                SizedBox(height: 32.rH(context)),
              ],
            ),
          ),
        );
      },
    );
  }
}
