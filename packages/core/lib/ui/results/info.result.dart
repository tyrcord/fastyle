// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastInfoStatus extends StatelessWidget {
  final double iconSize;

  final Color? textColor;

  final String? text;

  final Widget? icon;

  const FastInfoStatus({
    super.key,
    this.iconSize = kFastIconSizeXxl,
    this.textColor,
    this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FastResult(
      icon: _buildIcon(context),
      text: _buildText(context),
      textColor: textColor,
    );
  }

  Widget _buildIcon(BuildContext context) {
    if (icon != null) return icon!;

    return FastInfoIcon(size: iconSize);
  }

  String _buildText(BuildContext context) {
    if (text != null) return text!;

    return CoreLocaleKeys.core_label_info.tr();
  }
}
