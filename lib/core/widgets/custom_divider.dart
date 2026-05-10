import '../imports/imports.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
    this.topSpace,
    this.bottomSpace,
    this.space,
  });

  final double? topSpace, bottomSpace, space;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: space != null
          ? EdgeInsets.symmetric(vertical: space!)
          : EdgeInsets.only(
              top: topSpace ?? 0,
              bottom: bottomSpace ?? 0,
            ),
      child: Divider(
        color: AppColors.greyText.withOpacity(.25),
      ),
    );
  }
}
