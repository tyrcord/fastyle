// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

abstract class FastActionButton extends StatelessWidget {
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

  const FastActionButton({
    super.key,
    this.trottleTimeDuration = kFastTrottleTimeDuration,
    this.emphasis = FastButtonEmphasis.low,
    this.iconAlignment = Alignment.center,
    this.shouldTrottleTime = true,
    this.isEnabled = true,
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
  Widget build(BuildContext context) {
    return FastIconButton2(
      trottleTimeDuration: trottleTimeDuration,
      shouldTrottleTime: shouldTrottleTime,
      onTap: () => handleTap(context),
      highlightColor: highlightColor,
      disabledColor: disabledColor,
      iconAlignment: iconAlignment,
      icon: buildIcon(context),
      constraints: constraints,
      debugLabel: debugLabel,
      focusColor: focusColor,
      hoverColor: hoverColor,
      iconColor: iconColor,
      isEnabled: isEnabled,
      emphasis: emphasis,
      iconSize: iconSize,
      padding: padding,
    );
  }

  Future<void> handleTap(BuildContext context);

  Widget buildIcon(BuildContext context);
}
