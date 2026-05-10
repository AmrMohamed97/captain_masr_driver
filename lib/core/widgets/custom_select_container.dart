import '../imports/imports.dart';

class CustomSelectContainer extends StatelessWidget {
  const CustomSelectContainer({
    super.key,
    required this.value,
    this.hint,
    this.svg,
    required this.onTap,
    this.icon,
    this.validationText,
    this.enabled = true,
    this.borderColor,
    this.fillColor,
    this.svgColor,
    this.title,
    this.padding,
    this.height,
  });

  final String? value, hint, svg, validationText, title;
  final Function() onTap;
  final bool enabled;
  final Widget? icon;
  final Color? borderColor, fillColor, svgColor;
  final EdgeInsetsGeometry? padding;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
        GestureDetector(
          onTap: enabled ? onTap : null,
          child: Container(
            width: double.infinity,
            height: height ?? 45.rH(context),
            padding: padding ?? EdgeInsets.symmetric(horizontal: 8.rW(context)),
            decoration: BoxDecoration(
              color: fillColor ?? AppColors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: validationText != null
                    ? AppColors.red
                    : (borderColor ?? AppColors.grey.withOpacity(.5)),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                if (svg != null)
                  CustomSvgPicture(
                    svg: svg!,
                    height: 20.rH(context),
                    color: !enabled ? AppColors.grey : svgColor,
                    fit: BoxFit.scaleDown,
                  ),
                SizedBox(width: 8.rW(context)),
                if (value != null)
                  Expanded(
                    child: FittedBox(
                      alignment: AlignmentDirectional.centerStart,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        value!,
                        style: Styles.regular14(context).copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                if (value == null && hint != null)
                  Expanded(
                    child: Text(
                      hint!,
                      style: Styles.regular12(context).copyWith(
                        color: AppColors.greyText,
                      ),
                    ),
                  ),
                if (value == null && hint == null) const Spacer(),
                SizedBox(width: 8.rW(context)),
                if (icon == null)
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.greyText,
                  ),
                if (icon != null) icon!,
              ],
            ),
          ),
        ),
        if (validationText != null)
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: 4.rW(context),
              top: 4.rH(context),
            ),
            child: Text(
              validationText!,
              style: Theme.of(context).inputDecorationTheme.errorStyle,
            ),
          ),
      ],
    );
  }
}
