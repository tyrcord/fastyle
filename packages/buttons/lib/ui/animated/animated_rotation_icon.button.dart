// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

class FastAnimatedRotationIconButton2 extends StatefulWidget {
  static const Duration defaultAnimationDuration = Duration(seconds: 2);

  /// Whether the button is enabled.
  final bool isEnabled;

  /// Custom icon for the button (optional).
  final Widget? icon;

  /// The icon alignment.
  final Alignment iconAlignment;

  /// The duration for throttling button taps.
  final Duration trottleTimeDuration;

  /// Whether to throttle button taps.
  final bool shouldTrottleTime;

  /// The color when the button is highlighted.
  final Color? highlightColor;

  /// The color when the button is disabled.
  final Color? disabledColor;

  /// The color when the button is focused.
  final Color? focusColor;

  /// The color when the button is hovered.
  final Color? hoverColor;

  /// The size of the icon.
  final double? iconSize;

  /// The color of the icon.
  final Color? iconColor;

  /// The constraints for the button.
  final BoxConstraints? constraints;

  /// The callback when the button is tapped.
  final VoidCallback? onTap;

  /// The emphasis of the button.
  final FastButtonEmphasis emphasis;

  /// The padding of the button.
  final EdgeInsetsGeometry? padding;

  /// The tooltip message.
  final String? tooltip;

  /// The semantic label of the button.
  final String? semanticLabel;

  /// The debug label of the button to identify it in debug mode.
  final String? debugLabel;

  /// The animation controller.
  final AnimationController? animationController;

  /// The duration of the animation.
  final Duration animationDuration;

  /// Whether to rotate the icon.
  final bool rotate;

  const FastAnimatedRotationIconButton2({
    super.key,
    this.trottleTimeDuration = kFastTrottleTimeDuration,
    this.animationDuration = defaultAnimationDuration,
    this.emphasis = FastButtonEmphasis.low,
    this.iconAlignment = Alignment.center,
    this.shouldTrottleTime = true,
    this.animationController,
    this.isEnabled = true,
    this.rotate = false,
    this.highlightColor,
    this.disabledColor,
    this.semanticLabel,
    this.constraints,
    this.focusColor,
    this.hoverColor,
    this.iconColor,
    this.debugLabel,
    this.iconSize,
    this.tooltip,
    this.padding,
    this.onTap,
    this.icon,
  });

  @override
  FastAnimatedRotationIconButtonState createState() =>
      FastAnimatedRotationIconButtonState();
}

class FastAnimatedRotationIconButtonState
    extends State<FastAnimatedRotationIconButton2>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = widget.animationController ??
        AnimationController(duration: widget.animationDuration, vsync: this);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _updateRotation();
  }

  @override
  void dispose() {
    // Dispose the controller only if it was not provided by the parent widget.
    if (widget.animationController != _controller) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FastAnimatedRotationIconButton2 oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.rotate != widget.rotate) {
      _updateRotation();
    }
  }

  void _updateRotation() {
    if (widget.rotate) {
      _controller.repeat();
    } else {
      _controller
        ..stop()
        ..reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: FastIconButton2(
        icon: RotationTransition(turns: _animation, child: buildIcon(context)),
        trottleTimeDuration: widget.trottleTimeDuration,
        shouldTrottleTime: widget.shouldTrottleTime,
        highlightColor: widget.highlightColor,
        disabledColor: widget.disabledColor,
        iconAlignment: widget.iconAlignment,
        constraints: widget.constraints,
        debugLabel: widget.debugLabel,
        focusColor: widget.focusColor,
        hoverColor: widget.hoverColor,
        iconColor: widget.iconColor,
        isEnabled: widget.isEnabled,
        emphasis: widget.emphasis,
        iconSize: widget.iconSize,
        padding: widget.padding,
        onTap: widget.onTap,
      ),
    );
  }

  @protected
  Widget buildIcon(BuildContext context) {
    if (widget.icon != null) return widget.icon!;

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightArrowsRotate);
    }

    return const FaIcon(FontAwesomeIcons.arrowsRotate);
  }
}
