import '../../../../core/imports/imports.dart';
import '../../../trips/presentation/widgets/cancel_trip_alert_dialog.dart';
import '../../../trips/presentation/widgets/reason_of_cancel_trip_alert_dialog.dart';
import '../cubit/driver_share_trip_cubit.dart';
import 'driver_confirm_share_pin_code_alert_dialog.dart';

class DriverShareTripButtons extends StatelessWidget {
  const DriverShareTripButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverShareTripCubit, DriverShareTripState>(
      builder: (context, state) {
        final cubit = context.read<DriverShareTripCubit>();
        return
            // cubit.isShareTrip || cubit.isOnMyWay
            //     ?
            Row(
          children: [
            //cancel trip for rider by driver
            //! Cancel Buton
            Expanded(
              child: CustomButton(
                onPressed: () async {
                  print('trip data=====================================');
                  print('status: ${cubit.tripDetails?.status}');
                  print('id: ${cubit.tripDetails?.id}');
                  print('riderId: ${cubit.tripDetails?.riderId}');
                  print('tripDetails: ${cubit.tripDetails?.toMap()}');
                  final bool? value = await showDialog(
                    context: context,
                    builder: (context) => const CancelTripAlertDialog(),
                  );
                  if (value == true) {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const ReasonOfCancelTripAlertDialog(),
                    ).then((value) {
                      if (value != null && value is List) { cubit.driverCancelScheduleTripForRider(
                          notes: value[1],
                          reason: value[0],
                        );
                      }
                    });
                  }
                },
                title: AppStrings.cancelTrip.tr(context),
                color: AppColors.transparent,
                textColor: AppColors.red,
                borderColor: AppColors.red,
                height: 46.rH(context),
              ),
            ),

            SizedBox(width: 16.rW(context)),

            //! I Have Arrived Button
            if (cubit.tripDetails?.status == "accepted")
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    // print('jfa;lkjdsgl;jk;ljgag');
                    cubit.driverArrivedShareTrip();
                  },
                  title: AppStrings.iHaveArrived.tr(context),
                ),
              ),

            //! Start Trip Button
            if (cubit.tripDetails?.status == "driver_arrived")
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          DriverConfirmSharePinCodeAlertDialog(
                        code: cubit.tripDetails?.tripCode ?? 0000,
                      ),
                    ).then((value) {
                      if (value == true) {
                        cubit.startShareTripWithRiders();
                      }
                    });
                  },
                  title: AppStrings.startTrip.tr(context),
                ),
              ),
            //! Drop Off Button
            if (cubit.tripDetails?.status == "started")
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    cubit.completeShareTripWithRiders();
                  },
                  title: AppStrings.dropOff.tr(context),
                  // enabled: (cubit.remainingDistanceNum ?? 0) < .100 &&
                  //     cubit.totalDistanceNum != null,
                ),
              ),
          ],
        );
        // : Row(
        //     children: [
        //       // ! Cancel Button
        //       if (!cubit.isDeliveryTrip || !cubit.isTripStarted)
        //         Expanded(
        //           child: CustomButton(
        //             onPressed: () async {
        //               final bool? value = await showDialog(
        //                 context: context,
        //                 builder: (context) => const CancelTripAlertDialog(),
        //               );
        //               if (value == true) {
        //                 showDialog(
        //                   context: context,
        //                   builder: (context) =>
        //                       const ReasonOfCancelTripAlertDialog(),
        //                 ).then((value) {
        //                   if (value != null && value is List) {
        //                     cubit.cancelTrip(
        //                       cancelReasons: value[0],
        //                       notes: value[1],
        //                     );
        //                   }
        //                 });
        //               }
        //             },
        //             title: AppStrings.cancelTrip.tr(context),
        //             color: AppColors.transparent,
        //             textColor: AppColors.red,
        //             borderColor: AppColors.red,
        //             height: 46.rH(context),
        //           ),
        //         ),
        //       if (!cubit.isDeliveryTrip || !cubit.isTripStarted)
        //         SizedBox(width: 16.rW(context)),
        //       //! I Have Arrived Button
        //       if (!cubit.isDriverWaiting && !cubit.isTripStarted)
        //         Expanded(
        //           child: CustomButton(
        //             // enabled: cubit.remainingDistanceNum != null &&
        //             //     cubit.remainingDistanceNum! < (100 / 1000),
        //             onPressed: () {
        //               cubit.driverArrived();
        //             },
        //             title: AppStrings.iHaveArrived.tr(context),
        //           ),
        //         ),
        //       //! Start Trip Button
        //       if (cubit.isDriverWaiting && !cubit.isDeliveryTrip)
        //         Expanded(
        //           child: CustomButton(
        //             onPressed: () {
        //               showDialog(
        //                 context: context,
        //                 builder: (context) =>
        //                     DriverConfirmSharePinCodeAlertDialog(
        //                   code: cubit.tripDetails!.tripCode ?? 0000,
        //                 ),
        //               ).then((value) {
        //                 if (value == true) {
        //                   cubit.startTrip();
        //                 }
        //               });
        //             },
        //             title: AppStrings.startTrip.tr(context),
        //           ),
        //         ),
        //       //! Pickup Button
        //       if (cubit.isDriverWaiting && cubit.isDeliveryTrip)
        //         Expanded(
        //           child: CustomButton(
        //             onPressed: () {
        //               showDialog(
        //                 context: context,
        //                 builder: (context) =>
        //                     DriverConfirmSharePinCodeAlertDialog(
        //                   code: cubit.tripDetails!.tripCode ?? 0000,
        //                 ),
        //               ).then((value) {
        //                 if (value == true) {
        //                   showDialog(
        //                     context: context,
        //                     builder: (context) =>
        //                         const PackegeDetailsTakePhotoAlertDialog(
        //                       canSkip: false,
        //                     ),
        //                   ).then((value) {
        //                     if (value != null) {
        //                       cubit.startTrip(deliveryImage: value[1]);
        //                     }
        //                   });
        //                 }
        //               });
        //             },
        //             title: AppStrings.pickup.tr(context),
        //           ),
        //         ),
        //       //! Drop Off
        //       // if (cubit.isTripStarted)
        //       //   Expanded(
        //       //     child: CustomButton(
        //       //       onPressed: () {
        //       //         cubit.completeTrip();
        //       //       },
        //       //       title: AppStrings.dropOff.tr(context),
        //       //       // هنا لو عاوز اعمل شرط على زرار اكتمال الرحلة
        //       //       // enabled: (cubit.remainingDistanceNum ?? 0) < .100 &&
        //       //       //     cubit.totalDistanceNum != null,
        //       //     ),
        //       //   ),
        //     ],
        //   );
      },
    );
  }
}
