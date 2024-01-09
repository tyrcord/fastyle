// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastAdBlocEventPayload {
  final FastAdInfo? adInfo;
  final ConsentStatus? consentStatus;

  FastAdBlocEventPayload({
    this.adInfo,
    this.consentStatus,
  });

  FastAdBlocEventPayload copyWith({
    FastAdInfo? adInfo,
    ConsentStatus? consentStatus,
  }) {
    return FastAdBlocEventPayload(
      adInfo: adInfo ?? this.adInfo,
      consentStatus: consentStatus ?? this.consentStatus,
    );
  }
}
