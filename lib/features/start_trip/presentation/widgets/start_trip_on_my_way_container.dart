import '../../../../core/imports/imports.dart';
import '../../../schedule_trip/presentation/views/schedule_trip_view.dart';
import '../cubit/start_trip_cubit/start_trip_cubit.dart';
import 'start_trip_choose_start_and_end_locations.dart';

class StartTripOnMyWayContainer extends StatelessWidget {
  const StartTripOnMyWayContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartTripCubit, StartTripState>(
      builder: (context, state) {
        final cubit = context.read<StartTripCubit>();
        return Column(
          children: [
            //! Title
            Text(
              AppStrings.tripDetails.tr(context),
              style: Styles.semibold16Primary(context).copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),

            SizedBox(height: 16.rH(context)),

            const StartTripChooseStartAndEndLocations(),

            SizedBox(height: 16.rH(context)),

            //! Seats Number
            if (cubit.seats.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 16.rH(context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.selectAvailableSeats.tr(context),
                      style: Styles.regular14(context).copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    SizedBox(height: 8.rH(context)),
                    Row(
                      children: [
                        Image.asset(
                          Assets.imagesCarSeats,
                          height: 120.rH(context),
                          width: 120.rW(context),
                          fit: BoxFit.contain,
                          color: null,
                        ),
                        Expanded(
                          child: Column(
                            children: List.generate(
                              cubit.seats.length,
                              (index) => Padding(
                                padding: EdgeInsets.only(
                                  bottom: 8.rH(context),
                                ),
                                child: GestureDetector(
                                  onTap: () => cubit.selectSeat(index),
                                  child: Row(
                                    children: [
                                      CustomCheckBox(
                                        value: cubit.selectedSeatsIds
                                            .contains(cubit.seats[index].id),
                                        onTap: () => cubit.selectSeat(index),
                                      ),
                                      SizedBox(width: 8.rW(context)),
                                      Text(
                                        "(${index + 1}) ${cubit.seats[index].name ?? "??"}",
                                        style:
                                            Styles.regular14(context).copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

            SizedBox(height: 16.rH(context)),

            //! Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      cubit.driverPostShareTrip();
                      // navigateReplacement(
                      //   context,
                      //   DriverTripView(
                      //     isOnMyWay: true,
                      //     riderPosition: LatLng(
                      //       cubit.endLocation!.lat ?? 0,
                      //       cubit.endLocation!.lon ?? 0,
                      //     ),
                      //     driverPosition: LatLng(
                      //       cubit.startLocation!.lat ?? 0,
                      //       cubit.startLocation!.lon ?? 0,
                      //     ),
                      //   ),
                      // );
                    },
                    title: AppStrings.startTrip.tr(context),
                    enabled: cubit.startLocation != null &&
                        cubit.endLocation != null &&
                        cubit.selectedSeatsIds.isNotEmpty,
                  ),
                ),
                SizedBox(width: 8.rW(context)),
                //! Later Button
                CustomButton(
                  onPressed: () {
                    navigateReplacement(
                      context,
                      const ScheduleTripView(),
                    );
                  },
                  title: AppStrings.later.tr(context),
                  widgth: 77.rW(context),
                  color: AppColors.transparent,
                  textColor: AppColors.primary,
                  borderColor: AppColors.primary,
                  padding: EdgeInsets.zero,
                  icon: const CustomSvgPicture(
                    svg: Assets.imagesTime,
                  ),
                  iconEndPadding: 6.rW(context),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
