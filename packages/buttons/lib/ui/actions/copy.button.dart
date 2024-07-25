// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
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

  const FastCopyButton({
    super.key,
    String? valueText,
    this.iconAlignment = Alignment.center,
    this.showNotification = true,
    this.isEnabled = true,
    this.message,
    this.icon,
  }) : valueText = valueText ?? kFastEmptyString;

  @override
  Widget build(BuildContext context) {
    return FastIconButton(
      iconColor: ThemeHelper.texts.getSecondaryBodyTextStyle(context).color,
      onTap: () => handleTap(context),
      iconAlignment: iconAlignment,
      icon: buildIcon(context),
      padding: EdgeInsets.zero,
      shouldTrottleTime: true,
      isEnabled: isEnabled,
    );
  }

  /// Handles the tap event when the button is pressed.
  Future<void> handleTap(BuildContext context) async {
    if (isEnabled && valueText.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: valueText));

      if (showNotification && context.mounted) {
        FastNotificationCenter.info(context, message ?? _getDefaultValueText());
      }
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
