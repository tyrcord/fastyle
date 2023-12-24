// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppFeaturesJob extends FastJob {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static const _debugLabel = 'FastAppFeaturesJob';
  static final _manager = TLoggerManager();
  static FastAppFeaturesJob? _singleton;

  factory FastAppFeaturesJob() {
    return (_singleton ??= const FastAppFeaturesJob._());
  }

  const FastAppFeaturesJob._() : super(debugLabel: _debugLabel);

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    _logger.debug('Initializing...');

    final bloc = FastAppFeaturesBloc.instance;
    bloc.addEvent(const FastAppFeaturesBlocEvent.init());

    final blocState = await RaceStream([
      bloc.onError,
      bloc.onData.where((state) => state.isInitialized),
    ]).first;

    if (blocState is! FastAppFeaturesBlocState) {
      _logger.error('Failed to initialize: $blocState');
      throw blocState;
    }

    _logger.debug('Initialized');
  }
}
