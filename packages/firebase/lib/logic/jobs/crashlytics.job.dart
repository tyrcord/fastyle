// Dart imports:
import 'dart:isolate';

// Flutter imports:
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tlogger/logger.dart';

class FastFirebaseCrashlyticsJob extends FastJob {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static const _debugLabel = 'FastFirebaseCrashlyticsJob';
  static final _manager = TLoggerManager();
  static FastFirebaseCrashlyticsJob? _singleton;
  final bool shouldEnableInDevMode;

  factory FastFirebaseCrashlyticsJob({bool shouldEnableInDevMode = false}) {
    _singleton ??= FastFirebaseCrashlyticsJob._(
      shouldEnableInDevMode: shouldEnableInDevMode,
    );

    return _singleton!;
  }

  const FastFirebaseCrashlyticsJob._({this.shouldEnableInDevMode = false})
      : super(debugLabel: _debugLabel);

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    if (isWeb) return;

    _logger.debug('Initializing...');

    final crashlytics = FirebaseCrashlytics.instance;

    if (kDebugMode) {
      crashlytics.setCrashlyticsCollectionEnabled(shouldEnableInDevMode);
    } else {
      crashlytics.setCrashlyticsCollectionEnabled(true);
    }

    FlutterError.onError = crashlytics.recordFlutterError;

    Isolate.current.addErrorListener(RawReceivePort((List<dynamic> pair) async {
      final List<dynamic> errorAndStacktrace = pair;

      await crashlytics.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last is StackTrace?
            ? errorAndStacktrace.last as StackTrace?
            : null,
      );
    }).sendPort);

    _logger.debug('Initialized');
  }
}
