// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tbloc/tbloc.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppInfoBloc
    extends BidirectionalBloc<FastAppInfoBlocEvent, FastAppInfoBlocState> {
  /// Keeps track if a singleton instance has been created.
  static bool get hasBeenInstantiated => _hasBeenInstantiated;
  static bool _hasBeenInstantiated = false;

  static final _logger = TLoggerManager.instance.getLogger(debugLabel);
  static const debugLabel = 'FastAppInfoBloc';

  static late FastAppInfoBloc _instance;

  static FastAppInfoBloc get instance {
    if (!_hasBeenInstantiated) return FastAppInfoBloc();

    return _instance;
  }

  static final _dataProvider = FastAppInfoDataProvider();

  // Method to reset the singleton instance
  static void reset() => instance.resetBloc();

  FastAppInfoBloc._() : super(initialState: FastAppInfoBlocState());

  factory FastAppInfoBloc() {
    if (!_hasBeenInstantiated) {
      _instance = FastAppInfoBloc._();
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  @override
  bool canClose() => false;

  @override
  Stream<FastAppInfoBlocState> mapEventToState(
    FastAppInfoBlocEvent event,
  ) async* {
    final payload = event.payload;
    final type = event.type;

    _logger.debug('Event received: $type');

    if (type == FastAppInfoBlocEventType.init) {
      if (payload is FastAppInfoDocument) {
        yield* handleInitEvent(payload);
      }
    } else if (type == FastAppInfoBlocEventType.initialized) {
      if (payload is FastAppInfoDocument) {
        yield* handleInitializedEvent(payload);
      }
    } else {
      assert(false, 'FastAppInfoBloc is not initialized yet.');
    }
  }

  Stream<FastAppInfoBlocState> handleInitEvent(
    FastAppInfoDocument appInfoDocument,
  ) async* {
    if (canInitialize) {
      _logger.debug('Initializing...');

      isInitializing = true;
      yield currentState.copyWith(isInitializing: true);

      // Determine the user language and country code from the device locale.
      final (deviceLanguageCode, deviceCountryCode) =
          await getPreferredLocale();

      final persistedDocument = await _retrievePersistedAppInfo();
      final packageInfo = await PackageInfo.fromPlatform();
      final osVersion = await _getOsVersion();
      final osName = await getOsName();
      final appVersion = packageInfo.version;
      final appBuildNumber = packageInfo.buildNumber;
      var document = appInfoDocument;

      _logger
        ..info('OS name', osName)
        ..info('OS version', osVersion)
        ..info('App build', appBuildNumber)
        ..info('App version', appVersion)
        ..info('Device language code', deviceLanguageCode)
        ..info('Device country code', deviceCountryCode);

      document = document.copyWith(
        // Values controlled by the persisted document.
        previousDatabaseVersion: persistedDocument.databaseVersion,
        appLaunchCounter: persistedDocument.appLaunchCounter,

        // Values controlled by the device.
        deviceLanguageCode: deviceLanguageCode,
        deviceCountryCode: deviceCountryCode,
        appBuildNumber: appBuildNumber,
        appVersion: appVersion,
        osVersion: osVersion,
      );

      addEvent(FastAppInfoBlocEvent.initialized(document));
    }
  }

  Stream<FastAppInfoBlocState> handleInitializedEvent(
    FastAppInfoDocument document,
  ) async* {
    if (isInitializing) {
      _logger.debug('Initialized');
      isInitialized = true;

      final nextDocument = document.copyWith(
        appLaunchCounter: document.appLaunchCounter + 1,
      );

      await _dataProvider.persistAppInfo(nextDocument);

      var tmpState = FastAppInfoBlocState.fromDocument(nextDocument);

      tmpState = currentState.merge(tmpState).copyWith(
            isInitializing: false,
            isInitialized: true,
          );

      _logger.info('Is first launch', tmpState.isFirstLaunch);

      yield tmpState;
    }
  }

  Future<FastAppInfoDocument> _retrievePersistedAppInfo() async {
    await _dataProvider.connect();

    return _dataProvider.retrieveAppInfo();
  }

  Future<(String, String?)> getPreferredLocale() async {
    final deviceIntlLocale = await getDevicelocale();

    return (deviceIntlLocale.languageCode, deviceIntlLocale.countryCode);
  }

  Future<Locale> getDevicelocale() async {
    final localeIdentifiers = await Devicelocale.preferredLanguagesAsLocales;

    return localeIdentifiers.first;
  }

  Future<String> _getOsVersion() async {
    String osVersion = '0';

    try {
      if (isAndroid) {
        final deviceInfo = await DeviceInfoPlugin().androidInfo;
        osVersion = deviceInfo.version.release;
      } else if (isIOS) {
        final deviceInfo = await DeviceInfoPlugin().iosInfo;
        osVersion = deviceInfo.systemVersion;
      } else if (isMacOS) {
        final deviceInfo = await DeviceInfoPlugin().macOsInfo;
        final major = deviceInfo.majorVersion;
        final minor = deviceInfo.minorVersion;

        osVersion = '$major.$minor';
      }
    } catch (error) {
      debugLog(
        'Error while getting the OS version',
        debugLabel: debugLabel,
        value: error,
      );
    }

    final parts = osVersion.split('.');

    if (parts.length > 1) {
      osVersion = '${parts[0]}.${parts[1]}';
    } else {
      osVersion = parts[0];
    }

    return osVersion;
  }

  Future<String> getOsName() async {
    if (isAndroid) {
      return "Android";
    } else if (isIOS) {
      return "iOS";
    } else if (isMacOS) {
      return "macOS";
    } else if (isWindows) {
      return "Windows";
    } else if (isLinux) {
      return "Linux";
    } else if (isFuchsia) {
      return "Fuchsia";
    } else if (isWeb) {
      return "Web";
    } else {
      return "Unknown";
    }
  }
}
