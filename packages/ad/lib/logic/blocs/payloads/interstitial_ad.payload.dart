// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastInterstitialAdBlocEventPayload {
  final DateTime? lastImpressionDate;
  final FastAdInfo? adInfo;
  final String? countryCode;
  final int appLaunchCounter;

  const FastInterstitialAdBlocEventPayload({
    this.adInfo,
    this.countryCode,
    int? appLaunchCounter,
    this.lastImpressionDate,
  }) : appLaunchCounter = appLaunchCounter ?? 0;

  FastInterstitialAdBlocEventPayload copyWith({
    FastAdInfo? adInfo,
    String? countryCode,
    int? appLaunchCounter,
    DateTime? lastImpressionDate,
  }) {
    return FastInterstitialAdBlocEventPayload(
      adInfo: adInfo ?? this.adInfo,
      countryCode: countryCode ?? this.countryCode,
      appLaunchCounter: appLaunchCounter ?? this.appLaunchCounter,
      lastImpressionDate: lastImpressionDate ?? this.lastImpressionDate,
    );
  }
}
