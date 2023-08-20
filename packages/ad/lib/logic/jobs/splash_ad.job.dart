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
    if (isWeb) return;

    final adInfoBloc = FastAdInfoBloc.instance;
    final splashAdBloc = FastSplashAdBloc.instance;
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

    await splashAdBloc.onData.firstWhere((state) => state.isInitialized);

    final response = await RaceStream([
      splashAdBloc.onError,
      splashAdBloc.onData.where((FastSplashAdBlocState state) {
        return state.isInitialized;
      }),
    ]).first;

    if (response is! FastSplashAdBlocState) {
      throw response;
    }

    splashAdBloc.addEvent(const FastSplashAdBlocEvent.loadAd());
  }
}
