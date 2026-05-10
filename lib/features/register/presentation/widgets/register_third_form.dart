import 'package:image_picker/image_picker.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_date_picker_dialog.dart';
import '../../../../core/widgets/custom_image_field.dart';
import '../cubit/register_cubit.dart';

class RegisterThirdForm extends StatelessWidget {
  const RegisterThirdForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();
        return SingleChildScrollView(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              //! Notional ID
              CustomImageField(
                image: cubit.nationalIdImage,
                onTap: () async {
                  final XFile? image = await pickImageBottomSheet(context);
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
                    cubit.nationalIdImage == null && cubit.showValidation
                        ? AppStrings.addNationalId.tr(context)
                        : null,
              ),
              SizedBox(height: 16.rH(context)),
              //! Notional ID Expiry
              CustomSelectContainer(
                svg: Assets.imagesDateExpireSvg,
                svgColor: AppColors.primary,
                borderColor: AppColors.transparent,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                value: cubit.nationalIdExpiry?.toString().split(" ")[0],
                title: AppStrings.nationalIdExpiry.tr(context),
                hint: AppStrings.nationalIdExpiry.tr(context),
                onTap: () async {
                  cubit.nationalIdExpiry = await customDatePickerDialog(
                    context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 100),
                  );
                  cubit.selectItem();
                },
                validationText:
                    cubit.nationalIdExpiry == null && cubit.showValidation
                        ? AppStrings.selectNationalIdExpiry.tr(context)
                        : null,
              ),
              SizedBox(height: 16.rH(context)),
              //! Driver License
              CustomImageField(
                image: cubit.driverLicenseImage,
                onTap: () async {
                  final XFile? image = await pickImageBottomSheet(context);
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
                validationText:
                    cubit.driverLicenseImage == null && cubit.showValidation
                        ? AppStrings.addDriversLicense.tr(context)
                        : null,
              ),
              SizedBox(height: 16.rH(context)),
              //! Driver License Expiry
              CustomSelectContainer(
                svg: Assets.imagesDateExpireSvg,
                svgColor: AppColors.primary,
                borderColor: AppColors.transparent,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                value: cubit.driverLicenseImageExpiry?.toString().split(" ")[0],
                title: AppStrings.driversLicenseExpiry.tr(context),
                hint: AppStrings.driversLicenseExpiry.tr(context),
                onTap: () async {
                  cubit.driverLicenseImageExpiry = await customDatePickerDialog(
                    context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 100),
                  );
                  cubit.selectItem();
                },
                validationText: cubit.driverLicenseImageExpiry == null &&
                        cubit.showValidation
                    ? AppStrings.selectDriversLicenseExpiry.tr(context)
                    : null,
              ),
              SizedBox(height: 16.rH(context)),
              //! Vehicle License
              CustomImageField(
                image: cubit.vehicleLicenseImage,
                onTap: () async {
                  final XFile? image = await pickImageBottomSheet(context);
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
                validationText:
                    cubit.vehicleLicenseImage == null && cubit.showValidation
                        ? AppStrings.addVehicleLicense.tr(context)
                        : null,
              ),
              SizedBox(height: 16.rH(context)),
              //! Vehicle License Expiry
              CustomSelectContainer(
                svg: Assets.imagesDateExpireSvg,
                svgColor: AppColors.primary,
                borderColor: AppColors.transparent,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                value:
                    cubit.vehicleLicenseImageExpiry?.toString().split(" ")[0],
                title: AppStrings.vehicleLicenseExpiry.tr(context),
                hint: AppStrings.vehicleLicenseExpiry.tr(context),
                onTap: () async {
                  cubit.vehicleLicenseImageExpiry =
                      await customDatePickerDialog(
                    context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 100),
                  );
                  cubit.selectItem();
                },
                validationText: cubit.vehicleLicenseImageExpiry == null &&
                        cubit.showValidation
                    ? AppStrings.selectVehicleLicenseExpiry.tr(context)
                    : null,
              ),
              SizedBox(height: 32.rH(context)),
              //! Continue Button
              CustomButton(
                onPressed: () {
                  cubit.validationToggle(true);
                  if (cubit.nationalIdImage != null &&
                      cubit.driverLicenseImage != null &&
                      cubit.vehicleLicenseImage != null &&
                      cubit.nationalIdExpiry != null &&
                      cubit.driverLicenseImageExpiry != null &&
                      cubit.vehicleLicenseImageExpiry != null) {
                    cubit.validationToggle(false);
                    cubit.driverRegister();
                  }
                },
                title: AppStrings.signUp.tr(context),
              ),
              SizedBox(height: 32.rH(context)),
            ],
          ),
        );
      },
    );
  }
}
