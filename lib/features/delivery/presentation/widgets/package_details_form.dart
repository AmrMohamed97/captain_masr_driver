import '../../../../core/imports/imports.dart';
import 'package_details_additional_notes.dart';
import 'package_details_payment_type_section.dart';
import 'package_details_size_section.dart';
import 'package_details_type_section.dart';
import 'package_details_vehicle_type_section.dart';

class PackageDetailsForm extends StatelessWidget {
  const PackageDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          //! Vehcile Type
          PackageDetailsVehcileTypeSection(),
          //! Deilvery Type
          PackageDetailsTypeSection(),
          //! Size
          PackageDetailsSizeSection(),
          //! Payment Type
          PackageDetailsPaymentTypeSection(),
          //! Additional Notes
          PackageDetailsAdditionalNotes(),
        ],
      ),
    );
  }
}
