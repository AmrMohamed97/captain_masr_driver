import 'package:intl/intl.dart';

import '../../../../core/imports/imports.dart';

class BookingSelectDays extends StatelessWidget {
  const BookingSelectDays({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripDetailsCubit, TripDetailsState>(
      builder: (context, state) {
        final cubit = context.read<TripDetailsCubit>();
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
                height: 70.rH(context),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: cubit.daysFromTo.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 12.rW(context));
                  },
                  itemBuilder: (context, index) {
                    final bool selected = cubit.selectedDaysFromTo
                        .contains(cubit.daysFromTo[index]);
                    final bool available = (index != 4);
                    return GestureDetector(
                      onTap: !available ? null : () => cubit.selectDay(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 47.rW(context),
                        height: 70.rH(context),
                        decoration: BoxDecoration(
                          color: !available
                              ? AppColors.greyText.withOpacity(.5)
                              : (selected
                                  ? AppColors.primary.withOpacity(.15)
                                  : AppColors.transparent),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: !available
                                ? AppColors.transparent
                                : AppColors.primary,
                          ),
                        ),
                        child: Column(
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
                            SizedBox(height: 2.rH(context)),
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
