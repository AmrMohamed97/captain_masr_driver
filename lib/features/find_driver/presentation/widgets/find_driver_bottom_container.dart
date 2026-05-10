import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_bottom_dragable_container.dart';
import '../../../preferences/presentation/widgets/preferences_alert_dialog.dart';
import '../../../trips/presentation/widgets/cancel_trip_alert_dialog.dart';

class FindDriverBottomContainer extends StatelessWidget {
  const FindDriverBottomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FindDriverCubit, FindDriverState>(
      builder: (context, state) {
        final cubit = context.read<FindDriverCubit>();
        return CustomBottomDragableContainer(
          startExpanded: false,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 16.rH(context)),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              //! Drag Handler
              Center(
                child: Container(
                  width: 74.rW(context),
                  height: 4.rH(context),
                  margin: EdgeInsets.symmetric(vertical: 11.rH(context)),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                  ),
                ),
              ),

              //! First Container
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 18.rW(context),
                  vertical: 17.rH(context),
                ),
                margin: EdgeInsets.only(bottom: 10.rH(context)),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //! Title
                    Text(
                      AppStrings.yourTrip.tr(context),
                      style: Styles.semibold16Primary(context).copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    SizedBox(height: 18.rH(context)),
                    //! Distance & Duration
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          CustomSvgPicture(
                            svg: Assets.imagesPinLocation,
                            color: AppColors.greyText,
                            height: 13.rH(context),
                          ),
                          SizedBox(width: 6),
                          Text(
                            AppStrings.distance.tr(context),
                            style: Styles.regular14(context).copyWith(
                              color: AppColors.greyText,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            "${cubit.tripDetails?.distanceKm ?? "??"} ${AppStrings.km.tr(context)}",
                            style: Styles.semibold14Primary(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          // const Spacer(),
                          SizedBox(width: 12),
                          CustomSvgPicture(
                            svg: Assets.imagesTime,
                            color: AppColors.greyText,
                            height: 13.rH(context),
                          ),
                          SizedBox(width: 6),
                          Text(
                            AppStrings.duration.tr(context),
                            style: Styles.regular14(context).copyWith(
                              color: AppColors.greyText,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            "${cubit.tripDetails?.timeMinutes ?? "??"} ${AppStrings.min.tr(context)}",
                            style: Styles.semibold14Primary(context).copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.rH(context)),
                    //! Estimated Cost
                    Row(
                      children: [
                        CustomSvgPicture(
                          svg: Assets.imagesCashPaper,
                          height: 19.rH(context),
                        ),
                        SizedBox(width: 6.rW(context)),
                        Text(
                          AppStrings.estimatedCost.tr(context),
                          style: Styles.regular14(context).copyWith(
                            color: AppColors.greyText,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${cubit.tripDetails?.price ?? "??"} ${AppStrings.egp.tr(context)}",
                          style: Styles.semibold16Primary(context).copyWith(
                            color: AppColors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //! Second Container
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: 20.rH(context),
                  horizontal: 18.rW(context),
                ),
                margin: EdgeInsets.only(bottom: 16.rH(context)),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //! Start & End Point
                    StartAndEndPoint(
                      startValue: cubit.tripDetails?.pickupAddress ?? "??",
                      endValue: cubit.tripDetails?.dropoffAddress ?? "??",
                    ),
                    SizedBox(height: 16.rH(context)),
                    //! Prefernces
                    if (!cubit.isDelivery)
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => PreferencesAlertDialog(
                              canEdit: false,
                              preferencesModel: cubit.tripDetails?.preferences,
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            CustomSvgPicture(
                              svg: Assets.imagesPreferences,
                              height: 24.rH(context),
                            ),
                            SizedBox(width: 6.rW(context)),
                            Text(
                              AppStrings.preferences.tr(context),
                              style: Styles.regular14(context).copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 16.rH(context)),
                    //! Cancel  ButtonRequest
                    CustomButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const CancelTripAlertDialog(),
                        ).then((value) {
                          if (value == true) {
                            cubit.cancelTrip();
                          }
                        });
                      },
                      title: AppStrings.cancelRequest.tr(context),
                      color: AppColors.transparent,
                      borderColor: AppColors.red,
                      textColor: AppColors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
