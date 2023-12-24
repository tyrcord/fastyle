// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppOnboardingJob extends FastJob {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static const _debugLabel = 'FastAppOnboardingJob';
  static final _manager = TLoggerManager();
  static FastAppOnboardingJob? _singleton;

  factory FastAppOnboardingJob() {
    return (_singleton ??= const FastAppOnboardingJob._());
  }

  const FastAppOnboardingJob._() : super(debugLabel: _debugLabel);

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    _logger.debug('Initializing...');

    final bloc = FastAppOnboardingBloc.instance;
    bloc.addEvent(const FastAppOnboardingBlocEvent.init());

    final onboardingState = await RaceStream([
      bloc.onError,
      bloc.onData.where((state) => state.isInitialized),
    ]).first;

    if (onboardingState is! FastAppOnboardingBlocState) {
      _logger.error('Failed to initialize: $onboardingState');
      throw onboardingState;
    }

    _logger.debug('Initialized');
  }
}
