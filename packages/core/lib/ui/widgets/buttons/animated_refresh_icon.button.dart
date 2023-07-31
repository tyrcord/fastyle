// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastAnimatedRotationIconButton extends StatefulWidget {
  final AnimationController? animationController;
  final EdgeInsetsGeometry padding;
  final Alignment iconAlignment;
  final bool shouldTrottleTime;
  final Color? disabledColor;
  final VoidCallback onTap;
  final Color? iconColor;
  final double iconSize;
  final bool isEnabled;
  final Widget? icon;
  final bool rotate;

  const FastAnimatedRotationIconButton({
    Key? key,
    required this.onTap,
    this.iconAlignment = Alignment.center,
    this.iconSize = kFastIconSizeSmall,
    this.padding = kFastEdgeInsets8,
    this.shouldTrottleTime = false,
    this.isEnabled = true,
    this.rotate = false,
    this.animationController,
    this.disabledColor,
    this.iconColor,
    this.icon,
  }) : super(key: key);

  @override
  FastAnimatedRotationIconButtonState createState() =>
      FastAnimatedRotationIconButtonState();
}

class FastAnimatedRotationIconButtonState
    extends State<FastAnimatedRotationIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.animationController ??
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _rotateIcon(widget.rotate);
  }

  @override
  void dispose() {
    if (widget.animationController != _controller) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FastAnimatedRotationIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.rotate != widget.rotate) {
      _rotateIcon(widget.rotate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: FastIconButton(
        shouldTrottleTime: widget.shouldTrottleTime,
        iconAlignment: widget.iconAlignment,
        disabledColor: widget.disabledColor,
        iconColor: widget.iconColor,
        isEnabled: widget.isEnabled,
        iconSize: widget.iconSize,
        padding: widget.padding,
        onTap: widget.onTap,
        icon: RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
          child: widget.icon ?? const FaIcon(FontAwesomeIcons.arrowsRotate),
        ),
      ),
    );
  }

  void _rotateIcon(bool animate) {
    if (animate) {
      _controller.repeat();
    } else {
      _controller.reset();
    }
  }
}
