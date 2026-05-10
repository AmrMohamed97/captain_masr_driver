
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/imports/imports.dart';
import '../../../start_trip/data/models/rider_share_trip_data_model.dart';
import '../../../start_trip/presentation/views/available_share_trips.dart';
import '../../../wallet/presentation/views/payment_methods_view.dart';

class ShareTripEstimationBottomSheet extends StatefulWidget {
  const ShareTripEstimationBottomSheet({super.key});

  @override
  State<ShareTripEstimationBottomSheet> createState() =>
      _ShareTripEstimationBottomSheetState();
}

class _ShareTripEstimationBottomSheetState
    extends State<ShareTripEstimationBottomSheet> {
  @override
  initState() {
    super.initState();
    final cubit = context.read<ScheduleTripCubit>();
    cubit.calculateEstimated();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleTripCubit, ScheduleTripState>(
      builder: (context, state) {
        final cubit = context.read<ScheduleTripCubit>();
        return state is CalculateShareEstimatedErrorState
            ? Container(
                padding: EdgeInsets.only(
                  bottom:
                      MediaQuery.of(context).viewInsets.bottom + 20.rH(context),
                  left: 20.rW(context),
                  right: 20.rW(context),
                  top: 24.rH(context),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline,
                          color: AppColors.red, size: 60.rW(context)),
                      SizedBox(height: 16.rH(context)),
                      Text(
                        AppStrings.errorCalculatingCost.tr(context),
                        style: Styles.bold18(context),
                      ),
                      SizedBox(height: 8.rH(context)),
                      Text(
                        state.message ??
                            AppStrings.checkInternetAndTryAgain.tr(context),
                        style: Styles.medium14(context)
                            .copyWith(color: AppColors.greyText),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.rH(context)),
                      CustomButton(
                        onPressed: () {
                          cubit.calculateEstimated();
                        },
                        title: AppStrings.retry.tr(context),
                      ),
                    ],
                  ),
                ))
            : state is CalculateShareEstimatedLoadingState
                ? _buildSkeletonLoading(context)
                : Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom +
                          20.rH(context),
                      left: 20.rW(context),
                      right: 20.rW(context),
                      top: 12.rH(context),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Drag Handle
                          Center(
                            child: Container(
                              width: 50.rW(context),
                              height: 5.rH(context),
                              decoration: BoxDecoration(
                                color: AppColors.greyText.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.rH(context)),

                          // Title
                          Center(
                            child: Text(
                              AppStrings.estimatedTripDetails.tr(context),
                              style: Styles.bold20(context),
                            ),
                          ),
                          SizedBox(height: 24.rH(context)),

                          // Timeline Location Card
                          Container(
                            padding: EdgeInsets.all(16.rW(context)),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.greyText.withOpacity(0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Icon(Icons.circle,
                                        size: 16.rW(context),
                                        color: AppColors.primary),
                                    Container(
                                      width: 2,
                                      height: 30.rH(context),
                                      color:
                                          AppColors.greyText.withOpacity(0.3),
                                    ),
                                    Icon(Icons.location_on,
                                        size: 20.rW(context),
                                        color: Colors.redAccent),
                                  ],
                                ),
                                SizedBox(width: 12.rW(context)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cubit.startLocation?.address ?? '',
                                        style: Styles.medium14(context)
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 26.rH(context)),
                                      Text(
                                        cubit.endLocation?.address ?? '',
                                        style: Styles.medium14(context)
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.rH(context)),

                          // Stats Row (Distance, Time, Seats)
                          Row(
                            children: [
                              _buildStatCard(
                                  context,
                                  Icons.route_outlined,
                                  AppStrings.distance.tr(context),
                                  "${cubit.estimatedTripDetails?.data?.distanceKm} ${AppStrings.km.tr(context)}"),
                              SizedBox(width: 12.rW(context)),
                              _buildStatCard(
                                  context,
                                  Icons.access_time_outlined,
                                  AppStrings.duration.tr(context),
                                  "${cubit.estimatedTripDetails?.data?.timeMinutes} ${AppStrings.min.tr(context)}"),
                              SizedBox(width: 12.rW(context)),
                              _buildStatCard(
                                  context,
                                  Icons.airline_seat_recline_normal,
                                  AppStrings.seats.tr(context),
                                  "${cubit.selectedSeatsIds.length}"),
                            ],
                          ),
                          SizedBox(height: 20.rH(context)),

                          // Total Price Banner
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.rW(context),
                                vertical: 18.rH(context)),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primary.withOpacity(0.75)
                                ],
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppStrings.totalCost.tr(context),
                                    style: Styles.bold16(context)
                                        .copyWith(color: Colors.white)),
                                Text(
                                    "${cubit.estimatedTripDetails?.data?.totalPrice} ${AppStrings.egp.tr(context)}",
                                    style: Styles.bold20(context)
                                        .copyWith(color: Colors.white)),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.rH(context)),

                          // Buttons
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  title: AppStrings.cancel.tr(context),
                                  color: AppColors.transparent,
                                  textColor: AppColors.primary,
                                  borderColor: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: 16.rW(context)),
                              Expanded(
                                child: CustomButton(
                                  onPressed: () {
                                    // context.pop(true);
                                    // Navigator.pop(context);
                                    navigate(
                                      context,
                                      const PaymentMethodsView(
                                        returnPayment: true,
                                        findDriver: true,
                                      ),
                                      then: (paymentMethodId) {
                                        if (paymentMethodId != null &&
                                            paymentMethodId is List) {
                                          navigate(
                                            context,
                                            AvailableShareTripsView(
                                              isScheduled: true,
                                              model: RiderShareTripDataModel(
                                                seatsCount: cubit.seats.length,
                                                seatsIds:
                                                    cubit.selectedSeatsIds,
                                                mainPaymentMethodId:
                                                    paymentMethodId[0],
                                                subPaymentMethodId:
                                                    paymentMethodId[1],
                                                pickupAddress: cubit
                                                        .startLocation
                                                        ?.address ??
                                                    '',
                                                pickupLatitude:
                                                    cubit.startLocation?.lat ??
                                                        0,
                                                pickupLongitude:
                                                    cubit.startLocation?.lon ??
                                                        0,
                                                dropoffAddress: cubit
                                                        .endLocation?.address ??
                                                    '',
                                                dropoffLatitude:
                                                    cubit.endLocation?.lat ?? 0,
                                                dropoffLongitude:
                                                    cubit.endLocation?.lon ?? 0,
                                                vehicleCategoryId: 2,
                                                date: cubit.fromDate != null
                                                    ? cubit.formateDate(
                                                            cubit.fromDate) ??
                                                        ''
                                                    : '',
                                                dates: cubit.selectedDaysFromTo
                                                    .map((element) {
                                                  return DateFormat(
                                                          'yyyy-MM-dd')
                                                      .format(element);
                                                }).toList(),
                                                // dates: cubit.daysFromTo
                                                //     .map((e) =>
                                                //         "${e.year}-${e.month.toString().padLeft(2, '0')}-${e.day.toString().padLeft(2, '0')}")
                                                //     .toList(),
                                                time:cubit.startTime==null?null:
                                                    "${cubit.startTime!.hour.toString().padLeft(2, '0')}:${cubit.startTime!.minute.toString().padLeft(2, '0')}",
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                  title: AppStrings.choosePaymentMethod
                                      .tr(context),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
      },
    );
  }

  Widget _buildStatCard(
      BuildContext context, IconData icon, String title, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: 12.rH(context), horizontal: 8.rW(context)),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 26.rW(context)),
            SizedBox(height: 8.rH(context)),
            Text(title,
                style: Styles.medium12(context)
                    .copyWith(color: AppColors.greyText)),
            SizedBox(height: 4.rH(context)),
            Text(value, style: Styles.bold14primary(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonBox(BuildContext context, {required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildSkeletonLoading(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.rH(context),
          left: 20.rW(context),
          right: 20.rW(context),
          top: 12.rH(context),
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.2),
          highlightColor: Colors.white.withOpacity(0.6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50.rW(context),
                  height: 5.rH(context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20.rH(context)),
              Center(
                child: Container(
                  width: 180.rW(context),
                  height: 24.rH(context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 24.rH(context)),
              Container(
                height: 90.rH(context),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              SizedBox(height: 20.rH(context)),
              Row(
                children: [
                  Expanded(child: _buildSkeletonBox(context, height: 80.rH(context))),
                  SizedBox(width: 12.rW(context)),
                  Expanded(child: _buildSkeletonBox(context, height: 80.rH(context))),
                  SizedBox(width: 12.rW(context)),
                  Expanded(child: _buildSkeletonBox(context, height: 80.rH(context))),
                ],
              ),
              SizedBox(height: 20.rH(context)),
              _buildSkeletonBox(context, height: 60.rH(context)),
              SizedBox(height: 30.rH(context)),
              Row(
                children: [
                  Expanded(child: _buildSkeletonBox(context, height: 50.rH(context))),
                  SizedBox(width: 16.rW(context)),
                  Expanded(child: _buildSkeletonBox(context, height: 50.rH(context))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
