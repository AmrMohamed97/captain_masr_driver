import '../../../../core/imports/imports.dart';
import 'schedule_trip_buttons.dart';
import 'schedule_trip_form.dart';
import 'schedule_trip_header.dart';

class ScheduleTripBody extends StatelessWidget {
  const ScheduleTripBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //! Header
        const ScheduleTripHeader(),

        SizedBox(height: 13.rH(context)),

        //! Form
        const ScheduleTripForm(),

        SizedBox(height: 16.rH(context)),

        //! Confirm Buttons
        const ScheduleTripButtons(),

        SizedBox(height: 24.rH(context)),
      ],
    );
  }
}
