// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastNativeAdBlocEvent
    extends BlocEvent<FastNativeAdBlocEventType, FastNativeAdBlocEventPayload> {
  const FastNativeAdBlocEvent.init(FastNativeAdBlocEventPayload payload)
      : super(type: FastNativeAdBlocEventType.init, payload: payload);

  const FastNativeAdBlocEvent.initialized(FastNativeAdBlocEventPayload payload)
      : super(type: FastNativeAdBlocEventType.initalized, payload: payload);

  const FastNativeAdBlocEvent.loadAd(FastNativeAdBlocEventPayload payload)
      : super(type: FastNativeAdBlocEventType.loadAd, payload: payload);

  const FastNativeAdBlocEvent.adLoaded(FastNativeAdBlocEventPayload payload)
      : super(type: FastNativeAdBlocEventType.adLoaded, payload: payload);
}
