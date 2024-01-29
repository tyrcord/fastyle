// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastSplashAdBlocEventPayload {
  final DateTime? lastImpressionDate;
  final int appLaunchCounter;
  final String? countryCode;
  final FastAdInfo? adInfo;

  const FastSplashAdBlocEventPayload({
    this.lastImpressionDate,
    this.countryCode,
    this.adInfo,
    int? appLaunchCounter,
  }) : appLaunchCounter = appLaunchCounter ?? 0;

  FastSplashAdBlocEventPayload copyWith({
    DateTime? lastImpressionDate,
    int? appLaunchCounter,
    String? countryCode,
    FastAdInfo? adInfo,
  }) {
    return FastSplashAdBlocEventPayload(
      lastImpressionDate: lastImpressionDate ?? this.lastImpressionDate,
      appLaunchCounter: appLaunchCounter ?? this.appLaunchCounter,
      countryCode: countryCode ?? this.countryCode,
      adInfo: adInfo ?? this.adInfo,
    );
  }
}
