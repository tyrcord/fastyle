// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tbloc/tbloc.dart';

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

    final adInfoBloc = BlocProvider.of<FastAdInfoBloc>(context);
    final splashAdBloc = BlocProvider.of<FastSplashAdBloc>(context);
    final appInfoBloc = BlocProvider.of<FastAppInfoBloc>(context);

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
