import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_date_picker_dialog.dart';

class ScheduleTripChooseDate extends StatelessWidget {
  const ScheduleTripChooseDate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleTripCubit, ScheduleTripState>(
      builder: (context, state) {
        final cubit = context.read<ScheduleTripCubit>();
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //! From Date
            Expanded(
              child: CustomSelectContainer(
                value: cubit.formateDate(cubit.fromDate),
                hint: AppStrings.departDate.tr(context),
                validationText: cubit.showValidation
                    ? cubit.fromDate == null
                        ? AppStrings.chooseDate.tr(context)
                        : null
                    : null,
                svg: Assets.imagesCalender,
                onTap: () async {
                  final DateTime? date = await customDatePickerDialog(
                    context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  cubit.selectFromDate(date);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.rW(context),
                vertical: 13.rH(context),
              ),
              child: Text(
                AppStrings.to.tr(context),
                style: Styles.regular14(context).copyWith(
                  color: AppColors.greyText,
                ),
              ),
            ),
            //! To Date
            Expanded(
              child: CustomSelectContainer(
                value: cubit.formateDate(cubit.toDate),
                hint: AppStrings.returnDate.tr(context),
                svg: Assets.imagesCalender,
                enabled: cubit.fromDate != null,
                validationText: cubit.showValidation
                    ? cubit.toDate == null
                        ? AppStrings.chooseDate.tr(context)
                        : null
                    : null,
                onTap: () async {
                  final DateTime? date = await customDatePickerDialog(
                    context,
                    firstDate: cubit.fromDate!.add(const Duration(days: 1)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  cubit.selectToDate(date);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
