// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:devicelocale/devicelocale.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppInfoBloc
    extends BidirectionalBloc<FastAppInfoBlocEvent, FastAppInfoBlocState> {
  static FastAppInfoBloc? _singleton;
  FastAppInfoDataProvider _dataProvider;

  FastAppInfoBloc._({FastAppInfoBlocState? initialState})
      : _dataProvider = FastAppInfoDataProvider(),
        super(initialState: initialState ?? FastAppInfoBlocState());

  factory FastAppInfoBloc({FastAppInfoBlocState? initialState}) {
    _singleton ??= FastAppInfoBloc._(initialState: initialState);

    return _singleton!;
  }

  @override
  bool canClose() => false;

  @override
  Stream<FastAppInfoBlocState> mapEventToState(
    FastAppInfoBlocEvent event,
  ) async* {
    final payload = event.payload;
    final type = event.type;

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
      isInitializing = true;
      yield currentState.copyWith(isInitializing: true);

      // Determine the user language and country code from the device locale.
      final (deviceLanguageCode, deviceCountryCode) =
          await getPreferredLocale();

      final persistedDocument = await _retrievePersistedAppInfo();
      final packageInfo = await PackageInfo.fromPlatform();
      var document = appInfoDocument;

      document = document.copyWith(
        // Values controlled by the persisted document.
        previousDatabaseVersion: persistedDocument.databaseVersion,
        appLaunchCounter: persistedDocument.appLaunchCounter,

        // Values controlled by the device.
        appBuildNumber: packageInfo.buildNumber,
        deviceLanguageCode: deviceLanguageCode,
        deviceCountryCode: deviceCountryCode,
        appVersion: packageInfo.version,
      );

      addEvent(FastAppInfoBlocEvent.initialized(document));
    }
  }

  Stream<FastAppInfoBlocState> handleInitializedEvent(
    FastAppInfoDocument document,
  ) async* {
    if (isInitializing) {
      isInitialized = true;

      final nextDocument = document.copyWith(
        appLaunchCounter: document.appLaunchCounter + 1,
      );

      await _dataProvider.persistAppInfo(nextDocument);

      final tmpState = FastAppInfoBlocState.fromDocument(nextDocument);

      yield currentState.merge(tmpState).copyWith(
            isInitializing: false,
            isInitialized: true,
          );
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
}
