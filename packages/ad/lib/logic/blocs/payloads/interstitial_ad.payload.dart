// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastInterstitialAdBlocEventPayload {
  final FastAdInfo? adInfo;
  final String? countryCode;
  final int appLaunchCounter;

  const FastInterstitialAdBlocEventPayload({
    this.adInfo,
    this.countryCode,
    int? appLaunchCounter,
  }) : appLaunchCounter = appLaunchCounter ?? 0;

  FastInterstitialAdBlocEventPayload copyWith({
    FastAdInfo? adInfo,
    String? countryCode,
    int? appLaunchCounter,
  }) {
    return FastInterstitialAdBlocEventPayload(
      adInfo: adInfo ?? this.adInfo,
      countryCode: countryCode ?? this.countryCode,
      appLaunchCounter: appLaunchCounter ?? this.appLaunchCounter,
    );
  }
}
