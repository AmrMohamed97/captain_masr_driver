import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../../home/presentation/views/home_view.dart';
import 'rate_check_box_container.dart';
import 'rate_tip_section.dart';

class RateRideAlertDialog extends StatelessWidget {
  const RateRideAlertDialog({
    super.key,
    this.isDelivery = false,
    required this.tripId,
    this.type,
  });

  final int tripId;
  final bool isDelivery;
  final String? type;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RatingCubit()..isDelivery = isDelivery,
      child: BlocConsumer<RatingCubit, RatingState>(
        listener: (context, state) {
          if (state is RatingSuccessState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.success,
            );
            final globalCubit = context.read<GlobalCubit>();
            globalCubit.scaffoldKey.currentState?.closeDrawer();
            globalCubit.scaffoldKey = GlobalKey<ScaffoldState>();
            globalCubit.navBarController.jumpToTab(0);
            navigateAndRemoveUntil(
              context,
              context.read<GlobalCubit>().isRider
                  ? const BaseView()
                  : const HomeView(),
            );
          }
          if (state is RatingErrorState) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<RatingCubit>();
          return PopScope(
            canPop: false,
            child: CustomModalProgressIndicator(
              inAsyncCall: state is RatingLoadingState,
              child: AlertDialog(
                contentPadding: EdgeInsets.zero,
                elevation: 0,
                content: Container(
                  width: 344.rW(context),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.rW(context),
                    vertical: 19.rH(context),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //! Title
                        Text(
                          isDelivery
                              ? AppStrings.orderDelivered.tr(context)
                              : AppStrings.youHaveArrived.tr(context),
                          style: Styles.semibold21Primary(context),
                        ),
                        SizedBox(height: 16.rH(context)),
                        //! Icon
                        CustomSvgPicture(
                          svg: isDelivery
                              ? Assets.imagesDelivered
                              : Assets.imagesLocationDone,
                          height: 78.rH(context),
                        ),
                        SizedBox(height: 18.rH(context)),
                        //! Subtitle
                        Text(
                          isDelivery
                              ? AppStrings.orderArrivedSuccessfully.tr(context)
                              : AppStrings.howIsYourTrip.tr(context),
                          style: Styles.semibold16Primary(context).copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 29.rH(context)),
                        //! Car Rate
                        if (!isDelivery)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.theCarWas.tr(context),
                                style: Styles.medium16Primary(context).copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                ),
                              ),
                              SizedBox(height: 12.rH(context)),
                              Wrap(
                                direction: Axis.horizontal,
                                spacing: 12.rW(context),
                                runSpacing: 10.rW(context),
                                children: List.generate(
                                  cubit.carRateTitles.length,
                                  (index) {
                                    return RateChecBoxContainer(
                                      selected: cubit.carRateValues[index],
                                      onTap: () => cubit.carRateOnChange(index),
                                      title: cubit.carRateTitles[index]
                                          .tr(context),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 18.rH(context)),
                            ],
                          ),
                        //! Driver Rate
                        if (!isDelivery)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.theDriverWas.tr(context),
                                style: Styles.medium16Primary(context).copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                ),
                              ),
                              SizedBox(height: 12.rH(context)),
                              Wrap(
                                direction: Axis.horizontal,
                                spacing: 12.rW(context),
                                runSpacing: 10.rW(context),
                                children: List.generate(
                                  cubit.driverRateTitles.length,
                                  (index) {
                                    return RateChecBoxContainer(
                                      selected: cubit.driverRateValues[index],
                                      onTap: () =>
                                          cubit.driverRateOnChange(index),
                                      title: cubit.driverRateTitles[index]
                                          .tr(context),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 31.rH(context)),
                            ],
                          ),
                        //! Delivery Rate
                        if (isDelivery)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.theDeliveryWas.tr(context),
                                style: Styles.medium16Primary(context).copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                ),
                              ),
                              SizedBox(height: 12.rH(context)),
                              Wrap(
                                direction: Axis.horizontal,
                                spacing: 12.rW(context),
                                runSpacing: 10.rW(context),
                                children: List.generate(
                                  cubit.deliveryRateTitles.length,
                                  (index) {
                                    return RateChecBoxContainer(
                                      selected: cubit.deliveryRateValues[index],
                                      onTap: () =>
                                          cubit.deliveryRateOnChange(index),
                                      title: cubit.deliveryRateTitles[index]
                                          .tr(context),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                        //! Tip
                        // if (!isDelivery)
                        const RateTipSection(),

                        SizedBox(height: 18.rH(context)),
                        //! Overall
                        Text(
                          AppStrings.overallRating.tr(context),
                          style: Styles.medium16Primary(context).copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        SizedBox(height: 8.rH(context)),
                        RatingStars(
                          onRatingUpdate: (value) =>
                              cubit.ratingOnChange(value),
                        ),

                        //! Note Textfield
                        AnimatedCrossFade(
                          firstChild: Padding(
                            padding: EdgeInsets.only(top: 12.rH(context)),
                            child: CustomTextField(
                              controller: cubit.noteController,
                              hintText: AppStrings.wantToTellUsAboutYourTrip
                                  .tr(context),
                              maxLines: 3,
                            ),
                          ),
                          secondChild: Container(),
                          crossFadeState: cubit.rating != null
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 300),
                        ),

                        SizedBox(height: 20.rH(context)),
                        //! Confirm Button
                        CustomButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            cubit.riderRateTrip(tripId: tripId, type: type);
                          },
                          title: AppStrings.confirm.tr(context),
                        ),
                        SizedBox(height: 16.rH(context)),
                        //! Not Now
                        GestureDetector(
                          onTap: () {
                            final globalCubit = context.read<GlobalCubit>();
                            globalCubit.scaffoldKey.currentState?.closeDrawer();
                            globalCubit.scaffoldKey =
                                GlobalKey<ScaffoldState>();
                            globalCubit.navBarController.jumpToTab(0);
                            navigateAndRemoveUntil(
                              context,
                              context.read<GlobalCubit>().isRider
                                  ? const BaseView()
                                  : const HomeView(),
                            );
                          },
                          child: Text(
                            AppStrings.notNow.tr(context),
                            style: Styles.semibold16Primary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
