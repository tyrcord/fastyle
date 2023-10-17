import 'package:flutter/material.dart';
import 'package:fastyle_core/fastyle_core.dart';

class FastAppFinalizeJob extends FastJob {
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
  const FastAppFinalizeJob._({this.callbacks})
      : super(debugLabel: 'FastAppFinalizeJob');

  // The initialize method to be called to start the job.
  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    // Check if there are any callbacks provided. If none, we do not need
    // to proceed.
    if (callbacks == null || callbacks!.isEmpty) return;

    // Execute all the provided callbacks.
    for (final callback in callbacks!) {
      try {
        await callback(context); // Waiting for the callback to complete.
      } catch (error, stackTrace) {
        if (errorReporter != null) {
          errorReporter.recordError(error, stackTrace);
        }

        rethrow;
      }
    }
  }
}
