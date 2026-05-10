import '../../../../core/imports/imports.dart';
import '../../../../core/widgets/custom_time_picker_bottom_sheet.dart';

class ScheduleTripSelectStartAndReturnHour extends StatelessWidget {
  const ScheduleTripSelectStartAndReturnHour({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleTripCubit, ScheduleTripState>(
      builder: (context, state) {
        final cubit = context.read<ScheduleTripCubit>();
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //! Start Hour
            Expanded(
              child: CustomSelectContainer(
                value: cubit.startHour,
                hint: AppStrings.startHour.tr(context),
                validationText: cubit.showValidation
                    ? cubit.startHour == null
                        ? AppStrings.selectStartHour.tr(context)
                        : null
                    : null,
                svg: Assets.imagesTime,
                onTap: () async {
                  final TimeOfDay? time =
                      await customTimePickerBottomSheet(context);
                  if (time != null) {
                    final hour12 = time.hour == 0
                        ? 12
                        : (time.hour > 12 ? time.hour - 12 : time.hour);
                    final isAM = time.hour < 12;
                    final formatedTime =
                        "${hour12.toString().padLeft(2, "0")}:${time.minute.toString().padLeft(2, "0")} ${sl<Cache>().getStringData(AppConstants.language) == "en" ? (isAM ? "AM" : "PM") : (isAM ? "ص" : "م")}";

                    cubit.selectStartHour(
                      time: formatedTime,
                      timeOfDay: time,
                    );
                  }
                },
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 10.rW(context),
            //     vertical: 13.rH(context),
            //   ),
            //   child: Text(
            //     AppStrings.to.tr(context),
            //     style: Styles.regular14(context).copyWith(
            //       color: AppColors.greyText,
            //     ),
            //   ),
            // ),
            //! Return Hour
            // Expanded(
            //   child: CustomSelectContainer(
            //     value: cubit.returnHour,
            //     hint: AppStrings.returnHour.tr(context),
            //     svg: Assets.imagesTime,
            //     validationText: cubit.showValidation
            //         ? (cubit.returnHour == null && cubit.goingAndReturning)
            //             ? AppStrings.selectStartHour.tr(context)
            //             : null
            //         : null,
            //     onTap: () async {
            //     },
            //     enabled: cubit.goingAndReturning,
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
