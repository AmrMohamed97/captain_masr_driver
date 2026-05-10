import '../imports/imports.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    this.popOnTap,
    this.title,
    this.trailing,
    this.isLigth = false,
  });

  final Function()? popOnTap;
  final String? title;
  final Widget? trailing;
  final bool isLigth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 49.rH(context)),
      child: Row(
        children: [
          //! Pop Button
          CustomPopButton(
            popOnTap: popOnTap,
            isWhite: isLigth,
          ),
          SizedBox(width: 16.rW(context)),
          Expanded(
            child: title != null
                ? Text(
                    title!,
                    style: Styles.semibold18Primary(context).copyWith(
                      color: isLigth ? AppColors.white : AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                  )
                : Container(),
          ),
          SizedBox(width: 16.rW(context)),
          if (trailing != null) trailing!,
          if (trailing == null)
            SizedBox(
              width: 38.rW(context),
            ),
        ],
      ),
    );
  }
}
