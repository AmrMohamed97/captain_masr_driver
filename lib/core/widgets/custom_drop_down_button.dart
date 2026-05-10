import '../imports/imports.dart';

class CustomDropDownButton extends StatelessWidget {
  const CustomDropDownButton({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText,
    this.prefixIcon,
    this.validator,
    this.title,
    this.icon,
    this.padding,
    this.fillColor,
    this.itemsBuilder,
  });

  final String? title;
  final dynamic value;
  final List<dynamic> items;
  final Function(dynamic)? onChanged;
  final String? hintText;
  final Widget? prefixIcon;
  final String? Function(Object?)? validator;
  final Widget? icon;
  final EdgeInsets? padding;
  final Color? fillColor;
  final List<DropdownMenuItem<Object>>? itemsBuilder;

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
        DropdownButtonFormField(
          value: value,
          items: itemsBuilder ??
              items
                  .map((e) => DropdownMenuItem(
                        alignment: Alignment.center,
                        value: e,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              e,
                              style: Styles.medium14(context).copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
          onChanged: onChanged,
          validator: validator,
          dropdownColor: Theme.of(context).cardColor,
          icon: icon ??
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.greyText,
              ),
          hint: hintText != null
              ? Text(
                  hintText!,
                  style: Styles.regular14(context).copyWith(
                    color: AppColors.greyText,
                  ),
                )
              : null,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor:
                fillColor ?? Theme.of(context).inputDecorationTheme.fillColor,
            contentPadding: padding ??
                EdgeInsets.symmetric(
                  horizontal: 16.rW(context),
                  vertical: 16.rH(context),
                ),
            prefixIcon: prefixIcon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      prefixIcon!,
                    ],
                  )
                : null,
            border: border(),
            enabledBorder: border(),
            focusedBorder: border(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder border({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color ?? AppColors.transparent),
    );
  }
}
