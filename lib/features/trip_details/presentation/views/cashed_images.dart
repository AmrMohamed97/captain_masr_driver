import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:photo_view/photo_view.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({
    this.onTap,
    super.key,
    required this.url,
    this.elevation = 0,
    this.radius = 0,
    this.errorWidget,
    this.fit,
    this.height,
    this.width,
    this.isBlur = false,
    this.showImageOnTap = false,
  });
  final String url;
  final Widget? errorWidget;
  final BoxFit? fit;
  final double? height, width;
  final bool isBlur;
  final double radius, elevation;
  final bool showImageOnTap;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showImageOnTap
          ? () {
              if (showImageOnTap) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: PhotoView(
                                imageProvider: CachedNetworkImageProvider(
                                  "${url.contains("http") ? "" : "https://ma3ak.evyx.lol/"}$url",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                );
              }
            }
          : onTap,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        elevation: elevation,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: CachedNetworkImage(
            fit: fit ?? BoxFit.cover,
            height: height,
            width: width,
            colorBlendMode: isBlur ? BlendMode.colorBurn : null,
            color: isBlur ? Colors.black26 : null,
            imageUrl:
                url.contains("http") ? url : "https://ma3ak.evyx.lol/$url",
            filterQuality: FilterQuality.medium,
            placeholder: (context, url) {
              return BlurHash(
                hash: 'LKO2:N%2Tw=w]~RBVZRi};RPxuwH',
                imageFit: fit ?? BoxFit.fill,
              );
            },
            errorWidget: (context, url, error) =>
                errorWidget ?? const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
