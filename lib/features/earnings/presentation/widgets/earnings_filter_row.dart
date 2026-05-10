import '../../../../core/imports/imports.dart';

class EarningsFilterRow extends StatelessWidget {
  const EarningsFilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningsCubit, EarningsState>(
      builder: (context, state) {
        final cubit = context.read<EarningsCubit>();
        return Row(
          children: [
            if (cubit.filterType != "All")
              GestureDetector(
                onTap: () {
                  cubit.shiftWeek(false);
                  cubit.getDriverSummary();
                },
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.primary,
                  size: 14.rH(context),
                ),
              ),
            if (cubit.filterType != "All")
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.rW(context)),
                child: SizedBox(
                  width: cubit.filterType == "Weekly" ? 150.rW(context) : null,
                  child: cubit.filterType == "Weekly"
                      ? FittedBox(
                          child: Text(
                            "${cubit.formatDate(cubit.currentWeekStart)} - ${cubit.formatDate(cubit.currentWeekEnd)}",
                            style: Styles.medium16Primary(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        )
                      : Text(
                          cubit.filterType == "Monthly"
                              ? "${cubit.month} ${cubit.year}"
                              : cubit.year,
                          style: Styles.medium16Primary(context).copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                ),
              ),
            if (cubit.canGoForward() != false && cubit.filterType != "All")
              GestureDetector(
                onTap: () {
                  cubit.shiftWeek(true);
                  cubit.getDriverSummary();
                },
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.primary,
                  size: 14.rH(context),
                ),
              ),
            const Spacer(),
            SizedBox(
              width: 120.rW(context),
              child: CustomDropDownButton(
                value: AppStrings.all.tr(context),
                items: [
                  AppStrings.all.tr(context),
                  AppStrings.weekly.tr(context),
                  AppStrings.monthly.tr(context),
                  AppStrings.yearly.tr(context),
                ],
                onChanged: (val) {
                  final String value = val == AppStrings.all.tr(context)
                      ? "All"
                      : val == AppStrings.weekly.tr(context)
                          ? "Weekly"
                          : val == AppStrings.monthly.tr(context)
                              ? "Monthly"
                              : "Yearly";
                  cubit.filterTypeToggle(value);
                  cubit.getDriverSummary();
                },
                padding: EdgeInsets.symmetric(
                  vertical: 6.rH(context),
                  horizontal: 8.rW(context),
                ),
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              ),
            ),
          ],
        );
      },
    );
  }
}
