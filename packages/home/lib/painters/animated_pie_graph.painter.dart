// Dart imports:
import 'dart:math' hide log;

// Flutter imports:
import 'package:flutter/material.dart';

class FastAnimatedPieGraphPainter extends CustomPainter {
  final Animation<double> animation;
  final double backgroundOpacity;
  final Color backgroundColor;
  final double borderOpacity;
  final double borderWidth;
  final Color borderColor;

  late final Color _backgroundColor;
  late final Color _borderColor;
  late final double _sweepAngle;

  FastAnimatedPieGraphPainter({
    required this.animation,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.white,
    this.backgroundOpacity = 1.0,
    this.borderOpacity = 1.0,
    this.borderWidth = 1.0,
  }) : super(repaint: animation) {
    _backgroundColor = backgroundColor.withOpacity(backgroundOpacity);
    _borderColor = borderColor.withOpacity(borderOpacity);
    _sweepAngle = pi / 2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _paintAnimatedCursor(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void _paintAnimatedCursor(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final diameter = centerY;
    final radius = diameter / 2;
    final maxRadius = diameter / 1.75;
    final distance = maxRadius - radius;
    final x = centerX - (radius - distance * animation.value);
    final y = diameter - (radius - distance * animation.value);
    final offset = radius / 4 + distance * animation.value;
    final paint = Paint();

    canvas
      ..drawArc(
        Rect.fromLTWH(x, y, diameter, diameter),
        0,
        _sweepAngle,
        true,
        paint..color = _backgroundColor,
      )
      ..drawArc(
        Rect.fromLTWH(x, y, diameter, diameter),
        0,
        _sweepAngle,
        true,
        paint
          ..color = _borderColor
          ..strokeWidth = borderWidth
          ..style = PaintingStyle.stroke,
      );

    TextPainter(
      text: TextSpan(
        style: TextStyle(color: _borderColor, fontSize: size.height / 12),
        text: '%',
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout(minWidth: 0, maxWidth: size.width)
      ..paint(
        canvas,
        Offset(centerX + offset, centerY + offset),
      );
  }
}
