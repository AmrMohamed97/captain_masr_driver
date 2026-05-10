import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_refresh_indicator.dart';
import '../../../../core/widgets/custom_shimmer.dart';
import '../../../../core/widgets/custom_tab_bar.dart';
import '../../../driver_trip/presentation/views/driver_trip_view.dart';
import '../../../find_driver/presentation/views/find_driver_view.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';
import '../../../rider_trip/presentation/views/rider_trip_view.dart';
import '../../../schedule_trip/presentation/views/posted_schedule_trip_view.dart';
import '../../../trip_details/presentation/views/trip_details_view.dart';
import '../../data/models/canceled_trip_model.dart';
import 'cancel_trip_alert_dialog.dart';
import 'trip_card.dart';

class TripsBody extends StatelessWidget {
  const TripsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //! Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
          child: CustomAppBar(
            title: AppStrings.trips.tr(context),
            popOnTap: () {
              if (context.read<GlobalCubit>().isDriver) {
                Navigator.pop(context);
              } else {
                context.read<GlobalCubit>().navBarController.jumpToTab(0);
              }
            },
          ),
        ),

        SizedBox(height: 26.rH(context)),

        //! Tap Bar
        BlocBuilder<TripsCubit, TripsState>(
          builder: (context, state) {
            final cubit = context.read<TripsCubit>();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
              child: CustomTapBar(
                selectedTap: cubit.selectedTapBar,
                taps: [
                  AppStrings.ongoing.tr(context),
                  AppStrings.completed.tr(context),
                  AppStrings.scheduled.tr(context),
                  AppStrings.canceled.tr(context),
                ],
                onTap: (tapIndex) {
                  cubit.selectTapBar(tapIndex);
                },
              ),
            );
          },
        ),

        SizedBox(height: 22.rH(context)),

        //! Trips
        BlocBuilder<TripsCubit, TripsState>(
          builder: (context, state) {
            final cubit = context.read<TripsCubit>();
            return Expanded(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                onPageChanged: (page) {
                  cubit.selectTapBar(page);
                },
                itemBuilder: (context, index) {
                  final List<dynamic> trips;
                  switch (cubit.selectedTapBar) {
                    case 0:
                      trips = cubit.ongoingTrips;
                    case 1:
                      trips = cubit.completedTrips;
                    case 2:
                      trips = cubit.scheduledTrips;
                    case 3:
                      trips = cubit.canceledTrips;
                    default:
                      trips = [];
                  }
                  return CustomRefreshIndicator(
                    onRefresh: () => cubit.onRefresh(),
                    child: ListView.builder(
                      controller: cubit.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: trips.length +
                          (state is TripsLoadingState
                              ? trips.isEmpty
                                  ? 4
                                  : 2
                              : 0),
                      padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
                      itemBuilder: (context, index) {
                        //! Shimmer Card
                        if ((state is TripsLoadingState &&
                                index + 1 > trips.length) ||
                            (state is TripsLoadingState && trips.isEmpty)) {
                          return const TripCardLoading();
                        }
                        //! Trip Card
                        return TripCard(
                          model: cubit.selectedTapBar == 3
                              ? (trips[index] as CanceledTripModel).ride!
                              : trips[index] as TripDetailsModel,
                          isOngoing: cubit.selectedTapBar == 0,
                          onTap: () {
                            switch (cubit.selectedTapBar) {
                              case 0:
                                if (cubit.ongoingTrips[index].status ==
                                    "pending") {
                                  navBarNavigate(
                                    context: context,
                                    widget: FindDriverView(
                                      tripDetails: cubit.ongoingTrips[index],
                                      createdAt:
                                          cubit.ongoingTrips[index].createdAt,
                                    ),
                                  );
                                  return;
                                }
                                navBarNavigate(
                                  context: context,
                                  widget: context.read<GlobalCubit>().isRider
                                      ? RiderTripView(
                                          tripId: cubit
                                                  .ongoingTrips[index].rideId ??
                                              0,
                                          isDelivery: cubit.ongoingTrips[index]
                                                  .tripType ==
                                              "delivery",
                                          isShareRide: cubit.ongoingTrips[index]
                                                  .tripType ==
                                              "share",
                                        )
                                      : DriverTripView(
                                          tripId: cubit
                                                  .ongoingTrips[index].rideId ??
                                              0,
                                          isDeliveryTrip: cubit
                                                  .ongoingTrips[index]
                                                  .tripType ==
                                              "delivery",
                                          isShareTrip: cubit.ongoingTrips[index]
                                                  .tripType ==
                                              "share",
                                        ),
                                );
                                break;
                              case 1:
                                navBarNavigate(
                                  context: context,
                                  widget: TripDetailsView(
                                    tripId: (trips[index] as TripDetailsModel)
                                            .rideId ??
                                        0,
                                    isAccepted: cubit.selectedTapBar == 2,
                                    isCompleted: cubit.selectedTapBar == 1,
                                    isClassic:
                                        (trips[index] as TripDetailsModel)
                                                .tripType ==
                                            "classic trip",
                                    isGroup: false,
                                    isShare: false,
                                    isDelivery:
                                        (trips[index] as TripDetailsModel)
                                                .tripType ==
                                            "delivery",
                                    isScheduled: cubit.selectedTapBar == 2,
                                  ),
                                );
                              case 2:
                                navBarNavigate(
                                  context: context,
                                  widget: PostedScheduleTripView(
                                    trip: trips[index],
                                  ),
                                );
                              default:
                                return;
                            }
                          },
                          cancelOnTrip: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  const CancelTripAlertDialog(),
                            ).then((value) {
                              if (value == true) {
                                cubit.cancelTrip(tripId: trips[index].id);
                              }
                            });
                          },
                        );
                      },
                    ),
                  );
                  // : Padding(
                  //     padding:
                  //         EdgeInsets.symmetric(horizontal: 56.rW(context)),
                  //     child: Column(
                  //       mainAxisSize: MainAxisSize.max,
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         const CustomSvgPicture(
                  //           svg: Assets.imagesEmptyBox,
                  //         ),
                  //         SizedBox(height: 22.rH(context)),
                  //         Text(
                  //           AppStrings.youHaveNotCanceledRideYet
                  //               .tr(context),
                  //           style: Styles.regular18(context).copyWith(
                  //             color: Theme.of(context)
                  //                 .textTheme
                  //                 .bodyLarge
                  //                 ?.color,
                  //           ),
                  //           overflow: TextOverflow.clip,
                  //           textAlign: TextAlign.center,
                  //         ),
                  //       ],
                  //     ),
                  //   );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class TripCardLoading extends StatelessWidget {
  const TripCardLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.rH(context)),
      padding: EdgeInsets.symmetric(
        vertical: 16.rH(context),
        horizontal: 16.rW(context),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2.rH(context)),
            blurRadius: 11,
            color: AppColors.black.withOpacity(.14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomShimmer(
                h: 46.rH(context),
                w: 46.rH(context),
                borderRadius: 50,
              ),
              SizedBox(width: 8.rW(context)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShimmer(
                    h: 14.rH(context),
                    w: 150.rH(context),
                    borderRadius: 8,
                  ),
                  SizedBox(height: 8.rH(context)),
                  CustomShimmer(
                    h: 14.rH(context),
                    w: 75.rH(context),
                    borderRadius: 8,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.rH(context)),
          CustomShimmer(
            h: 14.rH(context),
            w: 150.rW(context),
            borderRadius: 8,
          ),
          SizedBox(height: 8.rH(context)),
          CustomShimmer(
            h: 14.rH(context),
            w: double.infinity,
            borderRadius: 8,
          ),
          SizedBox(height: 16.rH(context)),
          CustomShimmer(
            h: 14.rH(context),
            w: 150.rW(context),
            borderRadius: 8,
          ),
          SizedBox(height: 8.rH(context)),
          CustomShimmer(
            h: 14.rH(context),
            w: double.infinity,
            borderRadius: 8,
          ),
        ],
      ),
    );
  }
}
