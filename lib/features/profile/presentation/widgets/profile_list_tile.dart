import '../../../../core/imports/imports.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({
    super.key,
    required this.title,
    required this.svg,
    required this.onTap,
    this.trailingWidget,
    this.flip = false,
  });

  final String title, svg;
  final Function() onTap;
  final Widget? trailingWidget;
  final bool flip;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 58.rH(context),
        padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
        margin: EdgeInsets.only(bottom: 16.rH(context)),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            //! Icon
            Transform.flip(
              flipX: flip,
              child: CustomSvgPicture(
                svg: svg,
                height: 22.rH(context),
                width: 22.rW(context),
              ),
            ),
            SizedBox(width: 16.rW(context)),
            //! Title
            Expanded(
              child: Text(
                title,
                style: Styles.medium15(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            //! Suffix
            trailingWidget ??
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.greyText,
                )
          ],
        ),
      ),
    );
  }
}
