import '../imports/imports.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.heightBetweenPopAndTitle,
    this.popOnTap,
  });

  final String title, subtitle;
  final double? heightBetweenPopAndTitle;
  final Function()? popOnTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: 49.rH(context)),
          //! Pop Button
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: CustomPopButton(
              popOnTap: popOnTap,
            ),
          ),
          SizedBox(height: heightBetweenPopAndTitle ?? 83.rH(context)),
          //! Title
          Text(
            title,
            style: Styles.bold24primary(context),
          ),
          SizedBox(height: 9.rH(context)),
          //! Subtitle
          Text(
            subtitle,
            style: Styles.regular14(context).copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: heightBetweenPopAndTitle ?? 64.rH(context)),
        ],
      ),
    );
  }
}
