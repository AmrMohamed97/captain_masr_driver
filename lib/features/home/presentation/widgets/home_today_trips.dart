import '../../../../core/imports/imports.dart';
import '../cubit/home_cubit.dart';

class HomeTodayTrips extends StatelessWidget {
  const HomeTodayTrips({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 344.rW(context),
        height: 59.rH(context),
        child: Stack(
          children: [
            //! Background Color
            Container(
              width: 344.rW(context),
              height: 59.rH(context),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.1),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            //! Background Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                Assets.imagesTodayTripsBackground,
                width: 344.rW(context),
                height: 59.rH(context),
                fit: BoxFit.cover,
              ),
            ),
            //! Content
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    final cubit = context.read<HomeCubit>();
                    return Row(
                      children: [
                        //! Car Icon
                        Container(
                          height: 37.rH(context),
                          width: 41.rW(context),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: CustomSvgPicture(
                              svg: Assets.imagesCarSvg,
                              height: 16.rH(context),
                            ),
                          ),
                        ),
                        SizedBox(width: 7.rW(context)),
                        //! Trips & Icon
                        Expanded(
                          child: Container(
                            height: 37.rH(context),
                            padding: EdgeInsets.symmetric(
                              horizontal: 9.rW(context),
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                //! Number
                                Text(
                                  BlocProvider.of<GlobalCubit>(context).driverTodaySummary?.tripCount
                                          ?.toString() ??
                                      "0",
                                  style: Styles.semibold24Primary(context),
                                ),
                                SizedBox(width: 10.rW(context)),
                                //! Title
                                Text(
                                  AppStrings.tripsToday.tr(context),
                                  style: Styles.medium15(context).copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                ),
                                const Spacer(),
                                //! Points
                                Text(
                                  BlocProvider.of<GlobalCubit>(context).driverTodaySummary?.grandTotal
                                          ?.floorToDouble()
                                          .toString() ??
                                      "0",
                                  style: Styles.semibold24Primary(context),
                                ),
                                SizedBox(width: 8.rW(context)),
                                CustomSvgPicture(
                                  svg: Assets.imagesStarCoin,
                                  height: 14.rH(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
