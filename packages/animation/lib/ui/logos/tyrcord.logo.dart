// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_animation/fastyle_animation.dart';

// A widget that displays an animated logo for Tyrcord.
class FastTyrcordAnimatedLogo extends StatefulWidget {
  /// The size of the logo.
  final Size size;

  /// The duration of the animation.
  final Duration animationDuration;

  /// The curve of the animation.
  final Curve animationCurve;

  /// The color of the logo.
  final Color color;

  /// Constructor for creating a FastTyrcordAnimatedLogo.
  const FastTyrcordAnimatedLogo({
    super.key,
    this.animationDuration = const Duration(milliseconds: 600),
    this.animationCurve = Curves.easeInOut,
    this.color = const Color(0xFF434343),
    this.size = const Size(64, 64),
  });

  @override
  FastTyrcordAnimatedLogoState createState() => FastTyrcordAnimatedLogoState();
}

// The state class for managing the animation of the Tyrcord logo.
class FastTyrcordAnimatedLogoState extends State<FastTyrcordAnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

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
    return Semantics(
      label: 'Animated Tyrcord Logo',
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: FastTyrcordLogoPainter(
                progress: _animation.value,
                color: widget.color,
              ),
              size: widget.size,
            );
          },
        ),
      ),
    );
  }

  // Initializes the animation controller and starts the animation.
  void _initializeAnimationController() {
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    );

    // Adding a status listener to handle forward-reverse animation logic.
    _animationController
      ..addStatusListener(_animationStatusListener)
      ..forward();
  }

  // Logic to handle what happens when animation status changes.
  void _animationStatusListener(AnimationStatus status) async {
    if (!mounted) return;

    switch (status) {
      case AnimationStatus.completed:
        _handleAnimationCompleted();
      case AnimationStatus.dismissed:
        _handleAnimationDismissed();
      default:
      // Do nothing for other statuses
    }
  }

  /// Handles the animation when it completes.
  Future<void> _handleAnimationCompleted() async {
    await Future.delayed(widget.animationDuration);

    if (mounted) _animationController.reverse();
  }

  /// Handles the animation when it's dismissed.
  Future<void> _handleAnimationDismissed() async {
    await Future.delayed(widget.animationDuration);

    if (mounted) _animationController.forward();
  }
}
