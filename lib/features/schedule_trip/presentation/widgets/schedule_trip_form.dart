import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_dashed_container.dart';
import 'schedule_trip_choose_date.dart';
import 'schedule_trip_choose_loctions.dart';
import 'schedule_trip_choose_vehicle_type.dart';
import 'schedule_trip_map_section.dart';
import 'schedule_trip_select_days.dart';
import 'schedule_trip_select_start_and_return_hour.dart';

class ScheduleTripForm extends StatelessWidget {
  const ScheduleTripForm({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final bool isRider = context.read<GlobalCubit>().isRider;
    return BlocBuilder<ScheduleTripCubit, ScheduleTripState>(
      builder: (context, state) {
        final cubit = context.read<ScheduleTripCubit>();
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 16.rW(context),
            ),
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 28.rH(context)),

                    //! Start & End Points & Map
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.rW(context)),
                      child:   Column(
                        children: [
                          //! Start & End Location
                          const ScheduleTripChooseLocations(),

                          //! Map Section
                          ScheduleTripMap(
                            latLng: cubit.startLocation?.lat != null &&
                                    cubit.startLocation?.lon != null
                                ? LatLng(
                                    cubit.startLocation!.lat!,
                                    cubit.startLocation!.lon!,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),

                    //! Divider
                    SizedBox(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          //! Dashed Line
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 24.rH(context),
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 300.rW(context),
                                child: CustomDashedContainer(
                                  dashWidth: 5,
                                  color: AppColors.greyText.withOpacity(.25),
                                  child: const SizedBox(),
                                ),
                              ),
                            ),
                          ),
                          ...List.generate(
                            2,
                            (index) {
                              return PositionedDirectional(
                                top: 0,
                                bottom: 0,
                                start: index == 0 ? -12.rH(context) : null,
                                end: index == 1 ? -12.rH(context) : null,
                                child: Center(
                                  child: Container(
                                    height: 24.rH(context),
                                    width: 24.rH(context),
                                    decoration: BoxDecoration(
                                      color:
                                          context.read<GlobalCubit>().isDarkMode
                                              ? Theme.of(context).cardColor
                                              : AppColors.grey5,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.rW(context)),
                      child: Column(
                        children: [
                          //! Vehicle Category
                          const ScheduleTripChooseAvailableSeats(),

                          //! Date
                          const ScheduleTripChooseDate(),

                          SizedBox(height: 24.rH(context)),
                          // ! Select Days for rider
                          if (cubit.fromDate != null &&
                              cubit.toDate != null &&
                              isRider)
                            const ScheduleTripSelectDays(),

                          //! Going & Returning
                          // if (!isRider)
                          //   Row(
                          //     children: [
                          //       CustomSvgPicture(
                          //         svg: Assets.imagesRefresh,
                          //         height: 23.rH(context),
                          //       ),
                          //       SizedBox(width: 8.rW(context)),
                          //       Text(
                          //         AppStrings.goingAndReturning.tr(context),
                          //         style: Styles.medium14(context).copyWith(
                          //           color: Theme.of(context)
                          //               .textTheme
                          //               .bodyLarge
                          //               ?.color,
                          //         ),
                          //       ),
                          //       const Spacer(),
                          //       CustomSwitch(
                          //         value: cubit.goingAndReturning,
                          //         onChanged: (value) {
                          //           cubit.goingAndReturningToggle();
                          //         },
                          //       ),
                          //     ],
                          //   ),

                          // if (!isRider) SizedBox(height: 24.rH(context)),

                          //! Time
                          const ScheduleTripSelectStartAndReturnHour(),

                          // if (!isRider) SizedBox(height: 16.rH(context)),

                          //! Available Seats
                          // if (!isRider) const ScheduleTripChooseSeatsNumber(),

                          SizedBox(height: 26.rH(context)),

                          //! Cost Per Seat
                          // if (cubit.costPerSeat != null && !isRider)
                          //   const CostPerSeatContainer(
                          //     value: 530,
                          //   ),

                          //! Female
                          // if (isRider)
                          //   CustomSwitchListTile(
                          //     svg: Assets.imagesFemale,
                          //     title: AppStrings.female.tr(context),
                          //     value: cubit.isFemale,
                          //     onChanged: (value) =>
                          //         cubit.femaleOptionToggle(value),
                          //   ),

                          // if (isRider) SizedBox(height: 16.rH(context)),

                          //! Baby Carriage
                          // if (isRider)
                          //   CustomSwitchListTile(
                          //     svg: Assets.imagesBabyCarriage,
                          //     title: AppStrings.babyCarriage.tr(context),
                          //     value: cubit.isBabyCarriage,
                          //     onChanged: (value) =>
                          //         cubit.babyCarrigageOptionToggle(value),
                          //   ),

                          // if (isRider) SizedBox(height: 24.rH(context)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.rH(context)),
            ],
          ),
        );
      },
    );
  }
}

class CustomSwitchListTile extends StatelessWidget {
  const CustomSwitchListTile({
    super.key,
    required this.svg,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String svg, title;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomSvgPicture(
          svg: svg,
          height: 22.rH(context),
        ),
        SizedBox(width: 10.rW(context)),
        Text(
          title,
          style: Styles.regular14(context).copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const Spacer(),
        CustomSwitch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
