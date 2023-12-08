// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:tlogger/logger.dart';

class FastAppConnectivityJob extends FastJob {
  static const _debugLabel = 'FastAppConnectivityJob';
  static FastAppConnectivityJob? _singleton;
  static final _manager = TLoggerManager();

  late final TLogger _logger;

  factory FastAppConnectivityJob() {
    if (_singleton == null) {
      _singleton = FastAppConnectivityJob._();
      _singleton!._logger = _manager.getLogger(_debugLabel);
    }

    return _singleton!;
  }

  FastAppConnectivityJob._() : super(debugLabel: _debugLabel);

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    if (isWeb) return;

    final bloc = FastConnectivityStatusBloc.instance;
    late Object result;

    if (bloc.currentState.isInitialized) {
      _logger.debug('Checking connectivity status...');
      bloc.addEvent(FastConnectivityStatusBlocEvent.checkConnectivity());

      result = await RaceStream([
        bloc.onError,
        bloc.onEvent.where((event) {
          return event.type ==
              FastConnectivityStatusBlocEventType.connectivityStatusChanged;
        }).mapTo(bloc.currentState),
      ]).first;
    } else {
      _logger.debug('Initializing connectivity status bloc...');
      bloc.addEvent(FastConnectivityStatusBlocEvent.init());

      result = await RaceStream([
        bloc.onError,
        bloc.onData.where((state) => state.isInitialized),
      ]).first;
    }

    if (result is! FastConnectivityStatusBlocState) throw result;
    if (!result.isConnected || !result.isServiceAvailable) throw result;
  }
}
