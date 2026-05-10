import 'package:image_picker/image_picker.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_date_picker_dialog.dart';
import '../../../../core/widgets/custom_image_field.dart';
import '../../../../core/widgets/custom_shimmer.dart';
import '../../../my_vehicle/data/models/vehicle_brand_model.dart';
import '../../../my_vehicle/data/models/vehicle_color_model.dart';
import '../../../my_vehicle/data/models/vehicle_model_model.dart';
import '../../../my_vehicle/data/models/vehicle_type_model.dart';
import '../../../my_vehicle/presentation/widgets/custom_bottom_sheet_select_container.dart';
import '../../../my_vehicle/presentation/widgets/select_vehicle_brand_bottom_sheet.dart';
import '../../../my_vehicle/presentation/widgets/select_vehicle_color_bottom_sheet.dart';
import '../../../my_vehicle/presentation/widgets/select_vehicle_model_bottom_sheet.dart';
import '../../../my_vehicle/presentation/widgets/select_vehicle_type_bottom_sheet.dart';
import '../cubit/become_rider_or_driver_cubit.dart';

class BecomeRiderOrDriverBody extends StatelessWidget {
  const BecomeRiderOrDriverBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BecomeRiderOrDriverCubit, BecomeRiderOrDriverState>(
      builder: (context, state) {
        final cubit = context.read<BecomeRiderOrDriverCubit>();
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
          child: Column(
            children: [
              //! Header
              CustomAppBar(
                title: cubit.pageIndex == 1
                    ? AppStrings.vehicleDetails.tr(context)
                    : cubit.pageIndex == 2
                        ? AppStrings.licenseAndDocument.tr(context)
                        : "",
                popOnTap: () {
                  if (cubit.pageIndex == 0) {
                    Navigator.pop(context);
                  } else {
                    cubit.changePage(cubit.pageIndex - 1);
                  }
                },
              ),

              //! Indicator
              if (context.read<GlobalCubit>().isRider &&
                  context
                          .read<GlobalCubit>()
                          .userModel
                          ?.isConvertedToDriverBefore !=
                      true)
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.rH(context),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: 45.rW(context),
                          height: 6.rH(context),
                          margin:
                              EdgeInsets.symmetric(horizontal: 4.rW(context)),
                          decoration: BoxDecoration(
                            color: cubit.pageIndex >= index
                                ? AppColors.primary
                                : AppColors.grey2,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              Expanded(
                child: PageView.builder(
                  controller: cubit.pageController,
                  itemCount: 3,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Column(
                          children: [
                            SizedBox(height: 32.rH(context)),
                            //! Logo
                            CircleAvatar(
                              radius: 48.rH(context),
                              backgroundColor:
                                  AppColors.primary.withOpacity(0.1),
                              child: !context.read<GlobalCubit>().isRider
                                  ? CustomSvgPicture(
                                      svg: Assets.imagesPerson,
                                      height: 48.rH(context),
                                    )
                                  : CustomSvgPicture(
                                      svg: Assets.imagesDriverMode,
                                      height: 48.rH(context),
                                    ),
                            ),
                            SizedBox(height: 16.rH(context)),
                            //! Title
                            Text(
                              context.read<GlobalCubit>().isRider
                                  ? AppStrings.switchToDriverMode.tr(context)
                                  : AppStrings.switchToRiderMode.tr(context),
                              style: Styles.semibold24Primary(context).copyWith(
                                color: AppColors.primary,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                            ),
                            SizedBox(height: 8.rH(context)),
                            //! Subtitle
                            Text(
                              context.read<GlobalCubit>().isRider
                                  ? AppStrings.startEarningAsDriver.tr(context)
                                  : AppStrings.bookRidesAndGetWhereYouNeedToGo
                                      .tr(context),
                              style: Styles.semibold16Primary(context).copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                            ),
                            const Spacer(),
                            CustomButton(
                              onPressed: () {
                                if (context.read<GlobalCubit>().isRider) {
                                  if (context
                                          .read<GlobalCubit>()
                                          .userModel
                                          ?.isConvertedToDriverBefore ==
                                      true) {
                                    cubit.becomeDriver();
                                  } else {
                                    cubit.changePage(1);
                                  }
                                } else {
                                  cubit.becomeRider();
                                }
                              },
                              title: AppStrings.cOntinue.tr(context),
                            ),
                            SizedBox(height: 24.rH(context)),
                          ],
                        );
                      case 1:
                        return SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          child: Form(
                            key: cubit.firstFormKey,
                            child: Column(
                              children: [
                                SizedBox(height: 16.rH(context)),
                                //! Vehicle Categories
                                SizedBox(
                                  height: cubit.vehicleCategories.isNotEmpty
                                      ? 80.rH(context)
                                      : 40.rH(context),
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    children: List.generate(
                                      cubit.vehicleCategories.isNotEmpty
                                          ? cubit.vehicleCategories.length
                                          : 4,
                                      (index) {
                                        return Padding(
                                          padding: EdgeInsetsDirectional.only(
                                            end: 8.rW(context),
                                          ),
                                          child: cubit.vehicleCategories.isEmpty
                                              ? CustomShimmer(
                                                  w: 67.rW(context),
                                                  h: 50.rH(context),
                                                  borderRadius: 6,
                                                )
                                              : Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        cubit.selectedVehicleCategoryId =
                                                            cubit
                                                                .vehicleCategories[
                                                                    index]
                                                                .id;
                                                        cubit.selectedVehicleType =
                                                            null;
                                                        cubit.selectedVehicleBrand =
                                                            null;
                                                        cubit.selectedVehicleModel =
                                                            null;
                                                        cubit.selectItem();
                                                      },
                                                      child: AnimatedContainer(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        width: 67.rW(context),
                                                        height: 50.rH(context),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 8.rW(
                                                                    context),
                                                                vertical: 8.rH(
                                                                    context)),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          border: Border.all(
                                                            width: 2,
                                                            color: cubit
                                                                        .vehicleCategories[
                                                                            index]
                                                                        .id ==
                                                                    cubit
                                                                        .selectedVehicleCategoryId
                                                                ? AppColors
                                                                    .primary
                                                                : AppColors
                                                                    .transparent,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              offset: Offset(
                                                                  0,
                                                                  2.rH(
                                                                      context)),
                                                              blurRadius: 7,
                                                              color: Theme.of(
                                                                      context)
                                                                  .shadowColor,
                                                            ),
                                                          ],
                                                        ),
                                                        child: Image.network(
                                                          cubit
                                                                  .vehicleCategories[
                                                                      index]
                                                                  .logo ??
                                                              "",
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return const Icon(
                                                              Icons.error,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: 8.rH(context)),
                                                    Text(
                                                      cubit
                                                              .vehicleCategories[
                                                                  index]
                                                              .name ??
                                                          "",
                                                      style: Styles.regular12(
                                                              context)
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
                                SizedBox(height: 16.rH(context)),
                                //! Vehicle Type
                                CustomBottomSheetSelectContainer(
                                  enabled:
                                      cubit.selectedVehicleCategoryId != null,
                                  svg: Assets.imagesVehicleType,
                                  value: cubit.selectedVehicleType?.name,
                                  title: AppStrings.vehicleType.tr(context),
                                  hint:
                                      AppStrings.selectVehicleType.tr(context),
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      showDragHandle: true,
                                      isScrollControlled: true,
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      builder: (context) =>
                                          SelectVehicleTypeBottomSheet(
                                        vehicleCategoryId:
                                            cubit.selectedVehicleCategoryId!,
                                      ),
                                    ).then((model) {
                                      if (model != null &&
                                          model is VehicleTypeModel) {
                                        cubit.selectedVehicleType = model;
                                        cubit.selectedVehicleBrand = null;
                                        cubit.selectedVehicleModel = null;
                                        cubit.selectItem();
                                      }
                                    });
                                  },
                                  validationText: cubit.selectedVehicleType ==
                                              null &&
                                          cubit.showValidation
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
                                  hint:
                                      AppStrings.selectVehicleBrand.tr(context),
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      showDragHandle: true,
                                      isScrollControlled: true,
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      builder: (context) =>
                                          SelectVehicleBrandBottomSheet(
                                        typeId: cubit.selectedVehicleType!.id!,
                                      ),
                                    ).then((model) {
                                      if (model != null &&
                                          model is VehicleBrandModel) {
                                        cubit.selectedVehicleBrand = model;
                                        cubit.selectedVehicleModel = null;
                                        cubit.selectItem();
                                      }
                                    });
                                  },
                                  validationText:
                                      cubit.selectedVehicleBrand == null &&
                                              cubit.showValidation
                                          ? AppStrings.selectVehicleBrand
                                              .tr(context)
                                          : null,
                                ),
                                SizedBox(height: 16.rH(context)),
                                //! Vehicle Model
                                CustomBottomSheetSelectContainer(
                                  enabled: cubit.selectedVehicleBrand != null,
                                  svg: Assets.imagesVehicleModel,
                                  value: cubit.selectedVehicleModel?.name,
                                  title: AppStrings.vehicleModel.tr(context),
                                  hint:
                                      AppStrings.selectVehicleModel.tr(context),
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      showDragHandle: true,
                                      isScrollControlled: true,
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      builder: (context) =>
                                          SelectVehicleModelBottomSheet(
                                        brandId:
                                            cubit.selectedVehicleBrand!.id!,
                                      ),
                                    ).then((model) {
                                      if (model != null &&
                                          model is VehicleModelModel) {
                                        cubit.selectedVehicleModel = model;
                                        cubit.selectItem();
                                      }
                                    });
                                  },
                                  validationText:
                                      cubit.selectedVehicleModel == null &&
                                              cubit.showValidation
                                          ? AppStrings.selectVehicleModel
                                              .tr(context)
                                          : null,
                                ),
                                SizedBox(height: 16.rH(context)),
                                //! Vehicle Color
                                CustomBottomSheetSelectContainer(
                                  enabled: true,
                                  svg: Assets.imagesVehicleColor,
                                  value: cubit.selectedVehicleColor?.name,
                                  title: AppStrings.vehicleColor.tr(context),
                                  hint:
                                      AppStrings.selectVehicleColor.tr(context),
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      showDragHandle: true,
                                      isScrollControlled: true,
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      builder: (context) =>
                                          const SelectVehicleColorBottomSheet(),
                                    ).then((model) {
                                      if (model != null &&
                                          model is VehicleColorModel) {
                                        cubit.selectedVehicleColor = model;
                                        cubit.selectItem();
                                      }
                                    });
                                  },
                                  validationText:
                                      cubit.selectedVehicleColor == null &&
                                              cubit.showValidation
                                          ? AppStrings.selectVehicleColor
                                              .tr(context)
                                          : null,
                                ),
                                SizedBox(height: 16.rH(context)),
                                //! Plate Number
                                AuthTextField(
                                  controller: cubit.plateNumberController,
                                  title: AppStrings.plateNumber.tr(context),
                                  hintText:
                                      AppStrings.enterPlateNumber.tr(context),
                                  svgIcon: Assets.imagesPlateNumber,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return AppStrings.enterPlateNumber
                                          .tr(context);
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16.rH(context)),
                                //! Continue Button
                                CustomButton(
                                  onPressed: () {
                                    cubit.validationToggle(true);
                                    if (cubit.firstFormKey.currentState!
                                            .validate() &&
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
                      case 2:
                        return SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          child: Form(
                            key: cubit.secondFormKey,
                            child: Column(
                              children: [
                                //! ID Number
                                AuthTextField(
                                  controller: cubit.idNumber,
                                  title: AppStrings.idNumber.tr(context),
                                  hintText:
                                      AppStrings.enterYourIdNumber.tr(context),
                                  svgIcon: Assets.imagesNationalId,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return AppStrings.enterYourIdNumber
                                          .tr(context);
                                    }
                                    return null;
                                  },
                                ),
                                //! Notional ID
                                CustomImageField(
                                  image: cubit.nationalIdImage,
                                  onTap: () async {
                                    final XFile? image =
                                        await pickImageBottomSheet(context);
                                    if (image != null) {
                                      cubit.nationalIdImage = image;
                                      cubit.pickImage();
                                    }
                                  },
                                  title: AppStrings.nationalID.tr(context),
                                  prefixSvg: Assets.imagesNationalId,
                                  deleteOnTap: () {
                                    cubit.nationalIdImage = null;
                                    cubit.pickImage();
                                  },
                                  validationText:
                                      cubit.nationalIdImage == null &&
                                              cubit.showValidation
                                          ? AppStrings.addNationalId.tr(context)
                                          : null,
                                ),
                                SizedBox(height: 16.rH(context)),
                                //! Notional ID Expiry
                                CustomSelectContainer(
                                  svg: Assets.imagesDateExpireSvg,
                                  svgColor: AppColors.primary,
                                  borderColor: AppColors.transparent,
                                  fillColor: Theme.of(context)
                                      .inputDecorationTheme
                                      .fillColor,
                                  value: cubit.nationalIdExpiry
                                      ?.toString()
                                      .split(" ")[0],
                                  title:
                                      AppStrings.nationalIdExpiry.tr(context),
                                  hint: AppStrings.nationalIdExpiry.tr(context),
                                  onTap: () async {
                                    cubit.nationalIdExpiry =
                                        await customDatePickerDialog(
                                      context,
                                      firstDate: DateTime.now(),
                                      lastDate:
                                          DateTime(DateTime.now().year + 100),
                                    );
                                    cubit.selectItem();
                                  },
                                  validationText:
                                      cubit.nationalIdExpiry == null &&
                                              cubit.showValidation
                                          ? AppStrings.selectNationalIdExpiry
                                              .tr(context)
                                          : null,
                                ),
                                SizedBox(height: 16.rH(context)),
                                //! Driver License
                                CustomImageField(
                                  image: cubit.driverLicenseImage,
                                  onTap: () async {
                                    final XFile? image =
                                        await pickImageBottomSheet(context);
                                    if (image != null) {
                                      cubit.driverLicenseImage = image;
                                      cubit.pickImage();
                                    }
                                  },
                                  title: AppStrings.driversLicense.tr(context),
                                  prefixSvg: Assets.imagesVehicleColor,
                                  deleteOnTap: () {
                                    cubit.driverLicenseImage = null;
                                    cubit.pickImage();
                                  },
                                  validationText: cubit.driverLicenseImage ==
                                              null &&
                                          cubit.showValidation
                                      ? AppStrings.addDriversLicense.tr(context)
                                      : null,
                                ),
                                SizedBox(height: 16.rH(context)),
                                //! Driver License Expiry
                                CustomSelectContainer(
                                  svg: Assets.imagesDateExpireSvg,
                                  svgColor: AppColors.primary,
                                  borderColor: AppColors.transparent,
                                  fillColor: Theme.of(context)
                                      .inputDecorationTheme
                                      .fillColor,
                                  value: cubit.driverLicenseImageExpiry
                                      ?.toString()
                                      .split(" ")[0],
                                  title: AppStrings.driversLicenseExpiry
                                      .tr(context),
                                  hint: AppStrings.driversLicenseExpiry
                                      .tr(context),
                                  onTap: () async {
                                    cubit.driverLicenseImageExpiry =
                                        await customDatePickerDialog(
                                      context,
                                      firstDate: DateTime.now(),
                                      lastDate:
                                          DateTime(DateTime.now().year + 100),
                                    );
                                    cubit.selectItem();
                                  },
                                  validationText:
                                      cubit.driverLicenseImageExpiry == null &&
                                              cubit.showValidation
                                          ? AppStrings
                                              .selectDriversLicenseExpiry
                                              .tr(context)
                                          : null,
                                ),
                                SizedBox(height: 16.rH(context)),
                                //! Vehicle License
                                CustomImageField(
                                  image: cubit.vehicleLicenseImage,
                                  onTap: () async {
                                    final XFile? image =
                                        await pickImageBottomSheet(context);
                                    if (image != null) {
                                      cubit.vehicleLicenseImage = image;
                                      cubit.pickImage();
                                    }
                                  },
                                  title: AppStrings.vehicleLicense.tr(context),
                                  prefixSvg: Assets.imagesVehicleLicense,
                                  deleteOnTap: () {
                                    cubit.vehicleLicenseImage = null;
                                    cubit.pickImage();
                                  },
                                  validationText: cubit.vehicleLicenseImage ==
                                              null &&
                                          cubit.showValidation
                                      ? AppStrings.addVehicleLicense.tr(context)
                                      : null,
                                ),
                                SizedBox(height: 16.rH(context)),
                                //! Vehicle License Expiry
                                CustomSelectContainer(
                                  svg: Assets.imagesDateExpireSvg,
                                  svgColor: AppColors.primary,
                                  borderColor: AppColors.transparent,
                                  fillColor: Theme.of(context)
                                      .inputDecorationTheme
                                      .fillColor,
                                  value: cubit.vehicleLicenseImageExpiry
                                      ?.toString()
                                      .split(" ")[0],
                                  title: AppStrings.vehicleLicenseExpiry
                                      .tr(context),
                                  hint: AppStrings.vehicleLicenseExpiry
                                      .tr(context),
                                  onTap: () async {
                                    cubit.vehicleLicenseImageExpiry =
                                        await customDatePickerDialog(
                                      context,
                                      firstDate: DateTime.now(),
                                      lastDate:
                                          DateTime(DateTime.now().year + 100),
                                    );
                                    cubit.selectItem();
                                  },
                                  validationText:
                                      cubit.vehicleLicenseImageExpiry == null &&
                                              cubit.showValidation
                                          ? AppStrings
                                              .selectVehicleLicenseExpiry
                                              .tr(context)
                                          : null,
                                ),
                                SizedBox(height: 32.rH(context)),
                                //! Continue Button
                                CustomButton(
                                  onPressed: () {
                                    cubit.validationToggle(true);
                                    if (cubit.secondFormKey.currentState!
                                            .validate() &&
                                        cubit.nationalIdImage != null &&
                                        cubit.driverLicenseImage != null &&
                                        cubit.vehicleLicenseImage != null &&
                                        cubit.nationalIdExpiry != null &&
                                        cubit.driverLicenseImageExpiry !=
                                            null &&
                                        cubit.vehicleLicenseImageExpiry !=
                                            null) {
                                      cubit.validationToggle(false);
                                      cubit.becomeDriver();
                                    }
                                  },
                                  title: AppStrings.confirm.tr(context),
                                ),
                                SizedBox(height: 32.rH(context)),
                              ],
                            ),
                          ),
                        );
                      default:
                        return Container();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
