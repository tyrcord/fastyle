import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tbloc/tbloc.dart';
import 'package:fastyle_ad/fastyle_ad.dart';

class FastNativeAdBloc
    extends BidirectionalBloc<FastNativeAdBlocEvent, FastNativeAdBlocState> {
  final _service = FastAdmobNativeAdService();

  FastNativeAdBloc({
    FastNativeAdBlocState? initialState,
  }) : super(initialState: initialState ?? FastNativeAdBlocState());

  @override
  void close() {
    super.close();
    currentState.adView?.dispose();
  }

  @override
  Stream<FastNativeAdBlocState> mapEventToState(
    FastNativeAdBlocEvent event,
  ) async* {
    final type = event.type;
    final payload = event.payload;

    if (payload is FastNativeAdBlocEventPayload) {
      if (type == FastNativeAdBlocEventType.init) {
        yield* handleInitEvent(payload);
      } else if (type == FastNativeAdBlocEventType.initalized) {
        yield* handleInitializedEvent(payload);
      } else if (isInitialized) {
        if (type == FastNativeAdBlocEventType.loadAd) {
          yield* handleLoadAd(payload);
        } else if (type == FastNativeAdBlocEventType.adLoaded) {
          yield* handleAdLoaded(payload);
        }
      } else {
        assert(false, 'FastNativeAdBloc is not initialized yet.');
      }
    } else {
      assert(false, 'FastNativeAdBlocEventPayload is null.');
    }
  }

  Stream<FastNativeAdBlocState> handleInitEvent(
    FastNativeAdBlocEventPayload payload,
  ) async* {
    if (canInitialize) {
      isInitializing = true;
      yield currentState.copyWith(isInitializing: true);

      addEvent(FastNativeAdBlocEvent.initialized(payload));
    }
  }

  Stream<FastNativeAdBlocState> handleInitializedEvent(
    FastNativeAdBlocEventPayload payload,
  ) async* {
    if (isInitializing) {
      isInitialized = true;

      yield currentState.copyWith(
        isInitializing: false,
        isInitialized: true,
      );
    }
  }

  // TODO: Add support for other ad providers.
  Stream<FastNativeAdBlocState> handleLoadAd(
    FastNativeAdBlocEventPayload payload,
  ) async* {
    final adInfo = payload.adInfo;
    final country = payload.country;
    AdWithView? adView;

    yield currentState.copyWith(isLoadingAd: true, showFallback: false);

    if (adInfo.nativeAdUnitId != null) {
      adView = await _service.requestAd(
        adInfo.nativeAdUnitId!,
        countryWhiteList: adInfo.countries,
        keywords: adInfo.keywords,
        country: country,
      );
    }

    addEvent(FastNativeAdBlocEvent.adLoaded(payload.copyWith(adView: adView)));
  }

  Stream<FastNativeAdBlocState> handleAdLoaded(
    FastNativeAdBlocEventPayload payload,
  ) async* {
    if (currentState.isLoadingAd) {
      final adView = payload.adView;

      yield currentState.copyWith(
        showFallback: adView == null,
        isLoadingAd: false,
        adView: adView,
      );
    }
  }

  @override
  void handleInternalError(dynamic error) {
    debugPrint(error.toString());
  }
}
