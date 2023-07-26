import 'package:flutter/material.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:lingua_ad/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

// Define the _borderRadius and _badgeIconSize constants here.
const double _borderRadius = 2.0;
const double _badgeHeight = 16.0;

class FastAdBadge extends StatelessWidget {
  final double height;
  final String? labelText;
  final Color? color;
  final Color? labelColor;
  final double borderRadius;

  const FastAdBadge({
    super.key,
    this.labelText,
    this.labelColor,
    this.color,
    double? borderRadius,
    double? height,
  })  : height = height ?? _badgeHeight,
        borderRadius = borderRadius ?? _borderRadius;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        decoration: buildBoxDecoration(context),
        height: height,
        child: Padding(
          padding: kFastHorizontalEdgeInsets6,
          child: Center(
            child: FastCaption(
              text: labelText ?? AdLocaleKeys.ad_label_ad.tr(),
              textColor: _getLabelColor(context),
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: _getBackgroundColor(context),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (color != null) {
      return color!;
    }

    final palette = ThemeHelper.getPaletteColors(context);

    return palette.mint.mid.withOpacity(0.75);
  }

  Color _getLabelColor(BuildContext context) {
    if (color != null) {
      return color!;
    }

    final palette = ThemeHelper.getPaletteColors(context);

    return palette.whiteColor;
  }
}
