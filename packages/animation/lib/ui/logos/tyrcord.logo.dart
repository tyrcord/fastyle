// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_animation/fastyle_animation.dart';

class FastTyrcordAnimatedLogo extends StatefulWidget {
  const FastTyrcordAnimatedLogo({super.key});

  @override
  FastTyrcordAnimatedLogoState createState() => FastTyrcordAnimatedLogoState();
}

class FastTyrcordAnimatedLogoState extends State<FastTyrcordAnimatedLogo>
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
        if (mounted) {
          if (status == AnimationStatus.completed) {
            await Future.delayed(const Duration(milliseconds: 600));
            _controller.reverse();
          } else if (status == AnimationStatus.dismissed) {
            await Future.delayed(const Duration(milliseconds: 600));
            _controller.forward();
          }
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: FastTyrcordLogoPainter(animationController: _controller),
      size: const Size(64, 64),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
