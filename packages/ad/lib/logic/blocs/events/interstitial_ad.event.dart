// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastInterstitialAdBlocEvent extends BlocEvent<
    FastInterstitialAdBlocEventType, FastInterstitialAdBlocEventPayload> {
  const FastInterstitialAdBlocEvent.init({super.payload})
      : super(type: FastInterstitialAdBlocEventType.init);

  const FastInterstitialAdBlocEvent.initialized({
    super.payload,
  }) : super(type: FastInterstitialAdBlocEventType.initialized);

  const FastInterstitialAdBlocEvent.loadAd()
      : super(type: FastInterstitialAdBlocEventType.loadAd);

  const FastInterstitialAdBlocEvent.showAd()
      : super(type: FastInterstitialAdBlocEventType.showAd);
}
