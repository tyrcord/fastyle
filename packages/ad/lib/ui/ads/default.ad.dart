// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastDefaultNativeAd extends StatelessWidget {
  static const placeholder = FastBoxPlaceholder();
  final FastAdSize adSize;

  const FastDefaultNativeAd({
    super.key,
    this.adSize = FastAdSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return FastNativeAdLayout(
      descriptionText: 'This is the default ad description.',
      icon: buildIcon(context),
      titleText: 'Default Ad',
      adSize: adSize,
    );
  }

  Widget buildIcon(BuildContext context) {
    final palettes = ThemeHelper.getPaletteColors(context);
    final palette = palettes.blueGray;

    return Container(
      color: palette.lightest,
      width: double.infinity,
      height: double.infinity,
      child: Center(child: _getIcon(context, palette)),
    );
  }

  Widget _getIcon(BuildContext context, FastPaletteScheme palette) {
    final useProIcons = FastIconHelper.of(context).useProIcons;
    final color = palette.mid;
    const size = 80.0;

    if (useProIcons) {
      return FaIcon(FastFontAwesomeIcons.megaphone, color: color, size: size);
    }

    return FaIcon(FontAwesomeIcons.bullhorn, color: color, size: size);
  }
}
