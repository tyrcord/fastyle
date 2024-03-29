// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tlogger/logger.dart';

class FastFirebaseAppCheckJob extends FastJob {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static const _debugLabel = 'FastFirebaseAppCheckJob';
  static FastFirebaseAppCheckJob? _singleton;
  static final _manager = TLoggerManager();

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
  }) : super(debugLabel: _debugLabel);

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    _logger.debug('Initializing...');

    final apps = Firebase.apps;

    for (final app in apps) {
      _logger.debug('Activating Firebase App Check for ${app.name}...');
      final appCheck = FirebaseAppCheck.instanceFor(app: app);

      var appleProviderAppCheck =
          AppleProvider.appAttestWithDeviceCheckFallback;
      var androidProviderAppCheck =
          androidProvider ?? AndroidProvider.playIntegrity;

      if (kDebugMode) {
        androidProviderAppCheck = AndroidProvider.debug;
        appleProviderAppCheck = AppleProvider.debug;
      }

      await appCheck.activate(
        androidProvider: androidProviderAppCheck,
        appleProvider: appleProviderAppCheck,
        webProvider: webRecaptchaSiteKey is String
            ? ReCaptchaEnterpriseProvider(webRecaptchaSiteKey!)
            : null,
      );

      _logger.debug('Activated Firebase App Check for ${app.name}');
    }

    _logger.debug('Initialized');
  }
}
