import '../../../../core/imports/imports.dart';

class PreferencesSwitchCard extends StatelessWidget {
  const PreferencesSwitchCard({
    super.key,
    required this.title,
    required this.svg,
    required this.onTap,
    required this.value,
  });

  final String title, svg;
  final Function(bool)? onTap;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54.rH(context),
      padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
      margin: EdgeInsets.only(bottom: 16.rH(context)),
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CustomSvgPicture(
            svg: svg,
            height: 22.rH(context),
          ),
          SizedBox(width: 8.rW(context)),
          Expanded(
            child: Text(
              title,
              style: Styles.medium14Primary(context).copyWith(
                color: value ? AppColors.primary : AppColors.greyText,
              ),
            ),
          ),
          CustomSwitch(
            value: value,
            onChanged: onTap,
          ),
        ],
      ),
    );
  }
}
