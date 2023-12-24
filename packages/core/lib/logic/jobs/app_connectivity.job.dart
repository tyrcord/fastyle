// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppConnectivityJob extends FastJob {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static const _debugLabel = 'FastAppConnectivityJob';
  static FastAppConnectivityJob? _singleton;
  static final _manager = TLoggerManager();


  factory FastAppConnectivityJob() {
    return (_singleton ??= const FastAppConnectivityJob._());
  }

  const FastAppConnectivityJob._() : super(debugLabel: _debugLabel);

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    if (isWeb) return;

    final bloc = FastConnectivityStatusBloc.instance;
    late Object result;

    if (bloc.currentState.isInitialized) {
      _logger
        ..debug('Already initialized')
        ..debug('Checking connectivity status...');

      bloc.addEvent(FastConnectivityStatusBlocEvent.checkConnectivity());

      result = await RaceStream([
        bloc.onError,
        bloc.onEvent.where((event) {
          return event.type ==
              FastConnectivityStatusBlocEventType.connectivityStatusChanged;
        }).mapTo(bloc.currentState),
      ]).first;
    } else {
      _logger.debug('Initializing...');
      bloc.addEvent(FastConnectivityStatusBlocEvent.init());

      result = await RaceStream([
        bloc.onError,
        bloc.onData.where((state) => state.isInitialized),
      ]).first;
    }

    if (result is! FastConnectivityStatusBlocState) {
      _logger.error('Failed to initialize: $result');
      throw result;
    }

    if (!result.isConnected || !result.isServiceAvailable) {
      _logger.error('No internet connection or service unavailable');
      throw result;
    }

    _logger.debug('Initialized');
  }
}
