import 'package:flutter/material.dart';

class FastLineGraphAppBarPainter extends CustomPainter {
  final double backgroundOpacity;
  final double borderOpacity;
  final double cursorOpacity;
  final double cursorRadius;

  final Color backgroundColor;
  final Color borderColor;
  final Color cursorColor;

  late final Color _backgroundColor;
  late final Color _borderColor;
  late final Color _cursorColor;

  FastLineGraphAppBarPainter({
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.white,
    this.cursorColor = Colors.white,
    this.backgroundOpacity = 1.0,
    this.cursorOpacity = 0.75,
    this.borderOpacity = 1.0,
    this.cursorRadius = 6.0,
  }) {
    _backgroundColor = backgroundColor.withOpacity(backgroundOpacity);
    _borderColor = borderColor.withOpacity(borderOpacity);
    _cursorColor = cursorColor.withOpacity(cursorOpacity);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _paintBackgroundCurve(canvas, size);
    _paintBorderCurve(canvas, size);
    _paintForegroundCurve(canvas, size);
    _paintForegroundBorderCurve(canvas, size);
    _paintCursor(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void _paintCursor(Canvas canvas, Size size) {
    final x = size.width * 0.815;
    final y = size.height * 0.45;
    final center = Offset(x, y);
    final paint = Paint();

    paint.color = cursorColor;
    canvas.drawCircle(center, cursorRadius, paint);

    paint.strokeWidth = 0.5;
    paint.color = _cursorColor;
    canvas.drawLine(center, Offset(x, size.height), paint);
  }

  void _paintForegroundCurve(Canvas canvas, Size size) {
    final background = _makeCurve(size, end: false);
    final paint = Paint();

    paint.color = _backgroundColor;
    background.lineTo(size.width * 0.815, size.height);
    background.lineTo(0, size.height);
    background.close();
    canvas.drawPath(background, paint);
  }

  void _paintForegroundBorderCurve(Canvas canvas, Size size) {
    final border = _makeCurve(size, end: false);
    final paint = Paint();

    paint.style = PaintingStyle.stroke;
    paint.color = borderColor;
    canvas.drawPath(border, paint);
  }

  void _paintBackgroundCurve(Canvas canvas, Size size) {
    final background = _makeCurve(size);
    final paint = Paint();

    paint.color = _backgroundColor;
    background.lineTo(size.width, size.height);
    background.lineTo(0, size.height);
    background.close();
    canvas.drawPath(background, paint);
  }

  void _paintBorderCurve(Canvas canvas, Size size) {
    final border = _makeCurve(size);
    final paint = Paint();

    paint.color = _borderColor;
    paint.style = PaintingStyle.stroke;
    canvas.drawPath(border, paint);
  }

  Path _makeCurve(Size size, {bool end = true}) {
    final height = size.height;
    final width = size.width;
    final path = Path();

    path.moveTo(0, height);
    path.moveTo(0, height * 0.75);

    path.cubicTo(
      0,
      height * 0.75,
      width * 0.015,
      height * 0.55,
      width * 0.0815,
      height * 0.5,
    );

    path.cubicTo(
      width * 0.15,
      height * 0.45,
      width * 0.1875,
      height * 0.625,
      width * 0.255,
      height * 0.625,
    );

    path.cubicTo(
      width * 0.315,
      height * 0.625,
      width * 0.3,
      height * 0.45,
      width * 0.375,
      height * 0.35,
    );

    path.cubicTo(
      width * 0.45,
      height * 0.25,
      width * 0.45,
      height * 0.45,
      width * 0.515,
      height * 0.4,
    );

    path.cubicTo(
      width * 0.55,
      height * 0.35,
      width * 0.575,
      height * 0.225,
      width * 0.645,
      height * 0.1875,
    );
    path.cubicTo(
      width * 0.735,
      height * 0.15,
      width * 0.75,
      height * 0.45,
      width * 0.815,
      height * 0.45,
    );

    if (end) {
      path.cubicTo(
        width * 0.875,
        height * 0.45,
        width * 0.9,
        height * 0.2,
        width,
        height * 0.15,
      );
    }

    return path;
  }
}
