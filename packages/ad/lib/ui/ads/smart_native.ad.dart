// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastSmartNativeAd extends StatelessWidget {
  final WidgetBuilder? fallbackBuilder;
  final FastAdSlotDelegate? delegate;
  final Duration refreshTimeout;
  final Widget? placeholder;
  final String? debugLabel;
  final FastAdInfo? adInfo;
  final FastAdSize adSize;
  final String? country;

  const FastSmartNativeAd({
    super.key,
    this.adSize = FastAdSize.medium,
    this.fallbackBuilder,
    this.placeholder,
    this.debugLabel,
    this.delegate,
    this.country,
    this.adInfo,
    Duration? refreshTimeout,
  })  : refreshTimeout = refreshTimeout ?? kFastRefreshTimeout,
        assert(
          adSize == FastAdSize.medium,
          'Only support native ad with a height of 120px',
        );

  Widget handleAdmobNativeAdFailed(BuildContext context) {
    if (fallbackBuilder != null) {
      return fallbackBuilder!(context);
    }

    return const FastDefaultNativeAd();
  }

  @override
  Widget build(BuildContext context) {
    final canShowAd = delegate?.willShowAd() ?? true;

    if (canShowAd) {
      return FastAdmobNativeAd(
        loadingWidget: getLoadingWidget(adSize),
        fallbackBuilder: fallbackBuilder,
        refreshTimeout: refreshTimeout,
        debugLabel: debugLabel,
        country: country,
        adSize: adSize,
        adInfo: adInfo,
      );
    }

    return placeholder ?? const SizedBox.shrink();
  }
}
