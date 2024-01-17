// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastAdInfoBlocEvent
    extends BlocEvent<FastAdInfoBlocEventType, FastAdBlocEventPayload> {
  FastAdInfoBlocEvent.init({FastAdInfo? adInfo})
      : super(
          type: FastAdInfoBlocEventType.init,
          payload: FastAdBlocEventPayload(adInfo: adInfo),
        );

  FastAdInfoBlocEvent.initialized({FastAdInfo? adInfo})
      : super(
          type: FastAdInfoBlocEventType.initialized,
          payload: FastAdBlocEventPayload(adInfo: adInfo),
        );

  const FastAdInfoBlocEvent.askForConsent()
      : super(type: FastAdInfoBlocEventType.askForConsent);

  const FastAdInfoBlocEvent.askForConsentIfNeeded()
      : super(type: FastAdInfoBlocEventType.askForConsentIfNeeded);

  FastAdInfoBlocEvent.constentStatusChanged(ConsentStatus consentStatus)
      : super(
          type: FastAdInfoBlocEventType.constentStatusChanged,
          payload: FastAdBlocEventPayload(consentStatus: consentStatus),
        );
}
