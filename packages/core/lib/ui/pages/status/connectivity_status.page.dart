// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// A page widget that displays an error status with an optional title,
/// description, and buttons.
class FastConnectivityStatusPage extends FastStatusPage {
  final bool hasConnection;

  /// Creates a [FastConnectivityStatusPage].
  ///
  /// The [titleText] parameter is required.
  const FastConnectivityStatusPage({
    super.key,
    super.titleText,
    super.cancelButtonText,
    super.descriptionText,
    super.backgroundColor,
    super.onCancelTap,
    super.iconColor,
    super.palette,
    super.icon,
    super.subTitleText,
    VoidCallback? onRetryTap,
    String? retryButtonText,
    this.hasConnection = false,
  }) : super(validButtonText: retryButtonText, onValidTap: onRetryTap);

  @override
  Widget build(BuildContext context) {
    return FastStatusPage(
      validButtonText: validButtonText ?? CoreLocaleKeys.core_label_retry.tr(),
      titleText:
          titleText ?? CoreLocaleKeys.core_label_internet_connection.tr(),
      palette: _getPaletteColor(context),
      backgroundColor: backgroundColor,
      onCancelTap: onCancelTap,
      icon: _getIcon(context),
      onValidTap: onValidTap,
      iconColor: iconColor,
      subTitleText: subTitleText ??
          CoreLocaleKeys.core_message_require_internet_connection.tr(),
      descriptionText: descriptionText ??
          CoreLocaleKeys.core_message_try_steps_back_online.tr(),
      child: FastInstructions(
        instructions: [
          CoreLocaleKeys.core_help_check_your_modem_and_router.tr(),
          CoreLocaleKeys.core_help_reconnect_to_your_wifi_network.tr(),
          CoreLocaleKeys.core_help_issue_persist_contact_support.tr(),
        ],
      ),
    );
  }

  FastPaletteScheme _getPaletteColor(BuildContext context) {
    if (palette != null) {
      return palette!;
    }

    final palettes = ThemeHelper.getPaletteColors(context);

    return palette ?? palettes.red;
  }

  Widget _getIcon(BuildContext context) {
    if (icon != null) {
      return icon!;
    }

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightWifi);
    }

    return const FaIcon(FontAwesomeIcons.wifi);
  }
}
