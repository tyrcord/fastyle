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
    super.contentPadding = kFastEdgeInsets16,
    super.cancelButtonText,
    super.descriptionText,
    super.backgroundColor,
    super.onCancelTap,
    super.iconColor,
    super.palette,
    super.icon,
    VoidCallback? onRetryTap,
    String? retryButtonText,
  }) : super(validButtonText: retryButtonText, onValidTap: onRetryTap);

  @override
  Widget build(BuildContext context) {
    return FastStatusPage(
      validButtonText: validButtonText ?? CoreLocaleKeys.core_label_retry.tr(),
      icon: icon ?? const FaIcon(FontAwesomeIcons.circleExclamation),
      titleText: CoreLocaleKeys.core_label_error.tr(),
      palette: _getPaletteColor(context),
      backgroundColor: backgroundColor,
      contentPadding: contentPadding,
      onCancelTap: onCancelTap,
      onValidTap: onValidTap,
      iconColor: iconColor,
      cancelButtonText:
          cancelButtonText ?? CoreLocaleKeys.core_label_cancel.tr(),
      descriptionText:
          descriptionText ?? CoreLocaleKeys.core_error_error_occurred.tr(),
    );
  }

  FastPaletteScheme _getPaletteColor(BuildContext context) {
    if (palette != null) {
      return palette!;
    }

    final palettes = ThemeHelper.getPaletteColors(context);

    return palette ?? palettes.red;
  }
}
