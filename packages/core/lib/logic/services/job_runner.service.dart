// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:decimal/decimal.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastJobRunner {
  @protected
  final BuildContext context;
  @protected
  final Iterable<FastJob> jobs;

  late Stream<double> _runner;
  bool _isRunning = false;

  FastJobRunner(this.context, [this.jobs = const <FastJob>[]]);

  Stream<double> run({
    IFastErrorReporter? errorReporter,
  }) {
    if (!_isRunning) {
      final rProgresStep = Decimal.one / Decimal.fromInt(jobs.length);
      final dProgresStep = rProgresStep.toDecimal(scaleOnInfinitePrecision: 32);
      var progress = Decimal.zero;
      var hasError = false;
      _isRunning = true;

      _runner = Stream.fromIterable(jobs)
          .takeWhile((FastJob job) => !hasError)
          .asyncExpand((FastJob job) {
            final completer = Completer<bool>();

            WidgetsBinding.instance.scheduleFrameCallback((_) {
              runZonedGuarded(() async {
                final response = await job.run(
                  context,
                  errorReporter: errorReporter,
                );

                completer.complete(response);
              }, (error, stackTrace) => completer.completeError(error));
            });

            return Stream.fromFuture(completer.future);
          })
          .map((_) {
            progress += dProgresStep;

            return progress.toDouble();
          })
          .handleError((error) {
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
          })
          .doOnDone(() => _isRunning = false)
          .doOnCancel(() => _isRunning = false);
    }

    return _runner;
  }
}
