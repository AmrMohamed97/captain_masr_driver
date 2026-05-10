import '../../../../core/imports/imports.dart';

class MyVehicleForm extends StatelessWidget {
  const MyVehicleForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyVehicleCubit, MyVehicleState>(
      builder: (context, state) {
        final cubit = context.read<MyVehicleCubit>();
        return Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              //! Vehicle Type
              MyVehicleFormCard(
                title: AppStrings.vehicleType.tr(context),
                value: cubit.driverVehicleModel?.vehicleType?.name,
                svg: Assets.imagesVehicleType,
              ),

              //! Vehicle Brand
              MyVehicleFormCard(
                title: AppStrings.vehicleBrand.tr(context),
                value: cubit.driverVehicleModel?.vehicleBrand?.name,
                svg: Assets.imagesVehicleBrand,
              ),

              //! Vehicle Model
              MyVehicleFormCard(
                title: AppStrings.vehicleModel.tr(context),
                value: cubit.driverVehicleModel?.vehicleModel?.name,
                svg: Assets.imagesVehicleModel,
              ),

              //! Vehicle Color
              MyVehicleFormCard(
                title: AppStrings.vehicleColor.tr(context),
                value: cubit.driverVehicleModel?.vehicleColor?.name,
                svg: Assets.imagesVehicleColor,
              ),

              //! Plat Number
              MyVehicleFormCard(
                title: AppStrings.plateNumber.tr(context),
                value: cubit.driverVehicleModel?.plateNumber,
                svg: Assets.imagesPlateNumber,
              ),

              //! Vehicle License
              Text(
                AppStrings.vehicleLicense.tr(context),
                style: Styles.regular14(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              SizedBox(height: 8.rH(context)),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      cubit.driverVehicleModel?.vehicleLicenseImage ?? "",
                      height: 200.rH(context),
                      errorBuilder: (context, error, stackTrace) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.rH(context)),
                        child: const Icon(
                          Icons.error,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.rH(context)),
              //! Vehicle License Expiry
              MyVehicleFormCard(
                title: AppStrings.vehicleLicenseExpiry.tr(context),
                value: cubit.driverVehicleModel?.vehicleLicenseExpiry,
                svg: Assets.imagesDateExpireSvg,
              ),
            ],
          ),
        );
      },
    );
  }
}

class MyVehicleFormCard extends StatelessWidget {
  const MyVehicleFormCard({
    super.key,
    required this.title,
    required this.value,
    required this.svg,
  });

  final String? title, value, svg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.rH(context)),
      child: CustomSelectContainer(
        title: title,
        hint: title,
        value: value,
        onTap: () {},
        svg: svg,
        svgColor: AppColors.primary,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        borderColor: AppColors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
        icon: Container(),
        height: 51.rH(context),
      ),
    );
  }
}
