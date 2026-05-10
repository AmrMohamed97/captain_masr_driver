import '../../../../core/imports/imports.dart';

class RateChecBoxContainer extends StatelessWidget {
  const RateChecBoxContainer({
    super.key,
    required this.selected,
    required this.onTap,
    required this.title,
  });

  final bool selected;
  final Function() onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 31.rH(context),
        padding: EdgeInsets.symmetric(
          horizontal: 6.rW(context),
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.grey.withOpacity(.20),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank_rounded,
              color: selected ? AppColors.white : AppColors.greyText,
              size: 18.rH(context),
            ),
            SizedBox(width: 6.rW(context)),
            Text(
              title,
              style: Styles.regular14(context).copyWith(
                color: selected
                    ? AppColors.white
                    : Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
