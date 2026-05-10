import '../../../../core/imports/imports.dart';
import 'delivery_sending_or_receving.dart';
import 'package_details_continue_button.dart';
import 'package_details_form.dart';

class PackageDetailsBody extends StatelessWidget {
  const PackageDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
      child: Column(
        children: [
          //! Header
          CustomAppBar(
            title: AppStrings.packageDetails.tr(context),
          ),

          SizedBox(height: 26.rH(context)),

          //! Sending Or Reveiving
          const DeliverySendingOrReveiving(),

          SizedBox(height: 26.rH(context)),

          //! Form
          const PackageDetailsForm(),

          SizedBox(height: 16.rH(context)),

          //! Continue Button
          const PackageDetailsContinueButton(),

          SizedBox(height: 33.rH(context)),
        ],
      ),
    );
  }
}
