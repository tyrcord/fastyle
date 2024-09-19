// Flutter imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:go_router/go_router.dart';

final _popButtonMinWidth =
    FastPopButton.defaultButtonSize.iconSpec.constraints.minWidth;

final _popButtonPadding =
    (_popButtonMinWidth - FastPopButton.defaultIconSize) / 2;

abstract class FastPopButton extends StatelessWidget {
  static const defaultButtonSize = FastButtonSize.medium;
  static const defaultIconSize = kFastIconSizeLarge;

  static late final double popButtonMinWidth;
  static late final double popButtonPadding;

  static double get defaultButtonPadding => _popButtonPadding;

  /// Whether the button is enabled.
  final bool isEnabled;

  /// Custom icon for the button (optional).
  final Widget? icon;

  /// The icon alignment.
  final Alignment? iconAlignment;

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

  /// Whether the button is flexible.
  final bool flexible;

  /// The size of the button.
  final FastButtonSize? size;

  const FastPopButton({
    super.key,
    this.trottleTimeDuration = kFastButtonTrottleTimeDuration,
    this.emphasis = FastButtonEmphasis.low,
    this.iconSize = defaultIconSize,
    this.shouldTrottleTime = true,
    this.size = defaultButtonSize,
    this.isEnabled = true,
    this.flexible = false,
    this.highlightColor,
    this.iconAlignment,
    this.disabledColor,
    this.semanticLabel,
    this.constraints,
    this.focusColor,
    this.hoverColor,
    this.debugLabel,
    this.iconColor,
    this.tooltip,
    this.padding,
    this.onTap,
    this.icon,
  });

  @protected
  void handleTap(BuildContext context) {
    if (onTap != null) {
      onTap!();
    } else if (context.canPop()) {
      context.pop();
    }
  }

  Widget buildIcon(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return FastIconButton2(
      trottleTimeDuration: trottleTimeDuration,
      shouldTrottleTime: shouldTrottleTime,
      onTap: () => handleTap(context),
      highlightColor: highlightColor,
      disabledColor: disabledColor,
      iconAlignment: iconAlignment,
      semanticLabel: semanticLabel,
      icon: buildIcon(context),
      constraints: constraints,
      debugLabel: debugLabel,
      focusColor: focusColor,
      hoverColor: hoverColor,
      iconColor: iconColor,
      isEnabled: isEnabled,
      emphasis: emphasis,
      flexible: flexible,
      iconSize: iconSize,
      padding: padding,
      tooltip: tooltip,
      size: size,
    );
  }
}
