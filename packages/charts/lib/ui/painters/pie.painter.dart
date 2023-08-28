import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fastyle_charts/fastyle_charts.dart';

class FastPieChartPainter extends CustomPainter {
  final List<FastChartData> data;
  final double animationValue;

  FastPieChartPainter(this.data, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    double startAngle = -90.0;

    final radius = size.width / 2;
    final rect = Rect.fromCircle(
      center: Offset(radius, radius),
      radius: radius,
    );

    for (final datum in data) {
      final sweepAngle = 360 * datum.tween.transform(animationValue);
      final paint = Paint()
        ..color = datum.color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        rect,
        degreesToRadian(startAngle),
        degreesToRadian(sweepAngle),
        true,
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
      final labelRadius = radius / 1.5;
      final labelX = radius + labelRadius * cos(degreesToRadian(labelAngle));
      final labelY = radius + labelRadius * sin(degreesToRadian(labelAngle));

      textPainter.paint(
        canvas,
        Offset(labelX - textPainter.width / 2, labelY - textPainter.height / 2),
      );

      startAngle += sweepAngle;
    }
  }

  double degreesToRadian(double degrees) {
    return degrees * (3.14 / 180);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
