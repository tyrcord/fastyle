// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// A page widget that displays a valid status with an optional title,
/// description, and buttons.
class FastValidStatusPage extends FastStatusPage {
  /// Creates a [FastValidStatusPage].
  ///
  /// The [titleText] parameter is required.
  const FastValidStatusPage({
    super.key,
    super.titleText,
    super.contentPadding = kFastEdgeInsets16,
    super.descriptionText,
    super.backgroundColor,
    super.iconColor,
    super.palette,
    super.icon,
    VoidCallback? onConfirmTap,
    String? confirmButtonText,
  }) : super(validButtonText: confirmButtonText, onValidTap: onConfirmTap);

  @override
  Widget build(BuildContext context) {
    return FastStatusPage(
      validButtonText:
          validButtonText ?? CoreLocaleKeys.core_label_confirm.tr(),
      icon: icon ?? const FaIcon(FontAwesomeIcons.circleCheck),
      titleText: CoreLocaleKeys.core_label_success.tr(),
      palette: _getPaletteColor(context),
      backgroundColor: backgroundColor,
      contentPadding: contentPadding,
      onValidTap: onValidTap,
      iconColor: iconColor,
      descriptionText:
          descriptionText ?? CoreLocaleKeys.core_message_success.tr(),
    );
  }

  FastPaletteScheme _getPaletteColor(BuildContext context) {
    if (palette != null) {
      return palette!;
    }

    final palettes = ThemeHelper.getPaletteColors(context);

    return palette ?? palettes.green;
  }
}
