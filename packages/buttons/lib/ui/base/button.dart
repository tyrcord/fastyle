// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';

abstract class FastButton2 extends StatefulWidget {
  /// Whether the button is enabled.
  final bool isEnabled;

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

  /// The width of the outline border.
  final double borderWidth;

  const FastButton2({
    super.key,
    this.trottleTimeDuration = kFastButtonTrottleTimeDuration,
    this.emphasis = FastButtonEmphasis.low,
    this.shouldTrottleTime = false,
    this.borderWidth = 1.0,
    this.flexible = false,
    this.isEnabled = true,
    this.highlightColor,
    this.semanticLabel,
    this.disabledColor,
    this.constraints,
    this.hoverColor,
    this.focusColor,
    this.debugLabel,
    this.tooltip,
    this.padding,
    this.onTap,
    this.size,
  });
}
