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
class FastCopyButton extends FastActionButton {
  /// Whether to show a notification after copying.
  final bool showNotification;

  /// The text to be copied.
  final String valueText;

  /// Custom notification message (optional).
  final String? message;

  const FastCopyButton({
    super.key,
    String? valueText,
    super.trottleTimeDuration = kFastTrottleTimeDuration,
    super.emphasis = FastButtonEmphasis.low,
    super.iconAlignment = Alignment.center,
    super.shouldTrottleTime = true,
    this.showNotification = true,
    super.isEnabled = true,
    super.highlightColor,
    super.disabledColor,
    super.semanticLabel,
    super.constraints,
    super.focusColor,
    super.hoverColor,
    super.debugLabel,
    super.iconColor,
    super.iconSize,
    super.tooltip,
    super.padding,
    this.message,
    super.onTap,
    super.icon,
  }) : valueText = valueText ?? kFastEmptyString;

  /// Handles the tap event when the button is pressed.
  @override
  Future<void> handleTap(BuildContext context) async {
    if (isEnabled && valueText.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: valueText));

      if (showNotification && context.mounted) {
        FastNotificationCenter.info(context, message ?? _getDefaultValueText());
      }

      onTap?.call();
    }
  }

  @override
  Widget buildIcon(BuildContext context) {
    if (icon != null) return icon!;

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightClipboard);
    }

    return const FaIcon(FontAwesomeIcons.clipboard);
  }

  /// Returns the default value text for the notification message.
  String _getDefaultValueText() {
    return CoreLocaleKeys.core_message_copied_value_to_clipboard.tr(
      namedArgs: {'value': valueText},
    );
  }
}
