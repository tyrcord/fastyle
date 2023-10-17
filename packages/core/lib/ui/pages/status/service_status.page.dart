// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// A page widget that displays a server unreachability status with an optional
/// title, description, and buttons.
class FastServiceStatusPage extends FastStatusPage {
  final bool isServiceAvailable;

  /// Creates a [FastServiceStatusPage].
  const FastServiceStatusPage({
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
    this.isServiceAvailable = false,
  }) : super(validButtonText: retryButtonText, onValidTap: onRetryTap);

  @override
  Widget build(BuildContext context) {
    return FastStatusPage(
      validButtonText: validButtonText ?? CoreLocaleKeys.core_label_retry.tr(),
      titleText:
          titleText ?? CoreLocaleKeys.core_label_service_unavailable.tr(),
      palette: _getPaletteColor(context),
      cancelButtonText: cancelButtonText,
      backgroundColor: backgroundColor,
      onCancelTap: onCancelTap,
      icon: _getIcon(context),
      onValidTap: onValidTap,
      iconColor: iconColor,
      subTitleText:
          subTitleText ?? CoreLocaleKeys.core_error_service_unavailable.tr(),
      descriptionText:
          descriptionText ?? CoreLocaleKeys.core_help_several_reasons.tr(),
      child: FastInstructions(
        instructions: [
          CoreLocaleKeys.core_help_service_not_operational.tr(),
          CoreLocaleKeys.core_help_service_not_available_current_location.tr(),
          CoreLocaleKeys.core_help_ensure_internet_restrictions.tr(),
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
      return const FaIcon(FastFontAwesomeIcons.lightServer);
    }

    return const FaIcon(FontAwesomeIcons.server);
  }
}
