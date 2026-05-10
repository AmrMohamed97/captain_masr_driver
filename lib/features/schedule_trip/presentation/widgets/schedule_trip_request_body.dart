import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_tab_bar.dart';
import '../../../rider_trip/data/models/trip_details_model.dart';
import '../../../trips/presentation/widgets/cancel_trip_alert_dialog.dart';
import '../../../trips/presentation/widgets/reason_of_cancel_trip_alert_dialog.dart';
import 'schedule_trip_request_card.dart';

class ScheduleTripRequestBody extends StatelessWidget {
  const ScheduleTripRequestBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
      child: Column(
        children: [
          //! Header
          CustomAppBar(
            title: AppStrings.requests.tr(context),
          ),

          SizedBox(height: 26.rH(context)),

          //! Tab Bar
          BlocBuilder<ScheduleTripCubit, ScheduleTripState>(
            builder: (context, state) {
              final cubit = context.read<ScheduleTripCubit>();
              return CustomTapBar(
                taps: [
                  AppStrings.neW.tr(context),
                  AppStrings.accepted.tr(context),
                ],
                selectedTap: cubit.requestsTabIndex,
                onTap: (value) => cubit.changeRequestsTabIndex(value),
                tabWidth: 145.rW(context),
              );
            },
          ),

          SizedBox(height: 16.rH(context)),

          //! Requests
          BlocBuilder<ScheduleTripCubit, ScheduleTripState>(
            builder: (context, state) {
              final cubit = context.read<ScheduleTripCubit>();
              return Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.only(bottom: 24.rH(context)),
                  itemCount: cubit.requestsTabIndex == 0
                      ? cubit.newRequests.length
                      : cubit.acceptedRequests.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 16.rH(context));
                  },
                  itemBuilder: (context, index) {
                    final TripDetailsModel request = cubit.requestsTabIndex == 0
                        ? cubit.newRequests[index]
                        : cubit.acceptedRequests[index];
                    return ScheduleTripRequestCard(
                      model: request,
                      accepted: cubit.requestsTabIndex == 1,
                      onAccept: () => cubit.acceptScheduledTripRequest(
                        requestId: request.id!,
                      ),
                      onDecline: () =>
                          cubit.declineRiderRequest(requestId: request.id ?? 0),
                      onCancel: () {
                        showDialog(
                          context: context,
                          builder: (context) => const CancelTripAlertDialog(),
                        ).then((value) {
                          if (value == true) {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  const ReasonOfCancelTripAlertDialog(),
                            ).then((value) {
                              if (value != null && value is List) {
                                cubit.driverCancelScheduleTripForRider(
                                  riderId: request.id ?? 0,
                                  reason: value[0],
                                  notes: value[1],
                                );
                              }
                            });
                          }
                        });
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
