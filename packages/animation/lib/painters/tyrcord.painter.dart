import 'package:flutter/material.dart';

class RectAnimationPainter extends StatefulWidget {
  const RectAnimationPainter({super.key});

  @override
  _RectAnimationPainterState createState() => _RectAnimationPainterState();
}

class _RectAnimationPainterState extends State<RectAnimationPainter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )
      ..forward()
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          await Future.delayed(const Duration(milliseconds: 600));
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          await Future.delayed(const Duration(milliseconds: 600));
          _controller.forward();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RectPainter(animationController: _controller),
      size: const Size(512, 512),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class RectPainter extends CustomPainter {
  final AnimationController animationController;

  RectPainter({
    required this.animationController,
  }) : super(repaint: animationController);

  static const double RECT_WIDTH = 64.0;
  static const double RECT_HEIGHT = 64.0;
  static const Color FILL_COLOR = Color(0xFF434343);

  @override
  void paint(Canvas canvas, Size size) {
    final double progress = animationController.value;

    final paint = Paint()..color = FILL_COLOR;

    // Top-left rectangle
    final double tlStartX = 92;
    final double tlX = tlStartX - tlStartX * progress;
    final double tlWidth = tlStartX - tlX + RECT_WIDTH;
    canvas.drawRect(Rect.fromLTWH(tlX, 0, tlWidth, RECT_HEIGHT), paint);

    // Top-right rectangle
    final double trStartX = 180;
    final double trEndWidth = 332;
    final double trWidth = progress * (trEndWidth - RECT_WIDTH) + RECT_WIDTH;
    canvas.drawRect(Rect.fromLTWH(trStartX, 0, trWidth, RECT_HEIGHT), paint);

    // Bottom-right rectangle
    final double brStartX = 180;
    final double brStartY = 448;
    final double brEndHeight = 448;
    final double brHeight =
        progress * (brEndHeight - RECT_HEIGHT) + RECT_HEIGHT;
    final double brY = brStartY - brHeight + RECT_HEIGHT;
    canvas.drawRect(Rect.fromLTWH(brStartX, brY, RECT_WIDTH, brHeight), paint);

    // Bottom-left rectangle
    final double blStartX = 92;
    final double blStartY = 448;
    final double blEndHeight = 424;
    final double blHeight =
        progress * (blEndHeight - RECT_HEIGHT) + RECT_HEIGHT;
    final double blY = blStartY - blHeight + RECT_HEIGHT;
    canvas.drawRect(Rect.fromLTWH(blStartX, blY, RECT_WIDTH, blHeight), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
