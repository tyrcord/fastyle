import 'package:fastyle_ad/logic/logic.dart';
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FastNativeAdBlocEventPayload {
  final FastAdInfo adInfo;
  final String? country;
  final AdWithView? adView;

  FastNativeAdBlocEventPayload({
    required this.adInfo,
    this.country,
    this.adView,
  });

  FastNativeAdBlocEventPayload copyWith({
    FastAdInfo? adInfo,
    String? country,
    AdWithView? adView,
  }) {
    return FastNativeAdBlocEventPayload(
      adInfo: adInfo ?? this.adInfo,
      country: country ?? this.country,
      adView: adView ?? this.adView,
    );
  }
}
