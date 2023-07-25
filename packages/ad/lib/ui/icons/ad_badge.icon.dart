import 'package:flutter/material.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:lingua_ad/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

// Define the _borderRadius and _badgeIconSize constants here.
const double _borderRadius = 2.0;
const double _badgeIconSize = 16.0;

class FastAdBadge extends StatelessWidget {
  final double iconsize;
  final String? labelText;

  const FastAdBadge({
    super.key,
    this.labelText,
    double? iconsize,
  }) : iconsize = iconsize ?? _badgeIconSize;

  @override
  Widget build(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);

    return FittedBox(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_borderRadius),
          color: palette.orange.light,
        ),
        height: iconsize,
        child: Padding(
          padding: kFastHorizontalEdgeInsets6,
          child: Center(
            child: FastCaption(
              textColor: palette.whiteColor,
              fontSize: 11,
              text: labelText ?? AdLocaleKeys.ad_label_ad.tr(),
            ),
          ),
        ),
      ),
    );
  }
}
