import '../imports/imports.dart';

class CustomPopButton extends StatelessWidget {
  const CustomPopButton({
    super.key,
    this.popOnTap,
    this.isWhite = false,
  });

  final Function()? popOnTap;
  final bool isWhite;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: popOnTap ?? () => Navigator.pop(context),
      child: Container(
        width: 38.rH(context),
        height: 38.rH(context),
        decoration: BoxDecoration(
          color: isWhite ? AppColors.white : AppColors.primary,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: isWhite ? AppColors.black : AppColors.white,
            size: 18.rH(context),
          ),
        ),
      ),
    );
  }
}
