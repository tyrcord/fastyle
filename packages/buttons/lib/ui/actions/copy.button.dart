// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

/// A button widget used to copy text to the clipboard.
class FastCopyButton extends StatelessWidget {
  /// Whether to show a notification after copying.
  final bool showNotification;

  /// The text to be copied.
  final String valueText;

  /// Custom notification message (optional).
  final String? message;

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

  const FastCopyButton({
    super.key,
    String? valueText,
    this.trottleTimeDuration = kFastTrottleTimeDuration,
    this.iconAlignment = Alignment.center,
    this.shouldTrottleTime = true,
    this.showNotification = true,
    this.isEnabled = true,
    this.highlightColor,
    this.disabledColor,
    this.constraints,
    this.focusColor,
    this.hoverColor,
    this.iconColor,
    this.iconSize,
    this.message,
    this.onTap,
    this.icon,
  }) : valueText = valueText ?? kFastEmptyString;

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
      focusColor: focusColor,
      hoverColor: hoverColor,
      iconColor: iconColor,
      isEnabled: isEnabled,
      iconSize: iconSize,
    );
  }

  /// Handles the tap event when the button is pressed.
  Future<void> handleTap(BuildContext context) async {
    if (isEnabled && valueText.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: valueText));

      if (showNotification && context.mounted) {
        FastNotificationCenter.info(context, message ?? _getDefaultValueText());
      }

      onTap?.call();
    }
  }

  /// Returns the default value text for the notification message.
  String _getDefaultValueText() {
    return CoreLocaleKeys.core_message_copied_value_to_clipboard.tr(
      namedArgs: {'value': valueText},
    );
  }

  Widget buildIcon(BuildContext context) {
    if (icon != null) return icon!;

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightClipboard);
    }

    return const FaIcon(FontAwesomeIcons.clipboard);
  }
}
