import '../imports/imports.dart';

class CostRow extends StatelessWidget {
  const CostRow({
    super.key,
    this.cost,
    this.costBeforeDiscount,
    this.title,
    this.borderRadius,
    this.color,
  });

  final num? cost, costBeforeDiscount;
  final String? title;
  final BorderRadiusGeometry? borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 51.rH(context),
      padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
      decoration: BoxDecoration(
        color: color ?? AppColors.primary.withOpacity(.12),
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          //! Cash Icon
          CustomSvgPicture(
            svg: Assets.imagesCashPaper,
            height: 24.rH(context),
          ),
          SizedBox(width: 10.rW(context)),
          //! Title
          Text(
            title ?? AppStrings.estimatedCost.tr(context),
            style: Styles.semibold14Primary(context).copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const Spacer(),
          //! Cost
          Text(
            "${cost ?? "??"} ${AppStrings.egp.tr(context)}",
            style: Styles.semibold20Primary(context).copyWith(
              color: AppColors.red,
            ),
          ),
          //! Price Before
          if (costBeforeDiscount != null)
            Text(
              " $costBeforeDiscount ${AppStrings.egp.tr(context)}",
              style: Styles.regular16(context).copyWith(
                color: AppColors.greyText,
                decoration: TextDecoration.lineThrough,
                decorationColor: AppColors.greyText,
              ),
            ),
        ],
      ),
    );
  }
}
