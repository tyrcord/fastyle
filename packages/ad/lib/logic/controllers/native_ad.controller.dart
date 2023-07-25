import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:fastyle_ad/fastyle_ad.dart';

class FastNativeAdController extends FastAdController {
  @override
  NativeAdListener listen() {
    return NativeAdListener(
      onAdFailedToLoad: onAdFailedToLoad,
      onAdLoaded: onAdLoaded,
    );
  }
}
