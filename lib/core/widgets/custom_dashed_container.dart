import 'dart:ui';

import 'package:flutter/material.dart';

class CustomDashedContainer extends StatelessWidget {
  const CustomDashedContainer({
    super.key,
    required this.child,
    this.color,
    this.radius,
    this.dashWidth,
  });

  final Widget child;
  final Color? color;
  final double? radius, dashWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashRectPainter(
        color: color,
        radius: radius,
        dashWidth: dashWidth,
      ),
      child: child,
    );
  }
}

class DashRectPainter extends CustomPainter {
  final Color? color;
  final double? radius, dashWidth;

  DashRectPainter({
    super.repaint,
    this.color,
    this.radius,
    this.dashWidth = 8,
  });
  @override
  void paint(Canvas canvas, Size size) {
    const double dashSpace = 5;
    final paint = Paint()
      ..color = color ?? Colors.grey.withOpacity(.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius ?? 16),
    );

    final Path path = Path()..addRRect(rrect);
    canvas.drawPath(_createDashedPath(path, dashWidth ?? 8, dashSpace), paint);
  }

  Path _createDashedPath(Path path, double dashWidth, double dashSpace) {
    final Path dashedPath = Path();
    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        dashedPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    return dashedPath;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
