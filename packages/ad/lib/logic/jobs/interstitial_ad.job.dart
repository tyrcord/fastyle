// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastInterstitialAdJob extends FastJob {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static const _debugLabel = 'FastInterstitialAdJob';
  static final _manager = TLoggerManager();
  static FastInterstitialAdJob? _singleton;

  factory FastInterstitialAdJob() {
    return (_singleton ??= const FastInterstitialAdJob._());
  }

  const FastInterstitialAdJob._() : super(debugLabel: _debugLabel);

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    if (isAdFreeEnabled()) return;
    if (isWeb || isMacOS) return;

    _logger.debug('Initializing...');

    final interstitialAdBloc = FastInterstitialAdBloc.instance;
    final adInfoBloc = FastAdInfoBloc.instance;
    final appInfoBloc = FastAppInfoBloc.instance;
    final appInfo = appInfoBloc.currentState;
    final adInfo = adInfoBloc.currentState.adInfo;

    interstitialAdBloc.addEvent(FastInterstitialAdBlocEvent.init(
      payload: FastInterstitialAdBlocEventPayload(
        appLaunchCounter: appInfo.appLaunchCounter,
        countryCode: appInfo.deviceCountryCode,
        adInfo: adInfo,
      ),
    ));

    var response = await RaceStream([
      interstitialAdBloc.onError,
      interstitialAdBloc.onData.where((state) => state.isInitialized),
    ]).first;

    if (response is! FastInterstitialAdBlocState) {
      _logger.error('Failed to initialize: $response');
      // FIXME: should not be a blocker
      // throw response;
      return;
    }

    if (FastSplashAdBloc.hasBeenInstantiated) {
      final splashAdBloc = FastSplashAdBloc.instance;
      final splashAdBlocState = splashAdBloc.currentState;

      if (splashAdBlocState.isAdDisplayable) {
        _logger.debug(
          'Splash ad is displayable, no need to show an interstitial ad',
        );

        logInitialized();

        return;
      }
    }

    // note: we need to initialize the bloc before verifying
    // if we can show the ad
    if (!interstitialAdBloc.canShowAd) {
      _logger.debug('No need to show an interstitial ad');
      logInitialized();

      return;
    }

    _logger.debug('Loading an interstitial ad...');
    interstitialAdBloc.addEvent(const FastInterstitialAdBlocEvent.loadAd());

    response = await RaceStream([
      interstitialAdBloc.onError,
      interstitialAdBloc.onData.where((state) => state.isAdLoaded),
    ]).first;

    if (response is! FastInterstitialAdBlocState) {
      _logger.error('Failed to load an interstitial ad: $response');
      // FIXME: should not be a blocker
      // throw response;
    }

    _logger.debug('Interstitial ad loaded');
    logInitialized();
  }

  void logInitialized() {
    _logger.debug('Initialized');
  }
}
