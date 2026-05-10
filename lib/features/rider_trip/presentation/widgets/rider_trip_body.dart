import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../home/presentation/views/home_view.dart';
import '../../../rating/presentation/widgets/rate_ride_alert_dialog.dart';
import '../cubit/rider_trip_cubit.dart';
import 'rider_trip_bottom_container.dart';
import '../../../schedule_trip/presentation/widgets/schedule_trip_request_card.dart';

class RiderTripBody extends StatelessWidget {
  const RiderTripBody({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RiderTripCubit, RiderTripState>(
      listener: (context, state) {
        if (state is NewRiderJoinState) {
          // showDialog(
          //   context: context,
          //   builder: (context) => const NewRiderJoinAlertDialog(),
          // );
        }
        if (state is RideCompleteState
            // &&
            //     (context.read<RiderTripCubit>().hasPayed == true ||
            //         context.read<RiderTripCubit>().isDelivery)
            ) {
          final cubit = context.read<RiderTripCubit>();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => RateRideAlertDialog(
              tripId: cubit.tripDetails?.rideId ?? 0,
              isDelivery: cubit.isDelivery,
            ),
          );
        }

        if (state is AlmostArriveState &&
            !context.read<RiderTripCubit>().isDelivery) {
          // showDialog(
          //   context: context,
          //   barrierDismissible: false,
          //   builder: (context) => const PayNowAlertDialog(),
          // ).whenComplete(() {
          //   context.read<RiderTripCubit>().hasPayed = true;
          //   if (context.read<RiderTripCubit>().isTripCompleted == true) {
          //     showDialog(
          //       context: context,
          //       barrierDismissible: false,
          //       builder: (context) => const RateRideAlertDialog(),
          //     );
          //   }
          // });
        }

        if (state is RiderCancelTripSuccessState) {
          showToast(
            context,
            message: state.message,
            state: ToastStates.success,
          );
          final globalCubit = context.read<GlobalCubit>();
          globalCubit.navBarController.jumpToTab(0);
          navigateAndRemoveUntil(
            context,
            context.read<GlobalCubit>().isRider
                ? const BaseView()
                : const HomeView(),
          );
        }

        if (state is RiderCancelTripErrorState) {
          showToast(
            context,
            message: state.error,
            state: ToastStates.error,
          );
        }
        if (state is RiderTripCancelledFromDriverState) {
          showToast(
            context,
            message: AppStrings.tripHasCancelledByDriver.tr(context),
            state: ToastStates.warning,
          );
          final globalCubit = context.read<GlobalCubit>();
          globalCubit.navBarController.jumpToTab(0);
          navigateAndRemoveUntil(
            context,
            context.read<GlobalCubit>().isRider
                ? const BaseView()
                : const HomeView(),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<RiderTripCubit>();
        return CustomModalProgressIndicator(
          inAsyncCall:
              state is RiderTripLoadingState || cubit.driverLocation == null,
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                //! Map
                if (cubit.driverLocation != null)
                  Positioned.fill(
                    child: GoogleMap(
                      onMapCreated: (controller) {
                        cubit.mapController = controller;
                      },
                      style: context.read<GlobalCubit>().isDarkMode
                          ? context.read<GlobalCubit>().mapDarkStyle
                          : null,
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: cubit.driverLocation!,
                        zoom: 14.151926040649414,
                      ),
                      markers: cubit.markers,
                      polylines: cubit.polylines,
                    ),
                  ),

                //! Header
                Positioned(
                  top: 0,
                  left: 16.rW(context),
                  right: 16.rW(context),
                  child: const CustomAppBar(),
                ),

                //! Bottom Section
                const RiderTripBottomContainer(),

                //! Requests Overlay
                BlocBuilder<RiderTripCubit, RiderTripState>(
                  builder: (context, state) {
                    final cubit = context.read<RiderTripCubit>();
                    if (cubit.newRequests.isEmpty) return const SizedBox();
                    return Positioned(
                      top: 100.rH(context),
                      left: 16.rW(context),
                      right: 16.rW(context),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: cubit.newRequests.map((request) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16.rH(context)),
                            child: ScheduleTripRequestCard(
                              model: request,
                              onAccept: () => cubit.acceptScheduledTripRequest(
                                requestId: request.id!,
                              ),
                              onDecline: () => cubit.declineRiderRequest(
                                requestId: request.id ?? 0,
                              ),
                              onCancel: () {},
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
