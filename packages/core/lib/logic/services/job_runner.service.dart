// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';
import 'package:tbloc/tbloc.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastJobRunner {
  static const _debugLabel = 'FastJobRunner';
  static final _manager = TLoggerManager();

  @protected
  final BuildContext context;
  @protected
  final Iterable<FastJob> jobs;

  late Stream<double> _runner;
  late final TLogger _logger;
  bool _isRunning = false;

  FastJobRunner(this.context, [this.jobs = const <FastJob>[]]) {
    _logger = _manager.getLogger(_debugLabel);
  }

  Stream<double> run({
    IFastErrorReporter? errorReporter,
  }) {
    if (!_isRunning) {
      _logger.debug('Running jobs...');
      final progresStep = 1 / jobs.length;
      var progress = 0.0;
      var hasError = false;
      _isRunning = true;

      _runner = Stream.fromIterable(jobs)
          .takeWhile((FastJob job) => !hasError)
          .asyncExpand((FastJob job) {
        final completer = Completer<bool>();

        WidgetsBinding.instance.scheduleFrameCallback((_) {
          runZonedGuarded(() async {
            try {
              final response = await job.run(
                context,
                errorReporter: errorReporter,
              );

              if (!completer.isCompleted) {
                completer.complete(response);
              }
            } catch (error) {
              if (!context.mounted) {
                _logger.warning(
                  'Job failed: ${job.debugLabel ?? 'Unknown'} - '
                  'but the context is not mounted',
                );
              } else {
                rethrow;
              }
            }
          }, (error, stackTrace) {
            if (!completer.isCompleted) {
              final debugLabel = job.debugLabel ?? 'Unknown';
              final prefix = 'Job failed: $debugLabel - ';

              if (job.blockStartupOnFailure) {
                final message = '$prefix$error';
                completer.completeError(message, stackTrace);
              } else {
                _logger.warning('${prefix}but startup failure is prevented');
              }
            }
          });
        });

        return Stream.fromFuture(completer.future);
      }).map((_) {
        progress += progresStep;

        return progress;
      }).handleError((error) {
        hasError = true;

        if (error is FastJobError) {
          errorReporter?.recordError(
            error.source,
            error.stackTrace,
            reason: error.debugLabel,
          );
        } else if (error is BlocError) {
          errorReporter?.recordError(
            error.source,
            error.stackTrace,
            reason: error.message,
          );
        } else if (error is Error) {
          errorReporter?.recordError(
            error,
            error.stackTrace ?? StackTrace.current,
          );
        } else {
          errorReporter?.recordError(
            error,
            StackTrace.current,
          );
        }

        throw error as Object;
      }).doOnDone(() {
        _logger.debug('Jobs completed');
        _isRunning = false;
      }).doOnCancel(() {
        if (_isRunning) {
          _logger.debug('Canceling jobs...');
          _isRunning = false;
        }
      });
    }

    return _runner;
  }
}
