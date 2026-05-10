import 'package:flutter/cupertino.dart';

import '../imports/imports.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.icon,
    this.traillingIcon,
    this.color,
    this.textColor,
    this.widgth = double.infinity,
    this.borderColor,
    this.padding,
    this.height,
    this.enabled = true,
    this.iconEndPadding,
    this.loading = false,
  });

  final String title;
  final Widget? icon, traillingIcon;
  final Function() onPressed;
  final Color? color, textColor, borderColor;
  final double? widgth, height, iconEndPadding;
  final EdgeInsets? padding;
  final bool enabled, loading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: widgth,
        height: height ?? 46.rH(context),
        padding: padding ?? EdgeInsets.symmetric(horizontal: 12.rW(context)),
        decoration: BoxDecoration(
          color: enabled
              ? (color ?? AppColors.primary)
              : AppColors.primary.withOpacity(.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: borderColor ?? AppColors.transparent,
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: iconEndPadding ?? 16.rW(context),
                  ),
                  child: icon,
                ),
                loading?
                CupertinoActivityIndicator(
                  color: textColor ?? AppColors.white,
                ):
              Text(
                title,
                style: Styles.semibold16Primary(context).copyWith(
                  color: textColor ?? AppColors.white,
                ),
              ),
              if (traillingIcon != null)
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: 12.rW(context),
                  ),
                  child: traillingIcon,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
