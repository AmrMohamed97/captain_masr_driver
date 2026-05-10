import '../../../../core/imports/imports.dart';

class ScheduleTripChooseAvailableSeats extends StatelessWidget {
  const ScheduleTripChooseAvailableSeats({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleTripCubit, ScheduleTripState>(
      builder: (context, state) {
        final cubit = context.read<ScheduleTripCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.selectSeatsYouWant.tr(context),
              style: Styles.regular14(context).copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            SizedBox(height: 8.rH(context)),
            Row(
              children: [
                Image.asset(
                  Assets.imagesCarSeats,
                  height: 120.rH(context),
                  width: 120.rW(context),
                  fit: BoxFit.contain,
                  color: null,
                ),
                Expanded(
                  child: cubit.seats.isEmpty
                      ? const CustomLoadingIndicator()
                      : Column(
                          children: List.generate(
                            cubit.seats.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                bottom: 8.rH(context),
                              ),
                              child: GestureDetector(
                                onTap: () => cubit.selectSeat(index),
                                child: Row(
                                  children: [
                                    CustomCheckBox(
                                      value: cubit.selectedSeatsIds
                                          .contains(cubit.seats[index].id),
                                      onTap: () => cubit.selectSeat(index),
                                    ),
                                    SizedBox(width: 8.rW(context)),
                                    Text(
                                      "(${index + 1}) ${cubit.seats[index].name ?? "??"}",
                                      style: Styles.regular14(context).copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                )
              ],
            ),
            SizedBox(height: 26.rH(context)),
          ],
        );
      },
    );
  }
}
