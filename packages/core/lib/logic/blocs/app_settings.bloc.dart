// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// The [FastAppSettingsBloc] is used to manage the app settings.
/// It can be used to change the language code, the country code
/// or the theme.
class FastAppSettingsBloc extends BidirectionalBloc<FastAppSettingsBlocEvent,
    FastAppSettingsBlocState> {
  /// Keeps track if a singleton instance has been created.
  static bool get hasBeenInstantiated => _hasBeenInstantiated;
  static bool _hasBeenInstantiated = false;

  static final _logger = TLoggerManager.instance.getLogger(debugLabel);
  static const debugLabel = 'FastAppSettingsBloc';

  static late FastAppSettingsBloc _instance;

  IFastAnalyticsService? analyticsService;

  static FastAppSettingsBloc get instance {
    if (!_hasBeenInstantiated) return FastAppSettingsBloc();

    return _instance;
  }

  static final _dataProvider = FastAppSettingsDataProvider();

  // Method to reset the singleton instance
  static void reset() => _instance.resetBloc();

  late FastAppSettingsDocument _persistedSettings;

  FastAppSettingsBloc._({this.analyticsService})
      : super(
          initialState: FastAppSettingsBlocState(),
        );

  factory FastAppSettingsBloc({IFastAnalyticsService? analyticsService}) {
    if (!hasBeenInstantiated) {
      _instance = FastAppSettingsBloc._(analyticsService: analyticsService);
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  @override
  bool canClose() => false;

  @override
  Stream<FastAppSettingsBlocState> mapEventToState(
    FastAppSettingsBlocEvent event,
  ) async* {
    final payload = event.payload;
    final type = event.type;

    _logger.debug('Event received: $type');

    if (type == FastAppSettingsBlocEventType.init) {
      yield* handleInitEvent(payload);
    } else if (type == FastAppSettingsBlocEventType.initialized) {
      yield* handleInitializedEvent(payload);
    } else if (isInitialized) {
      switch (type) {
        case FastAppSettingsBlocEventType.languageCodeChanged:
          yield* handleLanguageCodeChangedEvent(payload);
        case FastAppSettingsBlocEventType.themeChanged:
          yield* handleThemeChangedEvent(payload);
        case FastAppSettingsBlocEventType.countryCodeChanged:
          yield* handleCountryCodeChangedEvent(payload);
        case FastAppSettingsBlocEventType.primaryCurrencyCodeChanged:
          yield* handlePrimaryCurrencyCodeChangedEvent(payload);
        case FastAppSettingsBlocEventType.secondaryCurrencyCodeChanged:
          yield* handleSecondaryCurrencyCodeChangedEvent(payload);
        case FastAppSettingsBlocEventType.saveEntryChanged:
          yield* handleSaveEntryChangedEvent(payload);
        case FastAppSettingsBlocEventType.use24HourFormatChanged:
          yield* handleuse24HourFormatChangedEvent(payload);
        default:
          break;
      }
    } else {
      assert(false, 'FastAppSettingsBloc is not initialized yet.');
    }
  }

  /// Handle the [FastAppSettingsBlocEventType.init] event.
  /// This event is used to initialize the bloc.
  /// It will retrieve the settings from the data provider and
  /// dispatch a [FastAppSettingsBlocEventType.initialized] event.
  Stream<FastAppSettingsBlocState> handleInitEvent(
    FastAppSettingsBlocEventPayload? payload,
  ) async* {
    if (canInitialize) {
      _logger.debug('Initializing...');
      isInitializing = true;
      yield currentState.copyWith(isInitializing: true);

      final settings = await _retrievePersistedSettings();

      addEvent(FastAppSettingsBlocEvent.initialized(
        FastAppSettingsBlocEventPayload(
          theme: settings.theme ?? kFastSettingsThemeMap[ThemeMode.system],
          languageCode: payload?.languageCode ?? settings.languageCode,
          countryCode: payload?.countryCode ?? settings.countryCode,
          secondaryCurrencyCode: settings.secondaryCurrencyCode,
          primaryCurrencyCode: settings.primaryCurrencyCode,
          saveEntry: settings.saveEntry,
        ),
      ));
    }
  }

  /// Handle the [FastAppSettingsBlocEventType.initialized] event.
  /// This event is used to end the initialization process.
  /// It will set the bloc as initialized and dispatch a new state.
  /// The new state will contain the settings retrieved from the data provider.
  Stream<FastAppSettingsBlocState> handleInitializedEvent(
    FastAppSettingsBlocEventPayload? payload,
  ) async* {
    if (isInitializing) {
      _logger.debug('Initialized');
      isInitialized = true;

      yield currentState.copyWith(
        saveEntry: payload?.saveEntry ?? kFastAppSettingsSaveEntry,
        secondaryCurrencyCode: payload?.secondaryCurrencyCode,
        primaryCurrencyCode: payload?.primaryCurrencyCode,
        countryCode: () => payload?.countryCode,
        languageCode: payload?.languageCode,
        theme: payload?.theme,
        isInitializing: false,
        isInitialized: true,
      );
    }
  }

  /// Handle the [FastAppSettingsBlocEventType.languageCodeChanged] event.
  /// This event is used to change the app language.
  /// It will persist the language code in the data provider
  /// and dispatch a new state.
  /// The new state will contain the new language code.
  Stream<FastAppSettingsBlocState> handleLanguageCodeChangedEvent(
    FastAppSettingsBlocEventPayload? payload,
  ) async* {
    if (payload?.languageCode != null) {
      final languageCode = payload?.languageCode;
      await _persistLanguageCode(languageCode);

      analyticsService?.logEvent(name: 'app_setting', parameters: {
        'key': 'language_code',
        'value': languageCode,
      });

      yield currentState.copyWith(
        languageCode: _persistedSettings.languageCode,
      );
    }
  }

  /// Handle the [FastAppSettingsBlocEventType.themeChanged] event.
  /// This event is used to change the app theme.
  /// It will persist the theme in the data provider and dispatch a new state.
  /// The new state will contain the new theme.
  Stream<FastAppSettingsBlocState> handleThemeChangedEvent(
    FastAppSettingsBlocEventPayload? payload,
  ) async* {
    if (payload?.theme != null) {
      final theme = payload?.theme;
      await _persistTheme(theme);

      analyticsService?.logEvent(name: 'app_setting', parameters: {
        'key': 'theme',
        'value': theme,
      });

      yield currentState.copyWith(theme: _persistedSettings.theme);
    }
  }

  /// Handle the [FastAppSettingsBlocEventType.countryCodeChanged] event.
  /// This event is used to change the app country code.
  /// It will persist the country code in the data provider
  /// and dispatch a new state.
  /// The new state will contain the new country code.
  Stream<FastAppSettingsBlocState> handleCountryCodeChangedEvent(
    FastAppSettingsBlocEventPayload? payload,
  ) async* {
    final countryCode = payload!.countryCode;
    await _persistCountryCode(countryCode);

    analyticsService?.logEvent(name: 'app_setting', parameters: {
      'key': 'country_code',
      'value': countryCode,
    });

    yield currentState.copyWith(
      countryCode: () => _persistedSettings.countryCode,
    );
  }

  /// Handles the `primaryCurrencyCodeChanged` event by persisting the new
  /// primary currency code and updating the state.
  ///
  /// The [payload] parameter contains the new primary currency code.
  Stream<FastAppSettingsBlocState> handlePrimaryCurrencyCodeChangedEvent(
    FastAppSettingsBlocEventPayload? payload,
  ) async* {
    if (payload?.primaryCurrencyCode != null) {
      final primaryCurrencyCode = payload?.primaryCurrencyCode;
      await _persistPrimaryCurrencyCode(primaryCurrencyCode);

      analyticsService?.logEvent(name: 'app_setting', parameters: {
        'key': 'primary_currency_code',
        'value': primaryCurrencyCode,
      });

      yield currentState.copyWith(
        primaryCurrencyCode: _persistedSettings.primaryCurrencyCode,
      );
    }
  }

  /// Handles the `secondaryCurrencyCodeChanged` event by persisting the new
  /// secondary currency code and updating the state.
  ///
  /// The [payload] parameter contains the new secondary currency code.
  Stream<FastAppSettingsBlocState> handleSecondaryCurrencyCodeChangedEvent(
    FastAppSettingsBlocEventPayload? payload,
  ) async* {
    if (payload?.secondaryCurrencyCode != null) {
      final secondaryCurrencyCode = payload?.secondaryCurrencyCode;
      await _persistSecondaryCurrencyCode(secondaryCurrencyCode);

      analyticsService?.logEvent(name: 'app_setting', parameters: {
        'key': 'secondary_currency_code',
        'value': secondaryCurrencyCode,
      });

      yield currentState.copyWith(
        secondaryCurrencyCode: _persistedSettings.secondaryCurrencyCode,
      );
    }
  }

  /// Handles the `saveEntryChanged` event by persisting the new save entry
  /// value and updating the state.
  ///
  /// The [payload] parameter contains the new save entry value.
  Stream<FastAppSettingsBlocState> handleSaveEntryChangedEvent(
    FastAppSettingsBlocEventPayload? payload,
  ) async* {
    if (payload?.saveEntry != null) {
      final saveEntry = payload?.saveEntry;
      await _persistSaveEntry(saveEntry);

      analyticsService?.logEvent(name: 'app_setting', parameters: {
        'key': 'save_entry',
        'value': saveEntry,
      });

      yield currentState.copyWith(saveEntry: _persistedSettings.saveEntry);
    }
  }

  /// Handles the `use24HourFormatChanged` event by persisting the new
  /// always use 24 hour format value and updating the state.
  Stream<FastAppSettingsBlocState> handleuse24HourFormatChangedEvent(
    FastAppSettingsBlocEventPayload? payload,
  ) async* {
    if (payload?.use24HourFormat != null) {
      final use24HourFormat = payload?.use24HourFormat;
      await _persistuse24HourFormat(use24HourFormat);

      yield currentState.copyWith(
        use24HourFormat: _persistedSettings.use24HourFormat,
      );
    }
  }

  /// Persists the new always use 24 hour format value.
  /// The [use24HourFormat] parameter represents the new always use 24
  /// hour format value to be persisted.
  Future<FastAppSettingsDocument> _persistuse24HourFormat(
    bool? use24HourFormat,
  ) async {
    if (use24HourFormat != null &&
        use24HourFormat != currentState.use24HourFormat) {
      final newSettings = _persistedSettings.copyWith(
        use24HourFormat: use24HourFormat,
      );

      await _dataProvider.persistSettings(newSettings);
    }

    return _retrievePersistedSettings();
  }

  /// Persists the new primary currency code.
  ///
  /// The [primaryCurrencyCode] parameter represents the new primary currency
  /// code to be persisted.
  Future<FastAppSettingsDocument> _persistPrimaryCurrencyCode(
    String? primaryCurrencyCode,
  ) async {
    if (primaryCurrencyCode != null &&
        primaryCurrencyCode != currentState.primaryCurrencyCode) {
      // TODO: check if the currency code is valid and supported.
      final newSettings = _persistedSettings.copyWith(
        primaryCurrencyCode: primaryCurrencyCode.toUpperCase(),
      );

      await _dataProvider.persistSettings(newSettings);
    }

    return _retrievePersistedSettings();
  }

  /// Persists the new secondary currency code.
  ///
  /// The [secondaryCurrencyCode] parameter represents the new secondary
  /// currency code to be persisted.
  Future<FastAppSettingsDocument> _persistSecondaryCurrencyCode(
    String? secondaryCurrencyCode,
  ) async {
    if (secondaryCurrencyCode != null &&
        secondaryCurrencyCode != currentState.secondaryCurrencyCode) {
      final newSettings = _persistedSettings.copyWith(
        secondaryCurrencyCode: secondaryCurrencyCode.toUpperCase(),
      );

      await _dataProvider.persistSettings(newSettings);
    }

    return _retrievePersistedSettings();
  }

  /// Persists the new save entry value.
  ///
  /// The [saveEntry] parameter represents the new save entry value to be
  /// persisted.
  Future<FastAppSettingsDocument> _persistSaveEntry(bool? saveEntry) async {
    if (saveEntry != null && saveEntry != currentState.saveEntry) {
      final newSettings = _persistedSettings.copyWith(saveEntry: saveEntry);
      await _dataProvider.persistSettings(newSettings);
    }

    return _retrievePersistedSettings();
  }

  /// Persist the language code in the data provider.
  /// If the language code is the same as the current state,
  /// nothing will be done.
  Future<void> _persistLanguageCode(String? languageCode) async {
    if (languageCode != null && languageCode != currentState.languageCode) {
      final newSettings = _persistedSettings.copyWith(
        languageCode: languageCode,
      );

      await _dataProvider.persistSettings(newSettings);
      await _retrievePersistedSettings();
    }
  }

  /// Persist the theme in the data provider.
  /// If the theme is the same as the current state, nothing will be done.
  Future<void> _persistTheme(String? theme) async {
    if (theme != null && theme != currentState.theme) {
      final newSettings = _persistedSettings.copyWith(theme: theme);
      await _dataProvider.persistSettings(newSettings);
      await _retrievePersistedSettings();
    }
  }

  /// Persist the country code in the data provider.
  /// If the country code is the same as the current state,
  /// nothing will be done.
  Future<void> _persistCountryCode(String? countryCode) async {
    if (countryCode != currentState.countryCode) {
      final newSettings = _persistedSettings.copyWith(
        countryCode: () => countryCode,
      );

      await _dataProvider.persistSettings(newSettings);
      await _retrievePersistedSettings();
    }
  }

  /// Retrieve the settings from the data provider.
  Future<FastAppSettingsDocument> _retrievePersistedSettings() async {
    await _dataProvider.connect();

    return (_persistedSettings = await _dataProvider.retrieveSettings());
  }
}
