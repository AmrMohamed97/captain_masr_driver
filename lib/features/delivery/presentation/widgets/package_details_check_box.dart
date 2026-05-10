import 'package:flutter_svg/svg.dart';

import '../../../../core/imports/imports.dart';

class PackageDetailsCheckBox extends StatelessWidget {
  const PackageDetailsCheckBox({
    super.key,
    required this.title,
    this.svg,
    required this.onTap,
    required this.selected,
    this.isExpanded = true,
  });

  final String title;
  final String? svg;
  final Function() onTap;
  final bool selected, isExpanded;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        width: isExpanded ? double.infinity : null,
        height: 43.rH(context),
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 12.rW(context)),
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
          children: [
            //! Svg
            if (svg != null)
              SizedBox(
                height: 19.rH(context),
                child: svg!.contains(".svg")
                    ? SvgPicture.network(
                        svg!,
                        height: 19.rH(context),
                        errorBuilder: (context, error, stackTrace) =>
                            Container(),
                      )
                    : Image.network(
                        svg!,
                        height: 19.rH(context),
                        errorBuilder: (context, error, stackTrace) =>
                            Container(),
                      ),
              ),
            if (svg != null) SizedBox(width: 12.rW(context)),

            //! Title
            if (isExpanded)
              Expanded(
                child: Text(
                  title,
                  style: Styles.regular14(context).copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),

            if (!isExpanded)
              Text(
                title,
                style: Styles.regular14(context).copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),

            SizedBox(width: 8.rW(context)),

            //! Check Box
            CustomCheckBox(
              value: selected,
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
