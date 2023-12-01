// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastSplashAdJob extends FastJob {
  static FastSplashAdJob? _singleton;

  factory FastSplashAdJob() {
    return (_singleton ??= const FastSplashAdJob._());
  }

  const FastSplashAdJob._() : super(debugLabel: 'FastSplashAdJob');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    if (isAdFreeEnabled()) return;
    if (isWeb || isMacOS) return;

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
      // FIXME: should not be a blocker
      throw response;
    }

    // note: we need to initialize the bloc before verifying
    // if we can show the ad
    if (!splashAdBloc.canShowAd) return;

    splashAdBloc.addEvent(const FastSplashAdBlocEvent.loadAd());

    response = await RaceStream([
      splashAdBloc.onError,
      splashAdBloc.onData.where((state) => state.isAdLoaded),
    ]).first;

    if (response is! FastSplashAdBlocState) {
      // FIXME: should not be a blocker
      // throw response;
    }
  }
}
