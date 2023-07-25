import 'package:flutter/material.dart';
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_dart/fastyle_dart.dart';

class FastLoadingNativeAd extends StatelessWidget {
  final FastAdSize adSize;

  const FastLoadingNativeAd({
    super.key,
    this.adSize = FastAdSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return FastShimmer(child: buildAdContent(context));
  }

  Widget buildAdContent(BuildContext context) {
    if (adSize == FastAdSize.small) {
      return buildSmallAdContent(context);
    } else if (adSize == FastAdSize.medium) {
      return buildMediumAdContent(context);
    }

    return buildLargeAdContent(context);
  }

  Widget buildSmallAdContent(BuildContext context) {
    final placeholder = buildPlaceholder(context);

    return FastSmallNativeAdLayout(
      icon: placeholder,
      detailsPlaceholder: placeholder,
    );
  }

  Widget buildMediumAdContent(BuildContext context) {
    final placeholder = buildPlaceholder(context);

    return FastMediumNativeAdLayout(
      icon: placeholder,
      detailsPlaceholder: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildPlaceholder(context, height: 14, width: 96),
          buildPlaceholder(context, height: 14),
          buildPlaceholder(context, height: 14, width: 72),
        ],
      ),
    );
  }

  Widget buildLargeAdContent(BuildContext context) {
    final placeholder = buildPlaceholder(context);

    return FastLargeNativeAdLayout(
      icon: placeholder,
      detailsPlaceholder: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildPlaceholder(context, height: 14, width: 96),
          buildPlaceholder(context, height: 14),
          buildPlaceholder(context, height: 14, width: 72),
        ],
      ),
    );
  }

  Widget buildPlaceholder(
    BuildContext context, {
    double? height,
    double? width,
  }) {
    final grayPalette = _getGrayPaletteScheme(context);

    return Container(
      color: grayPalette.lightest,
      height: height,
      width: width,
    );
  }

  FastPaletteScheme _getGrayPaletteScheme(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);

    return palette.gray;
  }
}
