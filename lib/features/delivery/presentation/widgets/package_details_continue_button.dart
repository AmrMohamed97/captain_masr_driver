import '../../../../core/imports/imports.dart';
import '../../../start_trip/presentation/views/start_trip_view.dart';
import '../../data/models/delivery_details_model.dart';
import 'package_details_take_photo_alert_dialog.dart';

class PackageDetailsContinueButton extends StatelessWidget {
  const PackageDetailsContinueButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryCubit, DeliveryState>(
      builder: (context, state) {
        final cubit = context.read<DeliveryCubit>();
        return CustomButton(
          enabled: cubit.isFormValidate(),
          onPressed: () {
            if (cubit.isFormValidate()) {
              showDialog(
                context: context,
                builder: (context) =>
                    const PackegeDetailsTakePhotoAlertDialog(),
              ).then((value) {
                if (value != null) {
                  cubit.packagePhoto = value[1];
                  navigateReplacement(
                    context,
                    StartTripView(
                      isDelivery: true,
                      deliveryDetailsModel: DeliveryDetailsModel(
                        deliveryType: cubit.isSending ? "sending" : "receiving",
                        vehicleCategoryId: cubit.selectedVehicleCategoryId!,
                        deliveryItemId: cubit.selectedItemId!,
                        deliveryItemSizeId: cubit.selectedSizeId!,
                        paymentType: cubit.selectedPaymentIndex == 0
                            ? "preorder"
                            : "cash_on_delivery",
                        note: cubit.noteController.text,
                        image: cubit.packagePhoto,
                      ),
                    ),
                  );
                }
              });
            }
          },
          title: AppStrings.cOntinue.tr(context),
        );
      },
    );
  }
}
