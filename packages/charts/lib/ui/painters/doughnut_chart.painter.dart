// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_charts/fastyle_charts.dart';

class FastDoughnutChartPainter extends BaseChartPainter {
  final double doughnutRatio;

  FastDoughnutChartPainter({
    required super.data,
    required super.animationValue,
    super.labelValueThreshold,
    double? doughnutRatio = 0.5,
  }) : doughnutRatio = doughnutRatio ?? 0.5;

  @override
  void paint(Canvas canvas, Size size) {
    double startAngle = -90.0;
    final radius = size.width / 2;
    final innerRadius = radius * doughnutRatio;
    final strokeWidth = radius - innerRadius;
    final adjustedRadius = radius - strokeWidth / 2;
    final averageRadius = (adjustedRadius + innerRadius) / 2;
    final labelRadius = averageRadius / 0.85;

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
