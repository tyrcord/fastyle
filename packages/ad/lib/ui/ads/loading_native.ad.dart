// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastLoadingNativeAd extends StatelessWidget {
  static const placeholder = FastBoxPlaceholder();

  static const placeholders = [
    FastBoxPlaceholder(height: 14, width: 96),
    kFastVerticalSizedBox16,
    FastBoxPlaceholder(height: 14),
    kFastVerticalSizedBox8,
    FastBoxPlaceholder(height: 14),
    kFastVerticalSizedBox8,
    FastBoxPlaceholder(height: 14, width: 72),
  ];

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
    return const FastSmallNativeAdLayout(
      icon: placeholder,
      detailsPlaceholder: placeholder,
    );
  }

  Widget buildMediumAdContent(BuildContext context) {
    return const FastMediumNativeAdLayout(
      icon: placeholder,
      detailsPlaceholder: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: placeholders,
      ),
    );
  }

  Widget buildLargeAdContent(BuildContext context) {
    return const FastLargeNativeAdLayout(
      icon: placeholder,
      detailsPlaceholder: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: placeholders,
      ),
    );
  }
}
