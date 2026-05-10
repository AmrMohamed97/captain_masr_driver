import '../../../../core/imports/imports.dart';
import '../../../find_riders/presentation/views/find_riders_view.dart';
import '../cubit/home_cubit.dart';
import 'home_current_location.dart';
import 'home_driver_preferences.dart';
import 'home_header.dart';
import 'home_recent_rides.dart';
import 'home_services.dart';
import 'home_today_trips.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isRider = context.read<GlobalCubit>().isRider;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                //! Header & Slider
                const HomeHeader(),

                SizedBox(height: 18.rH(context)),

                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      //! Trips Today (For Driver)
                      if (!isRider) const HomeTodayTrips(),

                      //! Services (For Rider)
                      if (isRider) const HomeServices(),

                      SizedBox(height: 20.rH(context)),

                      //! Current Location (For Rider)
                      if (isRider) const HomeCurrentLocation(),

                      //! Preferces (For Driver)
                      if (!isRider) const HomeDriverPreferences(),

                      SizedBox(height: 20.rH(context)),

                      //! Recent Rides
                      const HomeRecentRides(),

                      SizedBox(height: 24.rH(context)),

                      if (!isRider) SizedBox(height: 120.rH(context)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //! Driver Online Float Button
          if (!isRider)
            Positioned(
              bottom: 16.rH(context),
              left: 0,
              right: 0,
              child: BlocBuilder<GlobalCubit, GlobalState>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      context.read<GlobalCubit>().driverOnlineToggle();
                      if (context.read<GlobalCubit>().driverOnline) {
                        navigate(
                            context,
                            FindRidersView(
                                acceptedTripTypeIds:
                                    context.read<HomeCubit>().driverTripTypes));
                      }
                    },
                    child: CircleAvatar(
                      radius: 61.rH(context),
                      backgroundColor: context.read<GlobalCubit>().isDarkMode
                          ? Theme.of(context).cardColor.withOpacity(.5)
                          : context.read<GlobalCubit>().driverOnline
                              ? AppColors.red.withOpacity(.05)
                              : AppColors.primary.withOpacity(.05),
                      child: CircleAvatar(
                        radius: 51.rH(context),
                        backgroundColor: context.read<GlobalCubit>().isDarkMode
                            ? Theme.of(context).cardColor.withOpacity(.75)
                            : context.read<GlobalCubit>().driverOnline
                                ? AppColors.red.withOpacity(.15)
                                : AppColors.primary.withOpacity(.15),
                        child: CircleAvatar(
                          radius: 41.rH(context),
                          backgroundColor:
                              context.read<GlobalCubit>().driverOnline
                                  ? AppColors.red
                                  : AppColors.primary,
                          child: BlocBuilder<GlobalCubit, GlobalState>(
                            builder: (context, state) {
                              return Text(
                                context.read<GlobalCubit>().driverOnline
                                    ? AppStrings.online.tr(context)
                                    : AppStrings.offline.tr(context),
                                style: Styles.medium16Primary(context).copyWith(
                                  color: AppColors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
