import '../imports/imports.dart';

class DistanceAndDuration extends StatelessWidget {
  const DistanceAndDuration({
    super.key,
    required this.distance,
    required this.duration,
  });

  final String distance, duration;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //! Distance
        Expanded(
          child: Row(
            children: [
              CustomSvgPicture(
                svg: Assets.imagesPinLocation,
                color: AppColors.red,
                height: 13.rH(context),
              ),
              SizedBox(width: 8.rW(context)),
              Text(
                AppStrings.distance.tr(context),
                style: Styles.regular14(context).copyWith(
                  color: AppColors.greyText,
                ),
              ),
              SizedBox(width: 8.rW(context)),
              Expanded(
                child: FittedBox(
                  alignment: AlignmentDirectional.centerStart,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "$distance ${AppStrings.km.tr(context)}",
                    style: Styles.semibold14Primary(context).copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 1,
          height: 13.rH(context),
          margin: EdgeInsets.symmetric(
            horizontal: 20.rW(context),
          ),
          color: AppColors.greyText.withOpacity(.5),
        ),
        //! Duration
        Expanded(
          child: Row(
            children: [
              CustomSvgPicture(
                svg: Assets.imagesTime,
                color: AppColors.yellow,
                height: 13.rH(context),
              ),
              SizedBox(width: 8.rW(context)),
              Text(
                AppStrings.duration.tr(context),
                style: Styles.regular14(context).copyWith(
                  color: AppColors.greyText,
                ),
              ),
              SizedBox(width: 8.rW(context)),
              Expanded(
                child: FittedBox(
                  alignment: AlignmentDirectional.centerStart,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "$duration ${AppStrings.min.tr(context)}",
                    style: Styles.semibold14Primary(context).copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
