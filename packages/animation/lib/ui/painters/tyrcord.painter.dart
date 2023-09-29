// Flutter imports:
import 'package:flutter/material.dart';

class FastTyrcordLogoPainter extends CustomPainter {
  final AnimationController animationController;
  final Color color;

  FastTyrcordLogoPainter({
    required this.animationController,
    this.color = const Color(0xFF434343),
  }) : super(repaint: animationController);

  @override
  void paint(Canvas canvas, Size size) {
    final double progress = animationController.value;

    final paint = Paint()..color = color;

    final double rectWidth = size.width * 0.125; // 12.5% of canvas width
    final double rectHeight = size.height * 0.125; // 12.5% of canvas height

    // Top-left rectangle
    final double tlStartX = size.width * 0.18; // 18% of canvas width
    final double tlX = tlStartX - tlStartX * progress;
    final double tlWidth = tlStartX - tlX + rectWidth;
    canvas.drawRect(Rect.fromLTWH(tlX, 0, tlWidth, rectHeight), paint);

    // Top-right rectangle
    final double trStartX = size.width * 0.35; // 35% of canvas width
    final double trEndWidth = size.width * 0.65; // 65% of canvas width
    final double trWidth = progress * (trEndWidth - rectWidth) + rectWidth;
    canvas.drawRect(Rect.fromLTWH(trStartX, 0, trWidth, rectHeight), paint);

    // Bottom-right rectangle
    final double brStartX = size.width * 0.35; // 35% of canvas width
    final double brStartY = size.height * 0.875; // 87.5% of canvas height
    final double brEndHeight = size.height * 0.875; // 87.5% of canvas height
    final double brHeight = progress * (brEndHeight - rectHeight) + rectHeight;
    final double brY = brStartY - brHeight + rectHeight;
    canvas.drawRect(Rect.fromLTWH(brStartX, brY, rectWidth, brHeight), paint);

    // Bottom-left rectangle
    final double blStartX = size.width * 0.18; // 18% of canvas width
    final double blStartY = size.height * 0.875; // 87.5% of canvas height
    final double blEndHeight = size.height * 0.83; // 83% of canvas height
    final double blHeight = progress * (blEndHeight - rectHeight) + rectHeight;
    final double blY = blStartY - blHeight + rectHeight;
    canvas.drawRect(Rect.fromLTWH(blStartX, blY, rectWidth, blHeight), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
