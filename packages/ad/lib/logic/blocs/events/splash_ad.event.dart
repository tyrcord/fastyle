// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastSplashAdBlocEvent
    extends BlocEvent<FastSplashAdBlocEventType, FastSplashAdBlocEventPayload> {
  const FastSplashAdBlocEvent.init({FastSplashAdBlocEventPayload? payload})
      : super(type: FastSplashAdBlocEventType.init, payload: payload);

  const FastSplashAdBlocEvent.initialized({
    FastSplashAdBlocEventPayload? payload,
  }) : super(type: FastSplashAdBlocEventType.initialized, payload: payload);

  const FastSplashAdBlocEvent.loadAd()
      : super(type: FastSplashAdBlocEventType.loadAd);

  const FastSplashAdBlocEvent.showAd()
      : super(type: FastSplashAdBlocEventType.showAd);
}
