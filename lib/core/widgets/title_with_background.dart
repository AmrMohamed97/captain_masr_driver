import '../imports/imports.dart';

class TitleWithBackground extends StatelessWidget {
  const TitleWithBackground({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 38.rH(context),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          title,
          style: Styles.medium16Primary(context).copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
}
