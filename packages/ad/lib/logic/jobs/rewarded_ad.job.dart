// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastRewardedAdJob extends FastJob {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static const _debugLabel = 'FastRewardedAdJob';
  static final _manager = TLoggerManager();
  static FastRewardedAdJob? _singleton;

  factory FastRewardedAdJob() {
    return (_singleton ??= const FastRewardedAdJob._());
  }

  const FastRewardedAdJob._()
      : super(blockStartupOnFailure: false, debugLabel: _debugLabel);

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    if (isWeb || isMacOS) return;

    _logger.debug('Initializing...');

    final adInfoBloc = FastAdInfoBloc.instance;
    final rewardedAdBloc = FastRewardedAdBloc.instance;
    final appInfoBloc = FastAppInfoBloc.instance;
    final appInfo = appInfoBloc.currentState;
    final adInfo = adInfoBloc.currentState.adInfo;

    rewardedAdBloc.addEvent(FastRewardedAdBlocEvent.init(
      FastRewardedAdBlocEventPayload(
        country: appInfo.deviceCountryCode,
        adInfo: adInfo,
      ),
    ));

    await rewardedAdBloc.onData.firstWhere((state) => state.isInitialized);

    final response = await RaceStream([
      rewardedAdBloc.onError,
      rewardedAdBloc.onData.where((FastRewardedAdBlocState state) {
        return state.isInitialized;
      }),
    ]).first;

    if (response is! FastRewardedAdBlocState) {
      _logger.error('Failed to initialize: $response');
      throw response;
    }

    _logger.debug('Initialized');
  }
}
