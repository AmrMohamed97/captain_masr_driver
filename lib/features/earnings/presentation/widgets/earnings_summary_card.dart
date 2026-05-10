import '../../../../core/imports/imports.dart';

class EarningsSummaryCard extends StatelessWidget {
  const EarningsSummaryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16.rW(context),
        vertical: 16.rH(context),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2.rH(context)),
            color: AppColors.black.withOpacity(.10),
            blurRadius: 20,
          ),
        ],
      ),
      child: BlocBuilder<EarningsCubit, EarningsState>(
        builder: (context, state) {
          final cubit = context.read<EarningsCubit>();
          return Column(
            children: [
              //! Title
              Text(
                AppStrings.tripsSummary.tr(context),
                style: Styles.medium16Primary(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),

              SizedBox(height: 15.rH(context)),

              //! Classic Trips
              customListTile(
                context,
                trips: "${cubit.driverSummaryModel?.totalClasicTrips ?? 0}",
                title: AppStrings.classicTrips.tr(context),
                earnings:
                    "${cubit.driverSummaryModel?.totalClasicEarning ?? 0}",
              ),
              //! Share Trips
              customListTile(
                context,
                trips: "${cubit.driverSummaryModel?.totalShareTrips ?? 0}",
                title: AppStrings.shareTrips.tr(context),
                earnings: "${cubit.driverSummaryModel?.totalShareEarning ?? 0}",
              ),
              //! Group Trips
              customListTile(
                context,
                trips: "${cubit.driverSummaryModel?.totalGroupTrips ?? 0}",
                title: AppStrings.groupTrips.tr(context),
                earnings: "${cubit.driverSummaryModel?.totalGroupEarning ?? 0}",
              ),
              //! School Trips
              customListTile(
                context,
                trips: "${cubit.driverSummaryModel?.totalDeliveryTrips ?? 0}",
                title: AppStrings.deliveryTrips.tr(context),
                earnings:
                    "${cubit.driverSummaryModel?.totalDeliveryEarning ?? 0}",
              ),
            ],
          );
        },
      ),
    );
  }

  Widget customListTile(
    BuildContext context, {
    required String trips,
    required String title,
    required String earnings,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.rH(context)),
      child: Row(
        children: [
          Container(
            width: 38.rW(context),
            height: 34.rH(context),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: FittedBox(
                child: Text(
                  trips,
                  style: Styles.semibold16Primary(context).copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.rW(context)),
          Text(
            title,
            style: Styles.medium14(context).copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const Spacer(),
          Text(
            "$earnings ${AppStrings.egp.tr(context)}",
            style: Styles.semibold16Primary(context),
          ),
        ],
      ),
    );
  }
}
