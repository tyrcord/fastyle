// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_charts/fastyle_charts.dart';
import 'package:t_helpers/helpers.dart';

abstract class BaseChartPainter extends CustomPainter {
  final List<FastChartData> data;
  final double animationValue;
  final double labelValueThreshold;

  BaseChartPainter({
    required this.data,
    required this.animationValue,
    double? labelValueThreshold = 0.05,
  }) : labelValueThreshold = labelValueThreshold ?? 0.05;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  double degreesToRadian(double degrees) => degrees * (pi / 180);

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

    if (datum.value >= labelValueThreshold) {
      // Draw the percentage text in the middle of the segment
      final textPainter = TextPainter(
        text: TextSpan(
          text: formatPercentage(
            value: datum.value,
            maximumFractionDigits: 1,
            minimumFractionDigits: 0,
          ),
          style: const TextStyle(
            fontWeight: kFastFontWeightLight,
            fontSize: kFastFontSize10,
            color: Colors.white,
          ),
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
}
