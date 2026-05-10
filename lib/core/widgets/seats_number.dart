import '../imports/imports.dart';

class SeatsNumber extends StatelessWidget {
  const SeatsNumber({
    super.key,
    required this.seatsNumber,
  });

  final int seatsNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.rH(context),
      padding: EdgeInsets.symmetric(
        horizontal: 8.rW(context),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CustomSvgPicture(
            svg: Assets.imagesSeat,
            height: 20.rH(context),
          ),
          Container(
            width: 1,
            height: 20.rH(context),
            margin: EdgeInsets.symmetric(
              horizontal: 8.rW(context),
            ),
            color: AppColors.greyText.withOpacity(.5),
          ),
          Text(
            seatsNumber.toString(),
            style: Styles.regular14(context).copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}
