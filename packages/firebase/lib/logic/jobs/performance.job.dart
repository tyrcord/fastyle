// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tlogger/logger.dart';

class FastFirebasePerformanceJob extends FastJob {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static const _debugLabel = 'FastFirebasePerformanceJob';
  static FastFirebasePerformanceJob? _singleton;
  static final _manager = TLoggerManager();

  factory FastFirebasePerformanceJob() {
    return (_singleton ??= const FastFirebasePerformanceJob._());
  }

  const FastFirebasePerformanceJob._() : super(debugLabel: _debugLabel);

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    if (isMacOS) return;

    _logger.debug('Initializing...');

    final performance = FirebasePerformance.instance;

    await performance.setPerformanceCollectionEnabled(true);

    _logger.debug('Initialized');
  }
}
