import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fastyle_charts/fastyle_charts.dart';

abstract class BaseChartPainter extends CustomPainter {
  final List<FastChartData> data;
  final double animationValue;

  BaseChartPainter({
    required this.data,
    required this.animationValue,
  });

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  double degreesToRadian(double degrees) {
    return degrees * (pi / 180);
  }

  void drawSegment(
    Canvas canvas,
    FastChartData datum,
    double startAngle,
    double sweepAngle,
    Paint paint,
    Rect rect,
    double radius,
    double labelRadius,
  ) {
    canvas.drawArc(
      rect,
      degreesToRadian(startAngle),
      degreesToRadian(sweepAngle),
      paint.style == PaintingStyle.fill,
      paint,
    );

    // Draw the percentage text in the middle of the segment
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(datum.value * 100).toStringAsFixed(0)}%',
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final labelAngle = startAngle + sweepAngle / 2;
    final labelX = radius + labelRadius * cos(degreesToRadian(labelAngle));
    final labelY = radius + labelRadius * sin(degreesToRadian(labelAngle));

    textPainter.paint(
      canvas,
      Offset(labelX - textPainter.width / 2, labelY - textPainter.height / 2),
    );
  }
}
