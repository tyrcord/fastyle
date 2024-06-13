// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastSplashAdJob extends FastJob {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static const _debugLabel = 'FastSplashAdJob';
  static final _manager = TLoggerManager();
  static FastSplashAdJob? _singleton;

  factory FastSplashAdJob() {
    return (_singleton ??= const FastSplashAdJob._());
  }

  const FastSplashAdJob._()
      : super(blockStartupOnFailure: false, debugLabel: _debugLabel);

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    if (isAdFreeEnabled()) return;
    if (isWeb || isMacOS) return;

    _logger.debug('Initializing...');

    final splashAdBloc = FastSplashAdBloc.instance;
    final adInfoBloc = FastAdInfoBloc.instance;
    final appInfoBloc = FastAppInfoBloc.instance;
    final appInfo = appInfoBloc.currentState;
    final adInfo = adInfoBloc.currentState.adInfo;

    splashAdBloc.addEvent(FastSplashAdBlocEvent.init(
      payload: FastSplashAdBlocEventPayload(
        appLaunchCounter: appInfo.appLaunchCounter,
        countryCode: appInfo.deviceCountryCode,
        adInfo: adInfo,
      ),
    ));

    var response = await RaceStream([
      splashAdBloc.onError,
      splashAdBloc.onData.where((state) => state.isInitialized),
    ]).first;

    if (response is! FastSplashAdBlocState) {
      _logger.error('Failed to initialize: $response');
      throw response;
    }

    if (FastInterstitialAdBloc.hasBeenInstantiated) {
      final interstitialAdBloc = FastInterstitialAdBloc.instance;
      final interstitialAdBlocState = interstitialAdBloc.currentState;

      if (interstitialAdBlocState.isAdDisplayable) {
        _logger.debug(
          'Interstitial ad is displayable, no need to show an splash ad',
        );

        logInitialized();

        return;
      }
    }

    // note: we need to initialize the bloc before verifying
    // if we can show the ad
    if (!splashAdBloc.canShowAd) {
      _logger.debug('No need to show a splash ad');
      logInitialized();

      return;
    }

    final splashAdBlocState = splashAdBloc.currentState;
    final lastImpressionDate = splashAdBlocState.lastImpressionDate;

    if (lastImpressionDate != null) {
      final now = DateTime.now().toUtc();
      final difference = now.difference(lastImpressionDate);

      if (difference.inSeconds < adInfo.splashAdTimeThreshold) {
        _logger.debug(
          'Splash Ad was displayed less than an hour ago, no need to '
          'show Splash Ad',
        );

        logInitialized();

        return;
      }
    }

    _logger.debug('Loading a Splash Ad...');
    splashAdBloc.addEvent(const FastSplashAdBlocEvent.loadAd());

    response = await RaceStream([
      splashAdBloc.onError,
      splashAdBloc.onData.where((state) => state.isAdLoaded),
    ]).first;

    if (response is! FastSplashAdBlocState) {
      _logger.error('Failed to load a splash ad: $response');
      throw response;
    }

    _logger.debug('Splash ad loaded');
    logInitialized();
  }

  void logInitialized() {
    _logger.debug('Initialized');
  }
}
