// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:firebase_performance/firebase_performance.dart';

class FastFirebasePerformanceJob extends FastJob {
  static FastFirebasePerformanceJob? _singleton;

  factory FastFirebasePerformanceJob() {
    _singleton ??= const FastFirebasePerformanceJob._();

    return _singleton!;
  }

  const FastFirebasePerformanceJob._()
      : super(debugLabel: 'fast_firebase_performance_job');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    final performance = FirebasePerformance.instance;

    return performance.setPerformanceCollectionEnabled(true);
  }
}
