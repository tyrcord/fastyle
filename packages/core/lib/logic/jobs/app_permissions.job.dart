// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppPermissionsJob extends FastJob {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static const _debugLabel = 'FastAppPermissionsJob';
  static final _manager = TLoggerManager();
  static FastAppPermissionsJob? _singleton;

  factory FastAppPermissionsJob() {
    return (_singleton ??= const FastAppPermissionsJob._());
  }

  const FastAppPermissionsJob._() : super(debugLabel: _debugLabel);

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    final bloc = FastAppPermissionsBloc.instance;

    _logger.debug('Initializing...');
    bloc.addEvent(const FastAppPermissionsBlocEvent.init());

    final blocState = await RaceStream([
      bloc.onData.where((state) => state.isInitialized),
      bloc.onError,
    ]).first;

    if (blocState is! FastAppPermissionsBlocState) {
      _logger.error('Failed to initialize: $blocState');
      throw blocState;
    }

    _logger.debug('Initialized');
  }
}
