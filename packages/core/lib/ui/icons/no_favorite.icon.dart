// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastNoFavoriteIcon extends StatelessWidget {
  final Color? backgroundColor;
  final FastBoxShape? shape;
  final Color? iconColor;
  final double? iconSize;
  final double size;
  final Color? shadowColor;
  final double blurRadius;
  final bool hasShadow;

  const FastNoFavoriteIcon({
    super.key,
    this.size = kFastIconSizeMedium,
    this.backgroundColor,
    this.iconColor,
    this.iconSize,
    this.shape,
    this.shadowColor,
    this.blurRadius = kFastBlurRadius,
    this.hasShadow = false,
  }) : assert(size >= 0);

  @override
  Widget build(BuildContext context) {
    final palettes = ThemeHelper.getPaletteColors(context);
    final useProIcons = FastIconHelper.of(context).useProIcons;
    late IconData iconData;

    if (useProIcons) {
      iconData = FastFontAwesomeIcons.lightHeartCrack;
    } else {
      iconData = FontAwesomeIcons.heartCrack;
    }

    return FastRoundedDuotoneIcon(
      icon: FaIcon(iconData),
      palette: palettes.gray,
      size: size,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      iconSize: iconSize,
      shape: shape,
      shadowColor: shadowColor,
      blurRadius: blurRadius,
      hasShadow: hasShadow,
    );
  }
}
