import 'package:intl/intl.dart';

import '../../../../core/imports/imports.dart';

class ScheduleTripSelectDays extends StatefulWidget {
  const ScheduleTripSelectDays({super.key});

  @override
  State<ScheduleTripSelectDays> createState() => _ScheduleTripSelectDaysState();
}

class _ScheduleTripSelectDaysState extends State<ScheduleTripSelectDays> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<ScheduleTripCubit>();
    if (cubit.fromDate != null && cubit.toDate != null) {
      cubit.selectedDaysFromTo.clear();
      cubit.selectedDaysFromTo.addAll(cubit.daysFromTo);
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleTripCubit, ScheduleTripState>(
      builder: (context, state) {
        final cubit = context.read<ScheduleTripCubit>();
        return Padding(
          padding: EdgeInsets.only(bottom: 26.rH(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.selectTheDaysYouWant.tr(context),
                style: Styles.medium14(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              SizedBox(height: 8.rH(context)),
              SizedBox(
                height: 80.rH(context),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: cubit.daysFromTo.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 12.rW(context));
                  },
                  itemBuilder: (context, index) {
                    final bool selected = cubit.selectedDaysFromTo
                        .contains(cubit.daysFromTo[index]);
                    return GestureDetector(
                      onTap: () => cubit.selectDay(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 47.rW(context),
                        height: 80.rH(context),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary.withOpacity(.15)
                              : AppColors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary,
                          ),
                        ),
                        child: Column(
                          spacing: 2.rH(context),
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 24.rH(context),
                              child: FittedBox(
                                child: Text(
                                  cubit.daysFromTo[index].day.toString(),
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
                            SizedBox(
                              height: 14.rH(context),
                              child: FittedBox(
                                child: Text(
                                  DateFormat('EEE')
                                      .format(cubit.daysFromTo[index]),
                                  style: Styles.semibold18Primary(context)
                                      .copyWith(
                                    color: AppColors.greyText,
                                  ),
                                ),
                              ),
                            ),
                            Icon(
                              selected
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
