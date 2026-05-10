import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../widgets/schedule_trip_body.dart';
import '../widgets/trip_post_success_alert_dialog.dart';
import 'posted_schedule_trip_view.dart';

class ScheduleTripView extends StatelessWidget {
  const ScheduleTripView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScheduleTripCubit(
        isRider: context.read<GlobalCubit>().isRider,
      ),
      child: BlocConsumer<ScheduleTripCubit, ScheduleTripState>(
        listener: (context, state) {
          if (state is DriverPostScheduleTripSuccessState) {
            showDialog(
              context: context,
              builder: (context) => const TripPostSuccessAlertDialg(),
            ).then((value) {
              navigateReplacement(
                context,
                PostedScheduleTripView(
                  trip: state.trip,
                ),
              );
            });
          }
          if (state is ScheduleTripErrorState) {
            showToast(
              context,
              message: state.errorMessage,
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.read<GlobalCubit>().isDarkMode
                ? Theme.of(context).cardColor
                : AppColors.grey5,
            body: CustomModalProgressIndicator(
              inAsyncCall: state is ScheduleTripLoadingState,
              child: const ScheduleTripBody(),
            ),
          );
        },
      ),
    );
  }
}
