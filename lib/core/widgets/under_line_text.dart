import '../imports/imports.dart';

class UnderLineText extends StatelessWidget {
  const UnderLineText({
    super.key,
    required this.text,
    this.onTap,
  });

  final String text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.primary,
              width: 1,
            ),
          ),
        ),
        child: Text(
          text,
          style: Styles.medium14(context).copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
