import 'package:flutter/material.dart';
import 'package:fastyle_charts/fastyle_charts.dart';

class FastPieChartPainter extends BaseChartPainter {
  FastPieChartPainter({
    required super.data,
    required super.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double startAngle = -90.0;
    final radius = size.width / 2;
    final labelRadius = radius / 1.5;

    final rect = Rect.fromCircle(
      center: Offset(radius, radius),
      radius: radius,
    );

    for (final datum in data) {
      final sweepAngle = 360 * datum.tween.transform(animationValue);
      final paint = Paint()
        ..color = datum.color
        ..style = PaintingStyle.fill;

      drawSegment(
        canvas,
        datum,
        startAngle,
        sweepAngle,
        paint,
        rect,
        radius,
        labelRadius,
      );

      startAngle += sweepAngle;
    }
  }
}
