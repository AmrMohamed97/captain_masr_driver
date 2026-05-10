import '../../../../core/imports/imports.dart';

class DurationFromToRow extends StatelessWidget {
  const DurationFromToRow({
    super.key,
    required this.from,
    required this.to,
  });

  final String from, to;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomSvgPicture(
          svg: Assets.imagesCalender,
          height: 24.rH(context),
        ),
        SizedBox(width: 16.rW(context)),
        //! Form
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.from.tr(context),
                style: Styles.medium14(context).copyWith(
                  color: AppColors.greyText,
                ),
              ),
              SizedBox(height: 7.rH(context)),
              Text(
                from,
                style: Styles.medium14(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 35.rH(context),
          margin: EdgeInsets.symmetric(horizontal: 36.rW(context)),
          width: 1,
          color: AppColors.greyText,
        ),
        //! To
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.to.tr(context),
                style: Styles.medium14(context).copyWith(
                  color: AppColors.greyText,
                ),
              ),
              SizedBox(height: 7.rH(context)),
              Text(
                to,
                style: Styles.medium14(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 30.rW(context)),
      ],
    );
  }
}
