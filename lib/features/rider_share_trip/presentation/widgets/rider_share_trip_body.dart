import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../home/presentation/views/home_view.dart';
import '../../../rating/presentation/widgets/rate_ride_alert_dialog.dart';
import '../cubit/rider_share_trip_cubit.dart';
import 'rider_share_trip_bottom_container.dart';
import '../../../schedule_trip/presentation/widgets/schedule_trip_request_card.dart';

class RiderShareTripBody extends StatelessWidget {
  final int tripId;
  const RiderShareTripBody({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RiderShareTripCubit, RiderShareTripState>(
      listener: (context, state) {
        if (state is NewShareRiderJoinState) {
          // showDialog(
          //   context: context,
          //   builder: (context) => const NewRiderJoinAlertDialog(),
          // );
        }
        if (state is RideShareCompleteState
            // &&
            //     (context.read<RiderShareTripCubit>().hasPayed == true ||
            //         context.read<RiderShareTripCubit>().isDelivery)
            ) {
          print('trip==============================');
          print(state.tripDetails?.toMap());
          final cubit = context.read<RiderShareTripCubit>();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => RateRideAlertDialog(
              // tripId: cubit.tripDetails?.requests[cubit.tripDetails?.requests.indexWhere((element)=>element.riderId == cubit.tripDetails!.rideId!)??0].requestId ?? 0,
              // tripId: cubit.tripDetails?.requests.firstWhere(
              //       (element) => element.riderId == cubit.tripDetails!.rideId!,
              //     ).requestId ??
              //     0,
              // tripId: cubit.tripDetails!.requestId??cubit.tripDetails!.id!,
              tripId: state.tripDetails?.requestId ?? state.tripDetails!.id!,
              isDelivery: false,
              type: 'share',
            ),
          );
        }

        if (state is AlmostShareArriveState &&
            !context.read<RiderShareTripCubit>().isDelivery) {
          // showDialog(
          //   context: context,
          //   barrierDismissible: false,
          //   builder: (context) => const PayNowAlertDialog(),
          // ).whenComplete(() {
          //   context.read<RiderShareTripCubit>().hasPayed = true;
          //   if (context.read<RiderShareTripCubit>().isTripCompleted == true) {
          //     showDialog(
          //       context: context,
          //       barrierDismissible: false,
          //       builder: (context) =>   RateRideAlertDialog(tripId:,isDelivery: false,),
          //     );
          //   }
          // });
        }

        if (state is RiderShareCancelTripSuccessState) {
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

        if (state is RiderShareCancelTripErrorState) {
          showToast(
            context,
            message: state.error,
            state: ToastStates.error,
          );
        }
        if (state is RiderShareTripCancelledFromDriverState) {
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
        final cubit = context.read<RiderShareTripCubit>();
        return CustomModalProgressIndicator(
          inAsyncCall: state is RiderShareTripLoadingState ||
              cubit.driverLocation == null,
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
               RiderShareTripBottomContainer(tripId: tripId,),

                //! Requests Overlay
                BlocBuilder<RiderShareTripCubit, RiderShareTripState>(
                  builder: (context, state) {
                    final cubit = context.read<RiderShareTripCubit>();
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
