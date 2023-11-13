// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastNoFavoriteIcon extends StatelessWidget {
  final FastPaletteScheme? palette;
  final Color? backgroundColor;
  final FastBoxShape? shape;
  final Color? shadowColor;
  final double blurRadius;
  final Color? iconColor;
  final double? iconSize;
  final bool hasShadow;
  final double size;

  const FastNoFavoriteIcon({
    super.key,
    this.backgroundColor,
    this.shadowColor,
    this.iconColor,
    this.iconSize,
    this.shape,
    this.palette,
    this.blurRadius = kFastBlurRadius,
    this.size = kFastIconSizeMedium,
    this.hasShadow = false,
  }) : assert(size >= 0);

  @override
  Widget build(BuildContext context) {
    return FastRoundedDuotoneIcon(
      backgroundColor: backgroundColor,
      palette: _getPalette(context),
      shadowColor: shadowColor,
      icon: _getIcon(context),
      blurRadius: blurRadius,
      hasShadow: hasShadow,
      iconColor: iconColor,
      iconSize: iconSize,
      shape: shape,
      size: size,
    );
  }

  Widget _getIcon(BuildContext context) {
    final useProIcons = FastIconHelper.of(context).useProIcons;
    late IconData iconData;

    if (useProIcons) {
      iconData = FastFontAwesomeIcons.lightHeartCrack;
    } else {
      iconData = FontAwesomeIcons.heartCrack;
    }

    return FaIcon(iconData);
  }

  FastPaletteScheme _getPalette(BuildContext context) {
    return palette ?? ThemeHelper.getPaletteColors(context).red;
  }
}
