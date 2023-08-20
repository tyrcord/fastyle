// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastNoFavoriteStatus extends StatelessWidget {
  final Color? textColor;

  final String? text;

  final Widget? icon;

  final double iconSize;

  const FastNoFavoriteStatus({
    super.key,
    this.text,
    this.textColor,
    this.icon,
    this.iconSize = kFastIconSizeXxl,
  });

  @override
  Widget build(BuildContext context) {
    return FastStatus(
      icon: _buildIcon(context),
      text: _buildText(context),
      textColor: textColor,
    );
  }

  Widget _buildIcon(BuildContext context) {
    if (icon != null) {
      return icon!;
    }

    return FastNoFavoriteIcon(size: iconSize);
  }

  String _buildText(BuildContext context) {
    if (text != null) {
      return text!;
    }

    return CoreLocaleKeys.core_message_no_favorites.tr();
  }
}
