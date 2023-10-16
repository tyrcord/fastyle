import 'package:flutter/material.dart';
import 'package:fastyle_animation/fastyle_animation.dart';

// A widget that displays an animated logo for FastTyrcord.
class FastTyrcordAnimatedLogo extends StatefulWidget {
  // Constructor for creating a FastTyrcordAnimatedLogo.
  const FastTyrcordAnimatedLogo({super.key});

  @override
  FastTyrcordAnimatedLogoState createState() => FastTyrcordAnimatedLogoState();
}

// The state class for managing the animation of the FastTyrcord logo.
class FastTyrcordAnimatedLogoState extends State<FastTyrcordAnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Animation duration can be adjusted if required.
  static const _animationDuration = Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    _initializeAnimationController();
  }

  @override
  void dispose() {
    _animationController.dispose(); // Properly dispose of the controller.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: FastTyrcordLogoPainter(
        animationController: _animationController,
      ),
      size: const Size(64, 64),
    );
  }

  // Initializes the animation controller and starts the animation.
  void _initializeAnimationController() {
    _animationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    )..forward();

    // Adding a status listener to handle forward-reverse animation logic.
    _animationController.addStatusListener(_animationStatusListener);
  }

  // Logic to handle what happens when animation status changes.
  void _animationStatusListener(AnimationStatus status) async {
    if (!mounted) return;

    if (status == AnimationStatus.completed) {
      await _pauseBeforeReverse();
      if (mounted) _animationController.reverse();
    } else if (status == AnimationStatus.dismissed) {
      await _pauseBeforeProceeding();
      if (mounted) _animationController.forward();
    }
  }

  // Pauses the animation upon completion before reversing.
  Future<void> _pauseBeforeReverse() async {
    return Future.delayed(_animationDuration);
  }

  // Pauses the animation when dismissed before proceeding.
  Future<void> _pauseBeforeProceeding() async {
    return Future.delayed(_animationDuration);
  }
}
