import '../../../../core/imports/imports.dart';
import '../../../trips/presentation/views/trips_view.dart';
import '../cubit/home_cubit.dart';
import 'home_trip_card.dart';

class HomeRecentRides extends StatelessWidget {
  const HomeRecentRides({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        return cubit.recentTrips.isNotEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //! Title & See All
                    Row(
                      children: [
                        //! Title
                        Text(
                          AppStrings.recentRides.tr(context),
                          style: Styles.semibold18Primary(context).copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const Spacer(),
                        //! See All
                        UnderLineText(
                          text: AppStrings.seeAll.tr(context),
                          onTap: () {
                            context.read<GlobalCubit>().isRider
                                ? context
                                    .read<GlobalCubit>()
                                    .navBarController
                                    .jumpToTab(1)
                                : navigate(
                                    context,
                                    const TripsView(),
                                  );
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 16.rH(context)),

                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cubit.recentTrips.length,
                      itemBuilder: (context, index) {
                        return HomeTripCard(
                          model: cubit.recentTrips[index],
                        );
                      },
                    ),
                  ],
                ),
              )
            : Container();
      },
    );
  }
}
