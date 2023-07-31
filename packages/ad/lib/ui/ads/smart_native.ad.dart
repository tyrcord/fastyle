import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:flutter/material.dart';
import 'package:fastyle_core/fastyle_core.dart';

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

  @override
  Widget build(BuildContext context) {
    final canShowAd = delegate?.willShowAd() ?? true;

    if (canShowAd) {
      return FastAdmobNativeAd(
        fallbackBuilder: fallbackBuilder,
        refreshTimeout: refreshTimeout,
        loadingWidget: getLoadingWidget(adSize),
        debugLabel: debugLabel,
        country: country,
        adSize: adSize,
        adInfo: adInfo,
      );
    }

    return placeholder ?? const SizedBox.shrink();
  }

  handleAdmobNativeAdFailed(BuildContext context) {
    if (fallbackBuilder != null) {
      return fallbackBuilder!(context);
    }

    return const FastDefaultNativeAd();
  }
}
