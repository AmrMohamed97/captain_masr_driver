import 'package:flutter/cupertino.dart';

import '../imports/imports.dart';

class SinglePartialStar extends StatelessWidget {
  final double value;
  final double starSize;

  const SinglePartialStar({
    super.key,
    required this.value,
    this.starSize = 50,
  });

  @override
  Widget build(BuildContext context) {
    final double fill = (value / 5).clamp(0.0, 1.0);

    return Stack(
      children: [
        Icon(
          CupertinoIcons.star_fill,
          color: Colors.grey[300],
          size: starSize,
        ),
        ClipRect(
          clipper: _PartialClipper(fill),
          child: Icon(
            CupertinoIcons.star_fill,
            color: Colors.amber,
            size: starSize,
          ),
        ),
      ],
    );
  }
}

class _PartialClipper extends CustomClipper<Rect> {
  final double fill;

  _PartialClipper(this.fill);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * fill, size.height);
  }

  @override
  bool shouldReclip(covariant _PartialClipper oldClipper) {
    return oldClipper.fill != fill;
  }
}
