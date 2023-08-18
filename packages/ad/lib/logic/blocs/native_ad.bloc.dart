// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastNativeAdBloc
    extends BidirectionalBloc<FastNativeAdBlocEvent, FastNativeAdBlocState> {
  final _admobService = FastAdmobNativeAdService();
  FastAdService? _adService;

  FastNativeAdBloc({
    FastNativeAdBlocState? initialState,
  }) : super(initialState: initialState ?? FastNativeAdBlocState());

  @override
  void close() {
    super.close();
    currentState.adView?.dispose();
    _adService?.dispose();
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

      final adInfo = payload.adInfo;

      if (adInfo.adServiceUriAuthority != null) {
        _adService = FastAdService(adInfo.adServiceUriAuthority!);
      }

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

  Stream<FastNativeAdBlocState> handleLoadAd(
    FastNativeAdBlocEventPayload payload,
  ) async* {
    final adInfo = payload.adInfo;
    final country = payload.country;
    final language = payload.language;
    final adId = payload.adId;

    AdWithView? adView;
    FastResponseAd? ad;

    yield currentState.copyWith(isLoadingAd: true, showFallback: false);

    if (adId != null && _adService != null) {
      ad = await _adService!.getAdById(adId);
    }

    if (ad == null && adInfo.nativeAdUnitId != null) {
      adView = await _admobService.requestAd(
        adInfo.nativeAdUnitId!,
        countryWhiteList: adInfo.countries,
        keywords: adInfo.keywords,
        country: country,
      );
    }

    if (adView == null && ad == null && _adService != null) {
      if (language != null && country != null) {
        ad = await _adService!.getAdByCountryAndLanguage(country, language);
      }

      if (language != null && ad == null) {
        ad = await _adService!.getAdByLanguage(language);
      }
    }

    addEvent(FastNativeAdBlocEvent.adLoaded(payload.copyWith(
      adView: adView,
      ad: ad,
    )));
  }

  Stream<FastNativeAdBlocState> handleAdLoaded(
    FastNativeAdBlocEventPayload payload,
  ) async* {
    if (currentState.isLoadingAd) {
      final adView = payload.adView;
      final ad = payload.ad;

      yield currentState.copyWith(
        showFallback: adView == null && ad == null,
        isLoadingAd: false,
        adView: adView,
        ad: ad,
      );
    }
  }

  @override
  void handleInternalError(dynamic error, StackTrace stackTrace) {
    debugPrint(error.toString());
  }
}
