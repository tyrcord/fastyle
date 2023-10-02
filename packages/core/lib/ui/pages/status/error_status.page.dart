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
class FastErrorStatusPage extends FastStatusPage {
  /// Creates a [FastErrorStatusPage].
  ///
  /// The [titleText] parameter is required.
  const FastErrorStatusPage({
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
  }) : super(validButtonText: retryButtonText, onValidTap: onRetryTap);

  @override
  Widget build(BuildContext context) {
    return FastStatusPage(
      validButtonText: validButtonText ?? CoreLocaleKeys.core_label_retry.tr(),
      titleText: titleText ?? CoreLocaleKeys.core_message_whoops.tr(),
      palette: _getPaletteColor(context),
      backgroundColor: backgroundColor,
      icon: _getIcon(context),
      onCancelTap: onCancelTap,
      onValidTap: onValidTap,
      iconColor: iconColor,
      cancelButtonText:
          cancelButtonText ?? CoreLocaleKeys.core_label_cancel.tr(),
      subTitleText: subTitleText ??
          CoreLocaleKeys.core_error_error_occurred_exclamation.tr(),
      descriptionText:
          descriptionText ?? CoreLocaleKeys.core_help_several_reasons.tr(),
      child: FastInstructions(
        instructions: [
          CoreLocaleKeys.core_help_ensure_app_up_to_date.tr(),
          CoreLocaleKeys.core_help_restart_device_check_connection.tr(),
          CoreLocaleKeys.core_help_service_not_available_current_location.tr(),
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
      return const FaIcon(FastFontAwesomeIcons.lightTriangleExclamation);
    }

    return const FaIcon(FontAwesomeIcons.triangleExclamation);
  }
}
