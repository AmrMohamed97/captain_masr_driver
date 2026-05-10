import '../../../../core/imports/imports.dart';
import '../../../pick_location/presentation/views/choose_location_view.dart';
import '../cubit/start_trip_cubit/start_trip_cubit.dart';

class StartTripChooseStartAndEndLocations extends StatelessWidget {
  const StartTripChooseStartAndEndLocations({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartTripCubit, StartTripState>(
      builder: (context, state) {
        final cubit = context.read<StartTripCubit>();
        return Row(
          children: [
            CustomSvgPicture(
              svg: Assets.imagesFromToSvg,
              height: 82.rH(context),
            ),
            SizedBox(width: 8.rW(context)),
            Expanded(
              child: Column(
                children: [
                  //! Start
                  CustomSelectContainer(
                    value: cubit.startLocation?.address ??
                        ((cubit.startLocation?.lat != null &&
                                cubit.startLocation?.lon != null)
                            ? "${cubit.startLocation!.lat}, ${cubit.startLocation!.lon}"
                            : null),
                    hint: AppStrings.enterPickupLocation.tr(context),
                    onTap: cubit.details == null
                        ? () {
                            navigate(
                              context,
                              ChooseLocationView(
                                startLocation: cubit.startLocation,
                                endLocation: cubit.endLocation,
                                stops: cubit.stops,
                                selectionMode: SelectionMode.pickup,
                              ),
                              then: (value) {
                                FocusScope.of(context).unfocus();
                                cubit.selectLocations(value);
                              },
                            );
                          }
                        : () {},
                    icon: Container(),
                  ),

                  if (cubit.stops.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 8.rH(context)),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          "+${cubit.stops.length} ${AppStrings.stops.tr(context)} ...",
                          style: Styles.regular14(context).copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),

                  SizedBox(height: 8.rH(context)),

                  //! Destination
                  CustomSelectContainer(
                    value: cubit.endLocation?.address ??
                        ((cubit.endLocation?.lat != null &&
                                cubit.endLocation?.lon != null)
                            ? "${cubit.endLocation!.lat}, ${cubit.endLocation!.lon}"
                            : null),
                    hint: AppStrings.whereTo.tr(context),
                    onTap: cubit.details == null
                        ? () {
                            navigate(
                              context,
                              ChooseLocationView(
                                startLocation: cubit.startLocation,
                                endLocation: cubit.endLocation,
                                stops: cubit.stops,
                                selectionMode: SelectionMode.destination,
                              ),
                              then: (value) {
                                FocusScope.of(context).unfocus();
                                cubit.selectLocations(value);
                              },
                            );
                          }
                        : () {},
                    icon: Container(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
