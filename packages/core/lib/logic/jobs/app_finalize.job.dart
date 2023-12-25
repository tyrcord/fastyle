// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppFinalizeJob extends FastJob {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static const _debugLabel = 'FastAppFinalizeJob';
  static final _manager = TLoggerManager();
  static FastAppFinalizeJob? _singleton;

  // List of async callbacks.
  final List<Future Function(BuildContext context)>? callbacks;

  // Factory constructor to maintain a singleton instance.
  factory FastAppFinalizeJob({
    List<Future Function(BuildContext context)>? callbacks,
  }) {
    return (_singleton ??= FastAppFinalizeJob._(callbacks: callbacks));
  }

  // Named private constructor.
  const FastAppFinalizeJob._({this.callbacks}) : super(debugLabel: _debugLabel);

  // The initialize method to be called to start the job.
  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    // Check if there are any callbacks provided. If none, we do not need
    // to proceed.
    if (callbacks == null || callbacks!.isEmpty) return;

    _logger.debug('Initializing...');

    // Execute all the provided callbacks.
    for (final callback in callbacks!) {
      try {
        _logger.debug('Executing callback: $callback');
        await callback(context); // Waiting for the callback to complete.
      } catch (error, stackTrace) {
        _logger.error('Failed to execute callback: $error');

        if (errorReporter != null) {
          errorReporter.recordError(error, stackTrace);
        }

        rethrow;
      }
    }

    _logger.debug('Initialized');
  }
}
