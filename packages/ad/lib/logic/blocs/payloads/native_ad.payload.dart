// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_ad/logic/logic.dart';

class FastNativeAdBlocEventPayload {
  final FastAdInfo adInfo;
  final String? country;
  final AdWithView? adView;
  final String? language;
  final FastResponseAd? ad;

  FastNativeAdBlocEventPayload({
    required this.adInfo,
    this.country,
    this.adView,
    this.language,
    this.ad,
  });

  FastNativeAdBlocEventPayload copyWith({
    FastAdInfo? adInfo,
    String? country,
    AdWithView? adView,
    String? language,
    FastResponseAd? ad,
  }) {
    return FastNativeAdBlocEventPayload(
      adInfo: adInfo ?? this.adInfo,
      country: country ?? this.country,
      adView: adView ?? this.adView,
      language: language ?? this.language,
      ad: ad ?? this.ad,
    );
  }
}
