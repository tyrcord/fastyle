// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
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
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.bullhorn,
          color: palette.mid,
          size: 80,
        ),
      ),
    );
  }
}
