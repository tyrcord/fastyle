// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

mixin FastAdInformationJobDelegate {
  Future<FastAdInfo> onGetAdInformationModel(BuildContext context);
}

class FastAdInfoJob extends FastJob {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static const _debugLabel = 'FastAdInfoJob';
  static final _manager = TLoggerManager();
  static FastAdInfoJob? _singleton;
  final FastAdInformationJobDelegate? delegate;

  factory FastAdInfoJob({FastAdInformationJobDelegate? delegate}) {
    return (_singleton ??= FastAdInfoJob._(delegate: delegate));
  }

  const FastAdInfoJob._({this.delegate})
      : super(blockStartupOnFailure: false, debugLabel: _debugLabel);

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    if (isWeb || isMacOS) return;

    _logger.debug('Initializing...');

    final adInfoBloc = FastAdInfoBloc.instance;
    FastAdInfo adInfo = adInfoBloc.currentState.adInfo;

    if (delegate != null) {
      adInfo = await delegate!.onGetAdInformationModel(context);
    }

    adInfo.debug(debugLabel: 'AdInfo');

    adInfoBloc.addEvent(FastAdInfoBlocEvent.init(adInfo: adInfo));

    await adInfoBloc.onData.firstWhere((state) => state.isInitialized);

    final response = await RaceStream([
      adInfoBloc.onError,
      adInfoBloc.onData.where((FastAdInfoBlocState state) {
        return state.isInitialized;
      }),
    ]).first;

    if (response is! FastAdInfoBlocState) {
      _logger.error('Failed to initialize: $response');
      throw response;
    }

    _logger.debug('Initialized');
  }
}
