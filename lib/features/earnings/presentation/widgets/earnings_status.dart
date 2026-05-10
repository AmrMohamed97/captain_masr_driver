import '../../../../core/imports/imports.dart';

class EarningsStatus extends StatelessWidget {
  const EarningsStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningsCubit, EarningsState>(
      builder: (context, state) {
        final cubit = context.read<EarningsCubit>();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //! Online
            statusCard(
              context,
              svg: Assets.imagesWheel,
              title: cubit.formatMinutes(
                cubit.driverSummaryModel?.totalOnline?.toInt() ?? 0,
                locale: context.read<GlobalCubit>().language,
              ),
              subtitle: AppStrings.online.tr(context),
            ),
            //! Accepted
            statusCard(
              context,
              svg: Assets.imagesAccepted,
              title:
                  "${cubit.driverSummaryModel?.totalAcceptedTrips ?? 0} ${AppStrings.trips.tr(context)}",
              subtitle: AppStrings.accepted.tr(context),
            ),
            //! Cancelled
            statusCard(
              context,
              svg: Assets.imagesCancelled,
              title:
                  "${cubit.driverSummaryModel?.totalCanceledTrips ?? 0} ${AppStrings.trips.tr(context)}",
              subtitle: AppStrings.cancelled.tr(context),
            ),
          ],
        );
      },
    );
  }

  Widget statusCard(
    BuildContext context, {
    required String svg,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: 91.rW(context),
      height: 103.rH(context),
      padding: EdgeInsets.symmetric(horizontal: 8.rW(context)),
      decoration: BoxDecoration(
        color: context.read<GlobalCubit>().isDarkMode
            ? Theme.of(context).cardColor
            : AppColors.primary.withOpacity(.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //! Icon
          Container(
            width: 41.rW(context),
            height: 37.rH(context),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: CustomSvgPicture(svg: svg),
            ),
          ),

          SizedBox(height: 12.rH(context)),

          //! Title
          FittedBox(
            child: Text(
              title,
              style: Styles.medium14(context).copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),

          SizedBox(height: 3.rH(context)),

          //! Subtitle
          FittedBox(
            child: Text(
              subtitle,
              style: Styles.medium12(context).copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
