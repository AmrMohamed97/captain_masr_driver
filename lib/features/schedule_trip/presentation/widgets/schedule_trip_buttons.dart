// import 'package:flutter/cupertino.dart';
// import 'package:intl/intl.dart';
// import 'package:shimmer/shimmer.dart';

import '../../../../core/imports/imports.dart';
// import '../../../start_trip/data/models/rider_share_trip_data_model.dart';
// import '../../../start_trip/presentation/views/available_share_trips.dart';
// // import '../../../start_trip/presentation/views/start_trip_view.dart';
// import '../../../wallet/presentation/views/payment_methods_view.dart';
import 'share_trip_estimation_bottom_sheet.dart';

class ScheduleTripButtons extends StatelessWidget {
  const ScheduleTripButtons({super.key});
  @override
  Widget build(BuildContext context) {
    final isDriver = context.read<GlobalCubit>().isDriver;
    return BlocBuilder<ScheduleTripCubit, ScheduleTripState>(
      builder: (context, state) {
        final cubit = context.read<ScheduleTripCubit>();
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
          child: Row(
            children: [
              //! Find Driver Button
              Expanded(
                child: CustomButton(
                  onPressed: () async {
                    final bool isValid = cubit.startLocation != null &&
                        cubit.endLocation != null &&
                        cubit.fromDate != null &&
                        cubit.toDate != null &&
                        (isDriver ? cubit.startHour != null : true) &&
                        cubit.selectedSeatsIds.isNotEmpty &&
                        (cubit.goingAndReturning
                            ? cubit.returnHour != null
                            : true);

                    if (!isValid) {
                      cubit.validationToggle();
                    } else {
                      if (isDriver) {
                        cubit.driverPostTrip();
                      } else {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(30)),
                          ),
                          builder: (context) => BlocProvider.value(
                            value: cubit, //context.read<ScheduleTripCubit>(),
                            child: const ShareTripEstimationBottomSheet(),
                          ),
                        );
                      }
                    }
                  },
                  title: context.read<GlobalCubit>().isRider
                      ? AppStrings.findDriver.tr(context)
                      : AppStrings.postTrip.tr(context),
                  enabled: cubit.startLocation != null &&
                      cubit.endLocation != null &&
                      cubit.fromDate != null &&
                      cubit.toDate != null &&
                      cubit.selectedSeatsIds.isNotEmpty &&
                      (context.read<GlobalCubit>().isDriver
                          ? ((cubit.startHour != null && isDriver) &&
                              ((cubit.returnHour != null &&
                                      cubit.goingAndReturning) ||
                                  cubit.returnHour == null &&
                                      !cubit.goingAndReturning))
                          : true),
                ),
              ),

              //! Now Button
              // if (context.read<GlobalCubit>().isRider)
              //   Padding(
              //     padding: EdgeInsetsDirectional.only(start: 12.rW(context)),
              //     child: CustomButton(
              //       onPressed: () {
              //         navigate(
              //           context,
              //           const StartTripView(
              //             isDailyRideNow: true,
              //             isShareRide: true,
              //           ),
              //         );
              //       },
              //       title: AppStrings.now.tr(context),
              //       widgth: 77.rW(context),
              //       color: AppColors.transparent,
              //       textColor: AppColors.primary,
              //       borderColor: AppColors.primary,
              //       icon: const CustomSvgPicture(
              //         svg: Assets.imagesTime,
              //       ),
              //       iconEndPadding: 6.rW(context),
              //       padding: EdgeInsets.zero,
              //     ),
              //   ),
            ],
          ),
        );
      },
    );
  }
}
