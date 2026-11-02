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

  /// Shared App Check debug token, passed at build time with
  /// `--dart-define=APP_CHECK_DEBUG_TOKEN=...` and registered once per
  /// Firebase app. Without it, each device generates its own token.
  static const _debugToken = String.fromEnvironment('APP_CHECK_DEBUG_TOKEN');

  final AndroidAppCheckProvider? androidProvider;
  final String? webRecaptchaSiteKey;

  factory FastFirebaseAppCheckJob({
    String? webRecaptchaSiteKey,
    AndroidAppCheckProvider? androidProvider,
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
    final debugToken = _debugToken.isEmpty ? null : _debugToken;

    if (kDebugMode) {
      _logger.debug(
        debugToken == null
            ? 'Using a device-generated App Check debug token'
            : 'Using the App Check debug token from APP_CHECK_DEBUG_TOKEN',
      );
    }

    for (final app in apps) {
      _logger.debug('Activating Firebase App Check for ${app.name}...');
      final appCheck = FirebaseAppCheck.instanceFor(app: app);

      AppleAppCheckProvider appleProviderAppCheck =
          const AppleAppAttestWithDeviceCheckFallbackProvider();
      AndroidAppCheckProvider androidProviderAppCheck =
          androidProvider ?? const AndroidPlayIntegrityProvider();

      if (kDebugMode) {
        androidProviderAppCheck = AndroidDebugProvider(debugToken: debugToken);
        appleProviderAppCheck = AppleDebugProvider(debugToken: debugToken);
      }

      await appCheck.activate(
        providerAndroid: androidProviderAppCheck,
        providerApple: appleProviderAppCheck,
        providerWeb: webRecaptchaSiteKey is String
            ? ReCaptchaEnterpriseProvider(webRecaptchaSiteKey!)
            : null,
      );

      _logger.debug('Activated Firebase App Check for ${app.name}');
    }

    _logger.debug('Initialized');
  }
}
