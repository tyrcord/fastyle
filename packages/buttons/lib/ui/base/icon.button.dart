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
    super.flexible,
    this.iconColor,
    this.iconSize,
    super.padding,
    super.tooltip,
    super.onTap,
    super.size,
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
        size: widget.size,
      ),
      highlightColor: widget.highlightColor,
      semanticLabel: widget.semanticLabel,
      alignment: widget.iconAlignment,
      constraints: widget.constraints,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      isEnabled: widget.isEnabled,
      emphasis: widget.emphasis,
      flexible: widget.flexible,
      tooltip: widget.tooltip,
      padding: widget.padding,
      color: widget.iconColor,
      onTap: onTapCallback,
      icon: widget.icon,
      size: widget.size,
    );
  }

  Widget buildIcon(
    BuildContext context, {
    required Widget icon,
    FastButtonEmphasis? emphasis,
    bool isEnabled = true,
    Color? disabledColor,
    FastButtonSize? size,
    Color? iconColor,
    double? iconSize,
  }) {
    return IconTheme(
      data: IconThemeData(
        color: getTextColor(
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
          size: size,
          icon: icon,
        ),
      ),
      child: icon,
    );
  }
}
