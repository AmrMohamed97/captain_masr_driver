import '../../../../core/imports/imports.dart';
import '../widgets/schedule_trip_request_body.dart';

class ScheduleTripRequestView extends StatelessWidget {
  const ScheduleTripRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleTripCubit, ScheduleTripState>(
      builder: (context, state) {
        return Scaffold(
          body: CustomModalProgressIndicator(
            inAsyncCall: state is ScheduleTripLoadingState,
            child: const ScheduleTripRequestBody(),
          ),
        );
      },
    );
  }
}
