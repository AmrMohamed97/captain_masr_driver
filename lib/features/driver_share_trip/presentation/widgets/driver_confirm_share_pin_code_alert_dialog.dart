import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_pin_put.dart';

class DriverConfirmSharePinCodeAlertDialog extends StatefulWidget {
  const DriverConfirmSharePinCodeAlertDialog({
    super.key,
    required this.code,
  });

  final int code;

  @override
  State<DriverConfirmSharePinCodeAlertDialog> createState() =>
      _DriverConfirmSharePinCodeAlertDialogState();
}

class _DriverConfirmSharePinCodeAlertDialogState
    extends State<DriverConfirmSharePinCodeAlertDialog> {
  GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      elevation: 0,
      content: Container(
        width: 344.rW(context),
        padding: EdgeInsets.symmetric(
          horizontal: 16.rW(context),
          vertical: 19.rH(context),
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          key: fromKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //! Title
              Text(
                AppStrings.tripCode.tr(context),
                style: Styles.semibold21Primary(context),
              ),
              //! Svg
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 27.rH(context),
                ),
                child: CustomSvgPicture(
                  svg: Assets.imagesVerifyPinCode,
                  height: 98.rH(context),
                ),
              ),
              //! Subtitle
              Text(
                AppStrings.verifyTheRiderByWritingTheCorrectTripCode
                    .tr(context),
                style: Styles.semibold16Primary(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 31.rH(context)),
              //! Codes
              CustomPinPut(
                controller: codeController,
                onComplete: (value) {
                  FocusScope.of(context).unfocus();
                },
                validator: (value) {
                  if (value != widget.code.toString()) {
                    return AppStrings.invalidTripCode.tr(context);
                  }
                  return null;
                },
              ),

              SizedBox(height: 25.rH(context)),
              //! Confirm Button
              CustomButton(
                onPressed: () async {
                  if (fromKey.currentState!.validate()) {
                    Navigator.pop(context, true);
                  }
                },
                enabled: codeController.text.length == 4,
                title: AppStrings.confirm.tr(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
