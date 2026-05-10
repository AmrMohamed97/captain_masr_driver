import 'package:intl/intl.dart';

import '../../../../core/imports/imports.dart';

class EarningsCalender extends StatelessWidget {
  const EarningsCalender({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningsCubit, EarningsState>(
      builder: (context, state) {
        final cubit = context.read<EarningsCubit>();
        return AnimatedCrossFade(
          firstChild: SizedBox(
            height: 86.rH(context),
            child: ListView(
              controller: cubit.scrollController,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              children: List.generate(
                cubit.filterType == "Weekly"
                    ? 7
                    : cubit.filterType == "Monthly"
                        ? DateTime(
                                int.parse(cubit.year),
                                cubit.months
                                        .indexWhere((e) => e == cubit.month) +
                                    2,
                                0)
                            .day
                        : 12,
                (index) {
                  final bool isSelected = cubit.filterType == "Weekly"
                      ? (cubit.selectedDay?.day ==
                          cubit.currentWeekStart.add(Duration(days: index)).day)
                      : cubit.filterType == "Monthly"
                          ? (cubit.selectedDay?.day == index + 1)
                          : (cubit.selectedMonth?.month == index + 1);
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        if (cubit.filterType == "Weekly") {
                          cubit.selectDay(
                            cubit.currentWeekStart.add(Duration(days: index)),
                          );
                          cubit.getDriverSummary();
                        }
                        if (cubit.filterType == "Monthly") {
                          cubit.selectDay(DateTime.parse(
                              "${cubit.year}-${(cubit.months.indexWhere((e) => e == cubit.month) + 1).toString().padLeft(2, "0")}-${(index + 1).toString().padLeft(2, "0")}"));
                          cubit.getDriverSummary();
                        }

                        if (cubit.filterType == "Yearly") {
                          cubit.selectMonth(DateTime.parse(
                              "${cubit.year}-${(index + 1).toString().padLeft(2, "0")}-01"));
                          cubit.getDriverSummary();
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 70.rH(context),
                        width: 47.rW(context),
                        padding:
                            EdgeInsets.symmetric(horizontal: 12.rW(context)),
                        margin: EdgeInsets.symmetric(horizontal: 3.rW(context)),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(.5)
                              : AppColors.transparent,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: AppColors.black.withOpacity(.03),
                            ),
                          ],
                        ),
                        child: cubit.filterType == "Weekly"
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 24.rW(context),
                                    height: 24.rH(context),
                                    child: FittedBox(
                                      child: Text(
                                        cubit.currentWeekStart
                                            .add(Duration(days: index))
                                            .day
                                            .toString(),
                                        style: Styles.semibold18Primary(context)
                                            .copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.color,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.rH(context)),
                                  SizedBox(
                                    height: 14.rH(context),
                                    width: 24.rW(context),
                                    child: FittedBox(
                                      child: Text(
                                        DateFormat('EEE').format(cubit
                                            .currentWeekStart
                                            .add(Duration(days: index))),
                                        style:
                                            Styles.semibold12(context).copyWith(
                                          color: AppColors.greyText,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : cubit.filterType == "Monthly"
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 24.rH(context),
                                          width: 24.rW(context),
                                          child: FittedBox(
                                            child: Text(
                                              "${index + 1}",
                                              style: Styles.semibold18Primary(
                                                      context)
                                                  .copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.color,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 2.rH(context)),
                                        SizedBox(
                                          height: 14.rH(context),
                                          width: 24.rW(context),
                                          child: FittedBox(
                                            child: Text(
                                              DateFormat('EEE').format(DateTime
                                                      .parse(
                                                          "${cubit.year}-${(cubit.months.indexWhere((e) => e == cubit.month) + 1).toString().padLeft(2, "0")}-01")
                                                  .add(Duration(days: index))),
                                              style: Styles.semibold12(context)
                                                  .copyWith(
                                                color: AppColors.greyText,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Center(
                                    child: FittedBox(
                                      child: Text(
                                        cubit.months[index][0] +
                                            cubit.months[index][1] +
                                            cubit.months[index][2],
                                        style:
                                            Styles.semibold12(context).copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.color,
                                        ),
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          secondChild: Container(),
          crossFadeState: cubit.filterType == "All"
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}
