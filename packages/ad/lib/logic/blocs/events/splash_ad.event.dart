// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastSplashAdBlocEvent
    extends BlocEvent<FastSplashAdBlocEventType, FastSplashAdBlocEventPayload> {
  const FastSplashAdBlocEvent.init({super.payload})
      : super(type: FastSplashAdBlocEventType.init);

  const FastSplashAdBlocEvent.initialized({
    super.payload,
  }) : super(type: FastSplashAdBlocEventType.initialized);

  const FastSplashAdBlocEvent.loadAd()
      : super(type: FastSplashAdBlocEventType.loadAd);

  const FastSplashAdBlocEvent.showAd()
      : super(type: FastSplashAdBlocEventType.showAd);

  FastSplashAdBlocEvent.adImpression(DateTime date)
      : super(
          payload: FastSplashAdBlocEventPayload(lastImpressionDate: date),
          type: FastSplashAdBlocEventType.adImpression,
        );
}
