import '../../../../core/imports/imports.dart';

class TotalEarningsCard extends StatelessWidget {
  const TotalEarningsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningsCubit, EarningsState>(
      builder: (context, state) {
        final cubit = context.read<EarningsCubit>();
        return Container(
          width: double.infinity,
          height: 129.rH(context),
          padding: EdgeInsets.symmetric(
            vertical: 14.5.rH(context),
            horizontal: 17.rW(context),
          ),
          margin: EdgeInsets.only(bottom: 26.rH(context)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: AppColors.primaryGradient,
          ),
          child: Column(
            children: [
              //! Header
              Row(
                children: [
                  //! Title
                  Text(
                    AppStrings.totalTrips.tr(context),
                    style: Styles.medium14(context).copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "${cubit.driverSummaryModel?.totalAcceptedTrips ?? 0} ${AppStrings.trips.tr(context)}",
                    style: Styles.bold16(context).copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              //! Total Earnings
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomSvgPicture(
                    svg: Assets.imagesStarCoin,
                    height: 48.rH(context),
                    width: 48.rW(context),
                  ),
                  SizedBox(width: 21.rW(context)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.totalEarning.tr(context),
                          style: Styles.medium14(context).copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 8.rH(context)),
                        FittedBox(
                          child: Text(
                            "${cubit.driverSummaryModel?.totalWithTip ?? 0} ${AppStrings.egp.tr(context)}",
                            style: Styles.bold26white(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 48.rH(context),
                    width: 48.rW(context),
                  ),
                  SizedBox(width: 21.rW(context)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
