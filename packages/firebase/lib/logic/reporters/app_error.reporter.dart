// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class FastFirebaseAppErrorReporter extends IFastErrorReporter {
  @override
  Future<void> recordError(
    dynamic error,
    StackTrace stackTrace, {
    String? reason,
  }) async {
    if (!kIsWeb) {
      return FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: reason,
        printDetails: true,
      );
    }
  }

  @override
  Future<void> setCustomKey(String key, dynamic value) async {
    if (!kIsWeb) {
      return FirebaseCrashlytics.instance.setCustomKey(key, value as Object);
    }
  }
}
