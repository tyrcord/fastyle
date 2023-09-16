import 'package:flutter/material.dart';
import 'dart:math';

class FastCircleProgressPainter extends CustomPainter {
  final double currentProgress;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  const FastCircleProgressPainter(
    this.currentProgress, {
    this.progressColor = Colors.blue,
    this.backgroundColor = Colors.grey,
    this.strokeWidth = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // This is the circle for background
    final Paint outerCircle = Paint()
      ..strokeWidth = strokeWidth
      ..color = backgroundColor
      ..style = PaintingStyle.stroke;

    final Paint completeArc = Paint()
      ..strokeWidth = strokeWidth
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

    canvas.drawCircle(center, radius, outerCircle); // Draw the outer circle

    final double angle = 2 * pi * (currentProgress / 100);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      angle,
      false,
      completeArc,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
