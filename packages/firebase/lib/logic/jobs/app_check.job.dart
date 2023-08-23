// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

class FastFirebaseAppCheckJob extends FastJob {
  static FastFirebaseAppCheckJob? _singleton;

  final AndroidProvider? androidProvider;
  final String? webRecaptchaSiteKey;

  factory FastFirebaseAppCheckJob({
    String? webRecaptchaSiteKey,
    AndroidProvider? androidProvider,
  }) {
    _singleton ??= FastFirebaseAppCheckJob._(
      webRecaptchaSiteKey: webRecaptchaSiteKey,
      androidProvider: androidProvider,
    );

    return _singleton!;
  }

  const FastFirebaseAppCheckJob._({
    this.webRecaptchaSiteKey,
    this.androidProvider,
  }) : super(debugLabel: 'FastFirebaseAppCheckJob');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    await FirebaseAppCheck.instance.activate(
      androidProvider: androidProvider ?? AndroidProvider.playIntegrity,
      webRecaptchaSiteKey: webRecaptchaSiteKey,
      appleProvider: AppleProvider.appAttest,
    );
  }
}
