// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:async/async.dart';
import 'package:tbloc/tbloc.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

abstract class FastJob {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static final _manager = TLoggerManager();
  static const _debugLabel = 'FastJob';

  @protected
  final bool requestUserInteraction;
  final String? debugLabel;

  /// The time limit for the job to complete.
  @protected
  final Duration timeout;

  /// Whether the job should prevent the app from starting if it fails.
  final bool blockStartupOnFailure;

  const FastJob({
    this.timeout = kFastJobTimeout,
    this.requestUserInteraction = false,
    this.blockStartupOnFailure = true,
    this.debugLabel,
  });

  @protected
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  });

  Future<bool> run(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) {
    _logger.debug('Job started: $debugLabel');

    final completer = Completer<bool>();
    var operationAsync = initialize(context, errorReporter: errorReporter);

    if (!requestUserInteraction) {
      operationAsync = operationAsync.timeout(timeout);
    } else {
      // Wait for the next frame to ensure that
      // the next job can request a user interaction.
      operationAsync = operationAsync.then((value) {
        final userInteractionCompleter = Completer<void>();

        WidgetsBinding.instance.scheduleFrameCallback((_) {
          userInteractionCompleter.complete();
        });

        return userInteractionCompleter.future;
      });
    }

    final blocInitializationOperation = CancelableOperation.fromFuture(
      operationAsync,
    );

    operationAsync.catchError((dynamic error, StackTrace? stackTrace) {
      _logger.error('Job failed: $debugLabel => $error', stackTrace);
      blocInitializationOperation.cancel();

      if (blockStartupOnFailure) {
        completer.completeError(_transformError(error, stackTrace), stackTrace);
      } else {
        completer.complete(true);
      }
    }).whenComplete(() {
      if (!completer.isCompleted) {
        _logger.debug('Job completed: $debugLabel');
        completer.complete(true);
      }
    });

    return completer.future;
  }

  FastJobError _transformError(dynamic error, StackTrace? stackTrace) {
    if (error is BlocError) {
      return FastJobError(
        stackTrace: error.stackTrace,
        debugLabel: debugLabel,
        source: error.source,
      );
    }

    return FastJobError(
      stackTrace: stackTrace ?? StackTrace.current,
      debugLabel: debugLabel,
      source: error,
    );
  }
}
