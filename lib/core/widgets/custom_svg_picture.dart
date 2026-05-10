import 'package:flutter_svg/svg.dart';

import '../imports/imports.dart';

class CustomSvgPicture extends StatelessWidget {
  const CustomSvgPicture({
    super.key,
    required this.svg,
    this.height,
    this.width,
    this.color,
    this.fit = BoxFit.contain,
  });

  final String svg;
  final double? height, width;
  final Color? color;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svg,
      colorFilter: color != null
          ? ColorFilter.mode(
              color!,
              BlendMode.srcIn,
            )
          : null,
      height: height,
      width: width,
      fit: fit,
    );
  }
}
