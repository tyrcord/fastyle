import 'package:fastyle_ad/fastyle_ad.dart';

class FastSplashAdBlocEventPayload {
  final FastAdInfo? adInfo;
  final String? countryCode;
  final int appLaunchCounter;

  const FastSplashAdBlocEventPayload({
    this.adInfo,
    this.countryCode,
    int? appLaunchCounter,
  }) : appLaunchCounter = appLaunchCounter ?? 0;

  FastSplashAdBlocEventPayload copyWith({
    FastAdInfo? adInfo,
    String? countryCode,
    int? appLaunchCounter,
  }) {
    return FastSplashAdBlocEventPayload(
      adInfo: adInfo ?? this.adInfo,
      countryCode: countryCode ?? this.countryCode,
      appLaunchCounter: appLaunchCounter ?? this.appLaunchCounter,
    );
  }
}
