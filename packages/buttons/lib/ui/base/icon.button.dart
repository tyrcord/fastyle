// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';

class FastIconButton2 extends FastButton2 {
  /// The icon alignment.
  final Alignment? iconAlignment;

  /// The size of the icon.
  final double? iconSize;

  /// The color of the icon.
  final Color? iconColor;

  /// Custom icon for the button (optional).
  final Widget icon;

  const FastIconButton2({
    super.key,
    required this.icon,
    super.trottleTimeDuration = kFastButtonTrottleTimeDuration,
    super.emphasis = FastButtonEmphasis.low,
    super.shouldTrottleTime = false,
    super.isEnabled = true,
    super.highlightColor,
    super.disabledColor,
    super.semanticLabel,
    this.iconAlignment,
    super.constraints,
    super.focusColor,
    super.hoverColor,
    super.debugLabel,
    this.iconColor,
    this.iconSize,
    super.padding,
    super.tooltip,
    super.onTap,
  });

  @override
  State<FastIconButton2> createState() => _FastIconButton2State();
}

class _FastIconButton2State extends State<FastIconButton2>
    with FastButtonMixin2, FastThrottleButtonMixin2<FastIconButton2> {
  @override
  Widget build(BuildContext context) {
    return buildButton(
      context,
      buildIcon(
        context,
        icon: widget.icon,
        disabledColor: widget.disabledColor,
        iconColor: widget.iconColor,
        isEnabled: widget.isEnabled,
        iconSize: widget.iconSize,
        emphasis: widget.emphasis,
      ),
      constraints: widget.constraints ?? kFastIconButtonConstraints,
      highlightColor: widget.highlightColor,
      semanticLabel: widget.semanticLabel,
      alignment: widget.iconAlignment,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      isEnabled: widget.isEnabled,
      emphasis: widget.emphasis,
      tooltip: widget.tooltip,
      padding: widget.padding,
      color: widget.iconColor,
      onTap: onTapCallback,
      icon: widget.icon,
    );
  }

  Widget buildIcon(
    BuildContext context, {
    required Widget icon,
    FastButtonEmphasis? emphasis,
    bool isEnabled = true,
    Color? disabledColor,
    Color? iconColor,
    double? iconSize,
  }) {
    return IconTheme(
      data: IconThemeData(
        color: getColor(
          context,
          disabledColor: disabledColor,
          isEnabled: isEnabled,
          emphasis: emphasis,
          color: iconColor,
          icon: icon,
        ),
        size: getIconSize(
          context,
          iconSize: iconSize,
          icon: icon,
        ),
      ),
      child: icon,
    );
  }
}
