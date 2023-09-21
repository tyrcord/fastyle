// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

//TODO: @need-review: code from fastyle_dart

/// The default badge padding.
const _kBadgePadding = EdgeInsets.symmetric(horizontal: 12, vertical: 4);

/// A badge widget that can be used to display a small amount of information.
class FastBadge extends StatelessWidget {
  /// The padding.
  final EdgeInsetsGeometry? padding;

  /// The background color.
  final Color? backgroundColor;

  /// The text color.
  final Color? textColor;

  /// The text to display.
  final String? text;

  /// The border radius.
  final BorderRadius? borderRadius;

  const FastBadge({
    super.key,
    this.padding = _kBadgePadding,
    this.text,
    this.backgroundColor,
    this.borderRadius,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _getPadding(),
      decoration: buildBoxDecoration(context),
      child: buildText(context),
    );
  }

  /// Returns the box decoration.
  BoxDecoration buildBoxDecoration(BuildContext context) {
    return BoxDecoration(
      color: _getBackgroundColor(context),
      borderRadius: _getBorderRadius(),
      shape: BoxShape.rectangle,
    );
  }

  /// Returns the text.
  Widget buildText(BuildContext context) {
    return FastOverline(
      textColor: _getTextColor(context),
      text: text ?? CoreLocaleKeys.core_label_badge.tr(),
    );
  }

  /// Returns the background color.
  Color _getBackgroundColor(BuildContext context) {
    if (backgroundColor != null) {
      return backgroundColor!;
    }

    final colors = ThemeHelper.colors;

    return colors.getPrimaryColor(context).withAlpha(155);
  }

  /// Returns the padding.
  EdgeInsetsGeometry _getPadding() {
    return padding != null ? padding! : _kBadgePadding;
  }

  /// Returns the text color.
  Color _getTextColor(BuildContext context) {
    if (textColor != null) {
      return textColor!;
    }

    final colors = ThemeHelper.colors;

    return colors.getPrimaryColor(context);
  }

  /// Returns the border radius.
  BorderRadius _getBorderRadius() {
    return borderRadius != null ? borderRadius! : BorderRadius.circular(12);
  }
}
