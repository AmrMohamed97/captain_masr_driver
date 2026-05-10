import '../../../../core/imports/imports.dart';

class ScheduleTripChooseSeatsNumber extends StatelessWidget {
  const ScheduleTripChooseSeatsNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleTripCubit, ScheduleTripState>(
      builder: (context, state) {
        final cubit = context.read<ScheduleTripCubit>();
        return Row(
          children: [
            //! Icon
            CustomSvgPicture(
              svg: Assets.imagesSeat,
              height: 23.5.rH(context),
            ),
            SizedBox(width: 8.rW(context)),
            //! Title
            Text(
              AppStrings.availableSeats.tr(context),
              style: Styles.medium14(context).copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const Spacer(),
            //! Decrease
            GestureDetector(
              onTap: () => cubit.decreaseSeatNumber(),
              child: CircleAvatar(
                radius: 10.rH(context),
                backgroundColor:
                    cubit.seatsNumber == 1 ? AppColors.grey : AppColors.primary,
                child: Icon(
                  Icons.remove,
                  color: AppColors.white,
                  size: 16.rH(context),
                ),
              ),
            ),
            //! Number
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.rW(context)),
              child: Text(
                cubit.seatsNumber.toString(),
                style: Styles.medium16Primary(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            //! Increase
            GestureDetector(
              onTap: () => cubit.increaseSeatNumber(),
              child: CircleAvatar(
                radius: 10.rH(context),
                backgroundColor: AppColors.primary,
                child: Icon(
                  Icons.add,
                  color: AppColors.white,
                  size: 16.rH(context),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
