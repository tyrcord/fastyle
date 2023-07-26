// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_dart/fastyle_dart.dart';
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

  FastFirebaseAppCheckJob._({
    this.webRecaptchaSiteKey,
    this.androidProvider,
  }) : super(debugLabel: 'fast_firebase_app_check_job');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    await FirebaseAppCheck.instance.activate(
      androidProvider: androidProvider ?? AndroidProvider.playIntegrity,
      webRecaptchaSiteKey: webRecaptchaSiteKey,
    );
  }
}