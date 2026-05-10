import '../../../../core/imports/imports.dart';
import 'booking_select_days.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripDetailsCubit, TripDetailsState>(
      builder: (context, state) {
        final cubit = context.read<TripDetailsCubit>();
        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 18.rH(context)),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              SizedBox(height: 19.rH(context)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
                child: Column(
                  children: [
                    //! Title
                    Text(
                      AppStrings.booking.tr(context),
                      style: Styles.medium16Primary(context),
                    ),

                    SizedBox(height: 12.rH(context)),

                    //! Seats
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        AppStrings.howManySeatsDoYouNeed.tr(context),
                        style: Styles.medium14(context).copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),

                    SizedBox(height: 21.rH(context)),

                    //! Seats Number
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //! Decrease
                        GestureDetector(
                          onTap: () => cubit.changeSeatsNum(0),
                          child: CircleAvatar(
                            radius: 17.5.rH(context),
                            backgroundColor: cubit.seatsNum == 1
                                ? AppColors.greyText.withOpacity(.5)
                                : AppColors.primary,
                            child: Icon(
                              Icons.remove,
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                        ),
                        //! Number
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.rW(context),
                          ),
                          child: Text(
                            cubit.seatsNum.toString(),
                            style: Styles.medium32white(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        //! Increase
                        GestureDetector(
                          onTap: () => cubit.changeSeatsNum(1),
                          child: CircleAvatar(
                            radius: 17.5.rH(context),
                            backgroundColor: cubit.seatsNum == 4
                                ? AppColors.greyText.withOpacity(.5)
                                : AppColors.primary,
                            child: Icon(
                              Icons.add,
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 22.rH(context)),

                    //! Days
                    const BookingSelectDays(),

                    //! Going & Returning
                    Row(
                      children: [
                        CustomSvgPicture(
                          svg: Assets.imagesRefresh,
                          height: 24.rH(context),
                        ),
                        SizedBox(width: 8.rW(context)),
                        Text(
                          AppStrings.goingAndReturning.tr(context),
                          style: Styles.medium14(context).copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const Spacer(),
                        CustomSwitch(
                          value: cubit.goingAndReturning,
                          onChanged: (value) => cubit.goingAndReturningToggle(),
                        ),
                      ],
                    ),

                    SizedBox(height: 21.rH(context)),
                  ],
                ),
              ),
              //! Total Cost
              CostRow(
                cost: 530,
                costBeforeDiscount: 560,
                title: AppStrings.totalCost.tr(context),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
