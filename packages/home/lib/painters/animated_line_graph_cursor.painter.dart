// Flutter imports:
import 'package:flutter/material.dart';

class FastAnimatedLineGraphCursorPainter extends CustomPainter {
  final Animation<double> animation;
  final double maxRadius;
  final double minRadius;
  final double opacity;
  final Color color;

  late final double _distance;
  late final Color _color;

  FastAnimatedLineGraphCursorPainter({
    required this.animation,
    this.color = Colors.white,
    this.opacity = 0.25,
    this.maxRadius = 12,
    this.minRadius = 6,
  }) : super(repaint: animation) {
    _distance = maxRadius - minRadius;
    _color = color.withOpacity(opacity);
  }

  @override
  void paint(Canvas canvas, Size size) => _paintAnimatedCursor(canvas, size);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void _paintAnimatedCursor(Canvas canvas, Size size) {
    final x = size.width * 0.815;
    final y = size.height * 0.45;

    canvas.drawCircle(
      Offset(x, y),
      minRadius + _distance * animation.value,
      Paint()..color = _color,
    );
  }
}
