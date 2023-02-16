import 'dart:math' hide log;

import 'package:flutter/material.dart';

class FastPieGraphAppBarPainter extends CustomPainter {
  final double backgroundOpacity;
  final Color backgroundColor;
  final double borderOpacity;
  final double borderWidth;
  final Color borderColor;

  late final Color _backgroundColor;
  late final Color _borderColor;
  late final double _sweepAngle;

  FastPieGraphAppBarPainter({
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.white,
    this.backgroundOpacity = 1.0,
    this.borderOpacity = 1.0,
    this.borderWidth = 1.0,
  }) {
    _backgroundColor = backgroundColor.withOpacity(backgroundOpacity);
    _borderColor = borderColor.withOpacity(borderOpacity);
    _sweepAngle = pi / 2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final diameter = size.height / 2;
    final radius = diameter / 2;
    final x = size.width / 2 - radius;
    final y = diameter - radius;

    _paintPieCircle(canvas, x, y, diameter);
    _paintPieCircleStroke(canvas, size, x, y, diameter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void _paintPieCircle(Canvas canvas, double x, double y, double diameter) {
    final paint = Paint()..color = _backgroundColor;

    _paintTopHalfArc(canvas, paint, x, y, diameter, true);
    _paintBottomLeftArc(canvas, paint, x, y, diameter, true);
  }

  void _paintPieCircleStroke(
    Canvas canvas,
    Size size,
    double x,
    double y,
    double diameter,
  ) {
    final paint = Paint()
      ..color = _borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final center = Offset(centerX, centerY);

    canvas.drawLine(center, Offset(centerX, y + diameter), paint);
    canvas.drawLine(center, Offset(x + diameter, centerY), paint);

    _paintTopHalfArc(canvas, paint, x, y, diameter);
    _paintBottomLeftArc(canvas, paint, x, y, diameter);
  }

  void _paintTopHalfArc(
    Canvas canvas,
    Paint paint,
    double x,
    double y,
    double diameter, [
    bool useCenter = false,
  ]) {
    canvas.drawArc(
      Rect.fromLTWH(x, y, diameter, diameter),
      0,
      -pi,
      useCenter,
      paint,
    );
  }

  void _paintBottomLeftArc(
    Canvas canvas,
    Paint paint,
    double x,
    double y,
    double diameter, [
    bool useCenter = false,
  ]) {
    canvas.drawArc(
      Rect.fromLTWH(x, y, diameter, diameter),
      _sweepAngle,
      _sweepAngle,
      useCenter,
      paint,
    );
  }
}
