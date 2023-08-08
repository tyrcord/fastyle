// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:

const _tabletIconSize = 192.0;

class FastPageHeaderRoundedDuotoneIconLayout extends StatelessWidget {
  /// The size of the icon to display on a handset.
  final double handsetIconSize;

  /// The size of the icon to display on a tablet.
  final double tabletIconSize;

  /// The palette to use for the icon.
  final FastPaletteScheme? palette;

  /// The icon to display at the top of the layout.
  final Widget icon;

  const FastPageHeaderRoundedDuotoneIconLayout({
    super.key,
    required this.icon,
    double? handsetIconSize,
    double? tabletIconSize,
    this.palette,
  })  : handsetIconSize = handsetIconSize ?? 160,
        tabletIconSize = tabletIconSize ?? _tabletIconSize;

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
      icon: icon,
    );
  }

  double _getIconSize(BuildContext context, FastMediaType mediaType) {
    final scaleFactor = MediaQuery.textScaleFactorOf(context);
    final textScaleFactor = scaleFactor > 1 ? scaleFactor : scaleFactor;

    if (mediaType == FastMediaType.tablet) {
      return tabletIconSize * textScaleFactor;
    }

    return handsetIconSize * textScaleFactor;
  }

  FastPaletteScheme _getPalette(BuildContext context) {
    if (palette == null) {
      return ThemeHelper.getPaletteColors(context).blueGray;
    }

    return palette!;
  }
}
