import '../../../../core/imports/imports.dart';

class ReasonOfCancelTripAlertDialog extends StatefulWidget {
  const ReasonOfCancelTripAlertDialog({
    super.key,
  });

  @override
  State<ReasonOfCancelTripAlertDialog> createState() =>
      _ReasonOfCancelTripAlertDialogState();
}

class _ReasonOfCancelTripAlertDialogState
    extends State<ReasonOfCancelTripAlertDialog> {
  List<int> selectedIndexs = [];
  List<String> cancelReasons = [];

  TextEditingController otherController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      elevation: 0,
      content: Container(
        width: 344.rW(context),
        padding: EdgeInsets.symmetric(
          horizontal: 16.rW(context),
          vertical: 24.rH(context),
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            //! Title
            Align(
              alignment: Alignment.center,
              child: Text(
                AppStrings.reasonsForCancelation.tr(context),
                style: Styles.semibold21Primary(context),
              ),
            ),

            SizedBox(height: 12.rH(context)),

            //! Check Boxes
            ...List.generate(
              4,
              (index) {
                final List<String> reasons = context.read<GlobalCubit>().isRider
                    ? [
                        AppStrings.driverIsTakingTooLong,
                        AppStrings.changeOfPlans,
                        AppStrings.wrongPickUpLocation,
                        AppStrings.foundAnotherRide,
                      ]
                    : [
                        AppStrings.riderNotShowingUp,
                        AppStrings.tooManyPassengers,
                        AppStrings.riderBehaviorIssue,
                        AppStrings.vehicleIssue,
                      ];
                return ReasonOfCancelTripCheckBox(
                  title: reasons[index].tr(context),
                  value: selectedIndexs.contains(index),
                  onTap: () {
                    selectedIndexs.contains(index)
                        ? selectedIndexs.remove(index)
                        : selectedIndexs.add(index);
                    cancelReasons.contains(reasons[index])
                        ? cancelReasons.remove(reasons[index])
                        : cancelReasons.add(reasons[index]);
                    setState(() {});
                  },
                );
              },
            ),

            SizedBox(height: 6.rH(context)),

            //! Other
            AuthTextField(
              controller: otherController,
              title: AppStrings.other.tr(context),
              hintText: AppStrings.otherReason.tr(context),
              fillColor: context.read<GlobalCubit>().isDarkMode
                  ? Theme.of(context).cardColor
                  : AppColors.grey4,
              maxLines: 2,
            ),

            SizedBox(height: 10.rH(context)),

            //! Buttons
            Row(children: [
              //! Yes
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    if (cancelReasons.isNotEmpty ||
                        otherController.text.isNotEmpty) {
                      Navigator.pop(
                        context,
                        [cancelReasons, otherController.text],
                      );
                    }
                  },
                  title: AppStrings.confirm.tr(context),
                  textColor: AppColors.primary,
                  borderColor: AppColors.primary,
                  color: AppColors.transparent,
                ),
              ),
              SizedBox(width: 22.rW(context)),
              //! No
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  title: AppStrings.goBack.tr(context),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class ReasonOfCancelTripCheckBox extends StatelessWidget {
  const ReasonOfCancelTripCheckBox({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final String title;
  final bool value;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 46.rH(context),
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 16.rH(context)),
        padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
        decoration: BoxDecoration(
          color: context.read<GlobalCubit>().isDarkMode
              ? Theme.of(context).cardColor
              : AppColors.grey4,
          border: Border.all(
            color: value ? AppColors.primary : AppColors.transparent,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            //! Check Box
            CustomCheckBox(
              value: value,
              onTap: () {},
            ),
            SizedBox(width: 14.rW(context)),
            //! Title
            Text(
              title,
              style: Styles.regular14(context).copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
