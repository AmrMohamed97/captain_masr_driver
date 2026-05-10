import 'package:flutter_svg/svg.dart';

import '../../../../core/imports/imports.dart';

class CustomBottomSheetSelectContainer extends StatelessWidget {
  const CustomBottomSheetSelectContainer({
    super.key,
    this.title,
    this.value,
    this.svg,
    this.hint,
    this.onTap,
    required this.enabled,
    this.validationText,
  });

  final String? title, value, svg, hint;
  final Function()? onTap;
  final bool enabled;
  final String? validationText;

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
        AnimatedOpacity(
          opacity: enabled ? 1 : .4,
          duration: const Duration(milliseconds: 300),
          child: GestureDetector(
            onTap: enabled ? onTap : null,
            child: Container(
              width: double.infinity,
              height: 51.rH(context),
              padding: EdgeInsets.symmetric(horizontal: 16.rW(context)),
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: validationText != null
                      ? AppColors.red
                      : AppColors.transparent,
                ),
              ),
              child: Row(
                children: [
                  //! Svg
                  if (svg != null)
                    SvgPicture.asset(
                      svg!,
                    ),
                  //! Value
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.rW(context)),
                      child: Text(
                        value ?? hint ?? "",
                        style: Styles.regular14(context).copyWith(
                          color: value != null
                              ? Theme.of(context).textTheme.bodyLarge?.color
                              : AppColors.greyText,
                        ),
                      ),
                    ),
                  ),
                  //! Arrow Icon
                  const Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: AppColors.greyText,
                  ),
                ],
              ),
            ),
          ),
        ),
        //! Validation
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
