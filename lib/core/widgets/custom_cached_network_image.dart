import 'package:cached_network_image/cached_network_image.dart';

import '../imports/imports.dart';
import 'custom_shimmer.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.h,
    this.w,
    this.borderRadius,
    this.fit,
    this.errorWidget,
  });

  final String? imageUrl;
  final double? h, w, borderRadius;
  final BoxFit? fit;
  final Widget Function(BuildContext, String, Object)? errorWidget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: h ?? 100.rH(context),
      width: w ?? 100.rW(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        child: CachedNetworkImage(
          imageUrl: imageUrl ?? "",
          placeholder: (context, url) => CustomShimmer(
            h: h,
            w: w,
            borderRadius: borderRadius,
          ),
          errorWidget:
              errorWidget ?? (context, url, error) => const Icon(Icons.error),
          fit: fit ?? BoxFit.cover,
        ),
      ),
    );
  }
}
