import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fastyle_charts/fastyle_charts.dart';

class FastDoughnutChartPainter extends CustomPainter {
  final List<FastChartData> data;
  final double animationValue;
  final double doughnutRatio;

  FastDoughnutChartPainter(
    this.data,
    this.animationValue, {
    this.doughnutRatio = 0.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double startAngle = -90.0;

    final radius = size.width / 2;
    final innerRadius = radius * doughnutRatio;
    final strokeWidth = radius - innerRadius;
    final adjustedRadius = radius - strokeWidth / 2;

    final rect = Rect.fromCircle(
      center: Offset(radius, radius),
      radius: adjustedRadius,
    );

    for (final datum in data) {
      final sweepAngle = 360 * datum.tween.transform(animationValue);
      final paint = Paint()
        ..color = datum.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawArc(
        rect,
        degreesToRadian(startAngle),
        degreesToRadian(sweepAngle),
        false,
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

      final averageRadius = (adjustedRadius + innerRadius) / 2;
      final labelAngle = startAngle + sweepAngle / 2;
      final labelRadius = averageRadius / 0.85;
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
