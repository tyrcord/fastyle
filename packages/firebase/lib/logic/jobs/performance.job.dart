// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:t_helpers/helpers.dart';

class FastFirebasePerformanceJob extends FastJob {
  static FastFirebasePerformanceJob? _singleton;

  factory FastFirebasePerformanceJob() {
    _singleton ??= const FastFirebasePerformanceJob._();

    return _singleton!;
  }

  const FastFirebasePerformanceJob._()
      : super(debugLabel: 'FastFirebasePerformanceJob');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    if (isMacOS) return;

    final performance = FirebasePerformance.instance;

    return performance.setPerformanceCollectionEnabled(true);
  }
}
