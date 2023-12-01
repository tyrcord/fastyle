// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:t_helpers/helpers.dart';

class FastFirebaseAppErrorReporter extends IFastErrorReporter {
  bool get canReportError => !isWeb && !isMacOS;

  @override
  Future<void> recordError(
    dynamic error,
    StackTrace stackTrace, {
    String? reason,
  }) async {
    if (canReportError) {
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
    if (canReportError) {
      return FirebaseCrashlytics.instance.setCustomKey(key, value as Object);
    }
  }
}
