// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tenhance/tenhance.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastPageHeaderRoundedDuotoneIconLayout extends StatelessWidget {
  /// The size of the icon to display on a handset.
  final double handsetIconSize;

  /// The size of the icon to display on a tablet.
  final double tabletIconSize;

  /// The palette to use for the icon.
  final FastPaletteScheme? palette;

  /// The icon to display at the top of the layout.
  final Widget icon;

  final bool hasShadow;

  const FastPageHeaderRoundedDuotoneIconLayout({
    super.key,
    required this.icon,
    double? handsetIconSize,
    double? tabletIconSize,
    this.palette,
    this.hasShadow = true,
  }) : handsetIconSize = handsetIconSize ?? kFastPageHeaderIconSizeSmall,
       tabletIconSize = tabletIconSize ?? kFastPageHeaderIconSizeMedium;

  @override
  Widget build(BuildContext context) {
    return FastMediaLayoutBuilder(
      builder: (BuildContext context, FastMediaType mediaType) {
        final isHandset = mediaType < FastMediaType.tablet;

        return FractionallySizedBox(
          widthFactor: isHandset ? 1 : 0.55,
          child: buildIcon(context, mediaType),
        );
      },
    );
  }

  Widget buildIcon(BuildContext context, FastMediaType mediaType) {
    return FastRoundedDuotoneIcon(
      size: _getIconSize(context, mediaType),
      palette: _getPalette(context),
      hasShadow: hasShadow,
      icon: icon,
    );
  }

  double _getIconSize(BuildContext context, FastMediaType mediaType) {
    final textScaler = MediaQuery.textScalerOf(context);

    if (mediaType == FastMediaType.tablet) {
      return textScaler.scale(tabletIconSize);
    }

    return textScaler.scale(handsetIconSize);
  }

  FastPaletteScheme _getPalette(BuildContext context) {
    if (palette == null) {
      return ThemeHelper.getPaletteColors(context).blueGray;
    }

    return palette!;
  }
}
