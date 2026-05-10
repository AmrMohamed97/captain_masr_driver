import '../../../../core/imports/imports.dart';

class StartAndEndPoint extends StatelessWidget {
  const StartAndEndPoint({
    super.key,
    this.startTitle,
    this.endTitle,
    required this.startValue,
    required this.endValue,
  });

  final String? startTitle, endTitle;
  final String startValue, endValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //! Icon
        CustomSvgPicture(
          svg: Assets.imagesFromToSvg,
          height: 69.rH(context),
        ),
        SizedBox(width: 12.rW(context)),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //! Start
              Text(
                startTitle ?? AppStrings.gatheringPoint.tr(context),
                style: Styles.regular12(context).copyWith(
                  color: AppColors.greyText,
                ),
              ),
              SizedBox(height: 2.rH(context)),
              Text(
                startValue,
                style: Styles.regular14(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              SizedBox(height: 12.rH(context)),
              //! End
              Text(
                endTitle ?? AppStrings.endPoint.tr(context),
                style: Styles.regular12(context).copyWith(
                  color: AppColors.greyText,
                ),
              ),
              SizedBox(height: 2.rH(context)),
              Text(
                endValue,
                style: Styles.regular14(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
