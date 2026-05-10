import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_refresh_indicator.dart';
import '../../../trips/presentation/widgets/trips_body.dart';
import '../cubit/available_share_trip_cubit/available_share_trips_cubit.dart';
import 'available_share_trip_card.dart';

class AvailableShareTripBody extends StatelessWidget {
  const AvailableShareTripBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
      child: Column(
        children: [
          //! Header
          CustomAppBar(
            title: AppStrings.ongoingTrips.tr(context),
          ),

          SizedBox(height: 29.rH(context)),

          //! Trips
          BlocBuilder<AvailableShareTripsCubit, AvailableShareTripsState>(
            builder: (context, state) {
              final cubit = context.read<AvailableShareTripsCubit>();
              return Expanded(
                child: CustomRefreshIndicator(
                  onRefresh: () {
                    cubit.pagination = null;
                    cubit.currentPage = 0;
                    cubit.trips.clear();
                    return cubit.riderSearchShareRides();
                  },
                  child: cubit.trips.isEmpty &&
                          state is! GetAvailableShareTripsLoadingState
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 48.rH(context)),
                            child: Text(
                              AppStrings.noTripsAvailable.tr(context),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: AppColors.grey,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: cubit.scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 36.rH(context)),
                          itemCount: cubit.trips.length +
                              (state is GetAvailableShareTripsLoadingState
                                  ? cubit.trips.isEmpty
                                      ? 4
                                      : 2
                                  : 0),
                          itemBuilder: (context, index) {
                            if ((state is GetAvailableShareTripsLoadingState &&
                                    index + 1 > cubit.trips.length) ||
                                (state is GetAvailableShareTripsLoadingState &&
                                    cubit.trips.isEmpty)) {
                              return const TripCardLoading();
                            }
                            return AvaibleShareTripCard(
                              length: cubit.shareTripData.seatsIds.length,
                              model: cubit.trips[index],
                              sendRequestOnTap: (selectedSeats) {
                                print(selectedSeats);
                                print(cubit.shareTripData.seatsIds);
                                cubit.riderRequestShareTrip(
                                  availableSeatIds: selectedSeats,
                                  id: cubit.trips[index].id ?? 0,
                                );
                              },
                            );
                          },
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
