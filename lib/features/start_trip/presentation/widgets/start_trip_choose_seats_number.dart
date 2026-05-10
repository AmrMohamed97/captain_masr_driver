import '../../../../core/imports/imports.dart';
import '../cubit/start_trip_cubit/start_trip_cubit.dart';

class StartTripChooseSeatsNumber extends StatelessWidget {
  const StartTripChooseSeatsNumber({
    super.key,
    this.title,
  });

  final String? title;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartTripCubit, StartTripState>(
      builder: (context, state) {
        final cubit = context.read<StartTripCubit>();
        return Row(
          children: [
            CustomSvgPicture(
              svg: Assets.imagesSeat,
              height: 24.rH(context),
            ),
            SizedBox(width: 10.rW(context)),
            Text(
              title ?? AppStrings.seatsNeeded.tr(context),
              style: Styles.regular14(context).copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const Spacer(),
            //! Decrease Buton
            GestureDetector(
              onTap: () => cubit.changeSeatsNum(increase: false),
              child: CircleAvatar(
                radius: 10.rH(context),
                backgroundColor: cubit.seatsNum == 1
                    ? AppColors.greyText.withOpacity(.5)
                    : AppColors.primary,
                child: Icon(
                  Icons.remove,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  size: 14.rH(context),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.rW(context),
              ),
              child: Text(
                cubit.seatsNum.toString(),
                style: Styles.medium16Primary(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            //! Increase Buton
            GestureDetector(
              onTap: () => cubit.changeSeatsNum(increase: true),
              child: CircleAvatar(
                radius: 10.rH(context),
                backgroundColor: cubit.seatsNum == 4
                    ? AppColors.greyText.withOpacity(.5)
                    : AppColors.primary,
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  size: 14.rH(context),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
