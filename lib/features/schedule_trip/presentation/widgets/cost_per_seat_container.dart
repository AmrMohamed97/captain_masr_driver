import '../../../../core/imports/imports.dart';

class CostPerSeatContainer extends StatelessWidget {
  const CostPerSeatContainer({
    super.key,
    required this.value,
  });

  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48.rH(context),
      margin: EdgeInsets.only(bottom: 16.rH(context)),
      padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.primary.withOpacity(.15),
      ),
      child: Row(
        children: [
          CustomSvgPicture(
            svg: Assets.imagesCashPaper,
            height: 24.rH(context),
          ),
          SizedBox(width: 8.rW(context)),
          Text(
            AppStrings.costPerSeat.tr(context),
            style: Styles.medium16Primary(context).copyWith(
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.color
                  ?.withOpacity(.50),
            ),
          ),
          const Spacer(),
          Text(
            "$value ${AppStrings.egp.tr(context)}",
            style: Styles.semibold20Primary(context).copyWith(
              color: AppColors.red,
            ),
          ),
        ],
      ),
    );
  }
}
