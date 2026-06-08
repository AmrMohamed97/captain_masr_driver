import '../imports/imports.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.onTap,
    this.enabled = true,
    this.fillColor,
    this.maxLines = 1,
    this.contentPadding,
    this.onEditingComplete,
    this.onChanged,
    this.borderColor,
    this.focusNode,
    this.helper,
    this.borderRadius,
    this.borderSideColor,
  });

  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon, suffixIcon;
  final bool obscureText, enabled;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Function()? onTap;
  final Color? fillColor, borderColor;
  final int? maxLines;
  final EdgeInsets? contentPadding;
  final Function()? onEditingComplete;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final Widget? helper;
  final double? borderRadius;
  final Color? borderSideColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      validator: validator,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: Styles.regular14(context).copyWith(
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      decoration: InputDecoration(
        helper: helper,
        hintText: hintText,
        hintStyle: Styles.regular14(context).copyWith(
          color: AppColors.greyText,
        ),
        filled: true,
        fillColor:
            fillColor ?? Theme.of(context).inputDecorationTheme.fillColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 16.rW(context),
              vertical: 16.rH(context),
            ),
        border: border(color: borderColor ?? borderSideColor),
        enabledBorder: border(color: borderColor ?? borderSideColor),
        disabledBorder: border(color: borderColor ?? borderSideColor),
        focusedBorder: border(color: borderColor ?? AppColors.primary),
      ),
    );
  }

  OutlineInputBorder border({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? 8),
      borderSide: BorderSide(color: color ?? AppColors.transparent),
    );
  }
}
