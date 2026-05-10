import 'package:flutter_svg/svg.dart';

import '../imports/imports.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    this.title,
    this.hintText,
    this.svgIcon,
    this.showPasswordSuffix = false,
    this.obscure = false,
    this.enabled = true,
    this.passwordSufficOnTap,
    this.validator,
    this.keyboardType,
    this.suffixIcon,
    this.onTap,
    this.fillColor,
    this.maxLines = 1,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? title, hintText, svgIcon;
  final bool showPasswordSuffix, obscure, enabled;
  final Function()? passwordSufficOnTap;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Function()? onTap;
  final Color? fillColor;
  final int? maxLines;
  final dynamic Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8.rH(context)),
            child: Text(
              title!,
              style: Styles.regular14(context).copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        CustomTextField(
          controller: controller,
          validator: validator,
          hintText: hintText,
          keyboardType: keyboardType,
          obscureText: obscure,
          onTap: onTap,
          onChanged: onChanged,
          enabled: enabled,
          maxLines: maxLines,
          fillColor: fillColor,
          prefixIcon: svgIcon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 18.rH(context),
                      width: 20.rW(context),
                      child: SvgPicture.asset(
                        svgIcon!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                )
              : null,
          suffixIcon: suffixIcon ??
              (showPasswordSuffix
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: passwordSufficOnTap,
                          child: SvgPicture.asset(
                            !obscure
                                ? Assets.imagesEyeVisibilityOn
                                : Assets.imagesEyeVisibilityOff,
                            height: 24.rH(context),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    )
                  : null),
        ),
        SizedBox(height: 16.rH(context)),
      ],
    );
  }
}
