import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tlogger/logger.dart';

class FastAdConsentService {
  static FastAdConsentService? _instance;
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static final _manager = TLoggerManager();
  static const _debugLabel = 'FastAdConsentService';

  Future<bool>? _consentInfoUpdateFuture;

  static FastAdConsentService get instance {
    _instance ??= FastAdConsentService._internal();

    return _instance!;
  }

  FastAdConsentService._internal();

  /// Shows the consent form if it is available and required.
  Future<bool> showConsentFormIfNeeded() async {
    final status = await getConsentStatus();

    if (status == ConsentStatus.required) {
      _logger.debug('Consent status is required, will show consent form');
      return showConsentForm();
    }

    return false;
  }

  /// Shows the consent form if it is available.
  Future<bool> showConsentForm() async {
    if (await _isConsentFormAvailable()) {
      _logger.debug('Consent form is available, loading consent form...');
      final consentForm = await _loadConsentForm();
      final completer = Completer<bool>();

      if (consentForm != null) {
        _logger.debug('Consent form loaded, showing consent form...');

        consentForm.show((formError) async {
          _logger.debug('Consent form closed');

          if (formError != null) {
            _logger.error('Consent form error: $formError');
          }

          final status = await getConsentStatus();
          _logger.info('Consent status', status);

          await MobileAds.instance.initialize();

          completer.complete(true);
        });

        return completer.future;
      } else {
        _logger.error('Consent form is null');
      }
    } else {
      _logger.debug('Consent form is not available');
    }

    return false;
  }

  /// Gets the consent status.
  Future<ConsentStatus> getConsentStatus() async {
    if (await _requestConsentInfoUpdate()) {
      return ConsentInformation.instance.getConsentStatus();
    }

    return ConsentStatus.unknown;
  }

  /// Resets the consent status.
  // NOTE: should only be used for testing.
  Future<void> reset() async {
    await ConsentInformation.instance.reset();
  }

  Future<bool> _requestConsentInfoUpdate() async {
    if (_consentInfoUpdateFuture == null) {
      final completer = Completer<bool>();
      final params = ConsentRequestParameters();

      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
        () => completer.complete(true),
        (error) {
          _logger.error('Consent info update error: $error');
          completer.complete(false);
        },
      );

      return (_consentInfoUpdateFuture = completer.future);
    }

    return _consentInfoUpdateFuture!;
  }

  Future<bool> _isConsentFormAvailable() async {
    return ConsentInformation.instance.isConsentFormAvailable();
  }

  Future<ConsentForm?> _loadConsentForm() async {
    final completer = Completer<ConsentForm?>();

    ConsentForm.loadConsentForm(
      completer.complete,
      (error) {
        _logger.error('Consent form error: $error');
        completer.complete(null);
      },
    );

    return completer.future;
  }
}
