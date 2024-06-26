// Package imports:
import 'dart:async';

import 'package:tbloc/tbloc.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastInterstitialAdBloc extends BidirectionalBloc<
    FastInterstitialAdBlocEvent, FastInterstitialAdBlocState> {
  static bool get hasBeenInstantiated => _hasBeenInstantiated;
  static bool _hasBeenInstantiated = false;

  static final _logger = TLoggerManager.instance.getLogger(debugLabel);
  static const debugLabel = 'FastInterstitialAdBloc';

  static late FastInterstitialAdBloc _instance;

  static final _dataProvider = FastSplashAdDataProvider();

  static FastInterstitialAdBloc get instance {
    if (!_hasBeenInstantiated) return FastInterstitialAdBloc();

    return _instance;
  }

  // Method to reset the singleton instance
  static void reset() => instance.resetBloc();

  StreamSubscription<DateTime>? _serviceSubscription;
  FastAdmobInterstitialAdService? _service;
  int _appLaunchCounter = 0;

  bool get canShowAd {
    if (isInitialized) {
      final adInfo = currentState.adInfo;
      final threshold = adInfo.interstitialAdThreshold;

      return _appLaunchCounter >= threshold;
    }

    return false;
  }

  factory FastInterstitialAdBloc({FastInterstitialAdBlocState? initialState}) {
    if (!_hasBeenInstantiated) {
      _instance = FastInterstitialAdBloc._(initialState: initialState);
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  FastInterstitialAdBloc._({FastInterstitialAdBlocState? initialState})
      : super(initialState: initialState ?? FastInterstitialAdBlocState());

  @override
  bool canClose() => false;

  @override
  Stream<FastInterstitialAdBlocState> mapEventToState(
    FastInterstitialAdBlocEvent event,
  ) async* {
    final payload = event.payload;
    final type = event.type;

    _logger.debug('Event received: $type');

    switch (type) {
      case FastInterstitialAdBlocEventType.init:
        yield* _handleInitEvent(payload);
      case FastInterstitialAdBlocEventType.initialized:
        yield* _handleInitializedEvent(payload);
      case FastInterstitialAdBlocEventType.loadAd:
        if (isInitialized) yield* _handleLoadInterstitialAdEvent();
      case FastInterstitialAdBlocEventType.showAd:
        if (isInitialized) yield* _handleShowInterstitialAdEvent();
      default:
        // Handle other events or ignore
        break;
    }
  }

  Stream<FastInterstitialAdBlocState> _handleInitEvent(
    FastInterstitialAdBlocEventPayload? payload,
  ) async* {
    if (canInitialize) {
      isInitializing = true;
      yield currentState.copyWith(isInitializing: true);

      if (_serviceSubscription != null) _serviceSubscription!.cancel();

      final adInfo = payload?.adInfo ?? currentState.adInfo;
      final document = await _retrieveDocument();

      _service = FastAdmobInterstitialAdService(adInfo: adInfo);
      _appLaunchCounter = payload?.appLaunchCounter ?? 0;

      payload = payload?.copyWith(
        lastImpressionDate: document.lastImpressionDate,
      );

      _logger.debug('lastImpressionDate: ${payload?.lastImpressionDate}');

      subxList.add(
        _service!.onAdImpression.listen((date) {
          addEvent(FastSplashAdBlocEvent.adImpression(date));
        }),
      );

      addEvent(FastInterstitialAdBlocEvent.initialized(payload: payload));
    }
  }

  Stream<FastInterstitialAdBlocState> _handleInitializedEvent(
      FastInterstitialAdBlocEventPayload? payload) async* {
    if (isInitializing) {
      isInitialized = true;

      yield currentState.copyWith(
        countryCode: payload?.countryCode,
        adInfo: payload?.adInfo,
        isInitializing: false,
        isInitialized: true,
      );
    }
  }

  Stream<FastInterstitialAdBlocState> _handleLoadInterstitialAdEvent() async* {
    yield currentState.copyWith(
      isAdLoaded: false,
      isAdLoading: true,
    );

    var isAdDisplayable = false;

    if (canShowAd) isAdDisplayable = await _service!.loadAd();

    yield currentState.copyWith(
      isAdDisplayable: isAdDisplayable,
      isAdLoading: false,
      isAdLoaded: true,
    );
  }

  Stream<FastInterstitialAdBlocState> _handleShowInterstitialAdEvent() async* {
    if (canShowAd) _service!.showAdIfAvailable();

    yield currentState.copyWith(isAdLoaded: false, isAdDisplayable: false);
  }

  Future<FastSplashAdDocument> _retrieveDocument() async {
    // Intertitital Ads are shown as fallback when splash ad is not available
    // TODO: rename this store
    await _dataProvider.connect();

    return _dataProvider.retrieveSplashAdDocument();
  }
}
