import '../imports/imports.dart';

class CustomCricleButton extends StatelessWidget {
  const CustomCricleButton({
    super.key,
    required this.svg,
    required this.onTap,
    this.color,
  });

  final String svg;
  final Function() onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.rH(context),
        height: 36.rH(context),
        decoration: BoxDecoration(
          color: color ?? AppColors.white.withOpacity(.9),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: CustomSvgPicture(
            svg: svg,
            height: 24.rH(context),
          ),
        ),
      ),
    );
  }
}
