import 'package:shimmer/shimmer.dart';

import '../imports/imports.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({
    super.key,
    this.w,
    this.h,
    this.borderRadius,
    this.bottomPadding,
    this.endPadding,
  });

  final double? w, h, borderRadius, bottomPadding, endPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        end: endPadding ?? 0,
        bottom: bottomPadding ?? 0,
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.grey.withOpacity(0.2),
        highlightColor: AppColors.white.withOpacity(.2),
        child: Container(
          width: w ?? 100.rW(context),
          height: h ?? 100.rH(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 4),
            color: AppColors.grey,
          ),
        ),
      ),
    );
  }
}
