import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_dashed_container.dart';
import '../../../pick_location/presentation/views/choose_location_view.dart';

class ScheduleTripChooseLocations extends StatelessWidget {
  const ScheduleTripChooseLocations({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleTripCubit, ScheduleTripState>(
      builder: (context, state) {
        final cubit = context.read<ScheduleTripCubit>();
        return Stack(
          children: [
            PositionedDirectional(
              start: 10.rW(context),
              top: 12.rH(context),
              bottom: 12.rH(context),
              child: CustomDashedContainer(
                dashWidth: 2.rH(context),
                color: AppColors.primary,
                child: Container(),
              ),
            ),
            Column(
              children: [
                //! Start Location
                Row(
                  children: [
                    SizedBox(height: 10.rH(context)),
                    Container(
                      height: 40.rH(context),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Center(
                        child: CustomSvgPicture(
                          svg: Assets.imagesPinLocation,
                          width: 18.rW(context),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.rW(context)),
                    Expanded(
                      child: CustomSelectContainer(
                        value: cubit.startLocation?.address ??
                            ((cubit.startLocation?.lat != null &&
                                    cubit.startLocation?.lon != null)
                                ? "${cubit.startLocation!.lat}, ${cubit.startLocation!.lon}"
                                : null),
                        hint: AppStrings.enterPickupLocation.tr(context),
                        validationText: cubit.showValidation
                            ? cubit.startLocation == null
                                ? AppStrings.chooseDate.tr(context)
                                : null
                            : null,
                        onTap: () async {
                          navigate(
                            context,
                            ChooseLocationView(
                              startLocation: cubit.startLocation,
                              endLocation: cubit.endLocation,
                              stops: cubit.stops,
                              selectionMode: SelectionMode.pickup,
                            ),
                            then: (value) {
                              cubit.selectLocations(value);
                            },
                          );
                        },
                        icon: Container(),
                        borderColor: AppColors.transparent,
                      ),
                    ),
                  ],
                ),

                //! Divider
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: SizedBox(
                    width: 291.rW(context),
                    child: const CustomDivider(),
                  ),
                ),

                //! Stops
                ...List.generate(
                  cubit.stops.length,
                  (index) {
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 45.rH(context),
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Center(
                                child: CustomSvgPicture(
                                  svg: Assets.imagesEndLocationPin,
                                  width: 20.rW(context),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.rW(context)),
                            Expanded(
                              child: CustomSelectContainer(
                                value: cubit.stops[index].address,
                                hint: AppStrings.chooseYourDestination
                                    .tr(context),
                                borderColor: AppColors.transparent,
                                onTap: () async {
                                  navigate(
                                    context,
                                    ChooseLocationView(
                                      startLocation: cubit.startLocation,
                                      endLocation: cubit.endLocation,
                                      stops: cubit.stops,
                                      selectionMode: SelectionMode.destination,
                                    ),
                                    then: (value) {
                                      cubit.selectLocations(value);
                                    },
                                  );
                                },
                                icon: Container(),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: SizedBox(
                            width: 291.rW(context),
                            child: const CustomDivider(),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                //! End Location
                Row(
                  children: [
                    Container(
                      height: 30.rH(context),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Center(
                        child: CustomSvgPicture(
                          svg: Assets.imagesEndLocationPin,
                          width: 18.rW(context),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.rW(context)),
                    Expanded(
                      child: CustomSelectContainer(
                        value: cubit.endLocation?.address ??
                            ((cubit.endLocation?.lat != null &&
                                    cubit.endLocation?.lon != null)
                                ? "${cubit.endLocation!.lat}, ${cubit.endLocation!.lon}"
                                : null),
                        hint: AppStrings.whereTo.tr(context),
                        validationText: cubit.showValidation
                            ? cubit.endLocation == null
                                ? AppStrings.chooseDate.tr(context)
                                : null
                            : null,
                        onTap: () async {
                          navigate(
                            context,
                            ChooseLocationView(
                              startLocation: cubit.startLocation,
                              endLocation: cubit.endLocation,
                              stops: cubit.stops,
                              selectionMode: SelectionMode.destination,
                            ),
                            then: (value) {
                              cubit.selectLocations(value);
                            },
                          );
                        },
                        icon: Container(),
                        borderColor: AppColors.transparent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
