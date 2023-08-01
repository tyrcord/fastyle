// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// A widget that displays a heart-shaped icon with an optional text
/// as description.
class FastNoFavoriteIcon extends StatelessWidget {
  /// The size of the icon.
  final double size;

  /// The color of the icon and text.
  final Color? color;

  /// The text of the text.
  final String text;

  /// Whether to hide the text.
  final bool hideText;

  final Widget? icon;

  const FastNoFavoriteIcon({
    super.key,
    this.color,
    this.icon,
    double? size,
    String? text,
    bool? hideText,
  })  : text = text ?? CoreLocaleKeys.core_message_no_favorites,
        size = size ?? kFastIconSizeXxl,
        hideText = hideText ?? false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildIcon(context),
        if (!hideText)
          Column(
            children: [
              const SizedBox(height: 8),
              FastSecondaryBody(
                text: text.tr(),
                textColor: color,
              ),
            ],
          )
      ],
    );
  }

  Widget buildIcon(BuildContext context) {
    if (icon != null) {
      if (icon is FaIcon) {
        return FaIcon(
          (icon as FaIcon).icon,
          color: _getIconColor(context),
          size: size,
        );
      }

      if (icon is Icon) {
        return Icon(
          (icon as Icon).icon,
          color: _getIconColor(context),
          size: size,
        );
      }

      return icon!;
    }

    return FaIcon(
      FontAwesomeIcons.heartCrack,
      color: _getIconColor(context),
      size: size,
    );
  }

  /// Gets the color of the icon and text.
  Color _getIconColor(BuildContext context) {
    return color ?? ThemeHelper.texts.getTertiaryLabelColor(context);
  }
}
