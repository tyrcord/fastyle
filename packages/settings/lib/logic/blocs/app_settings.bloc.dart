import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:tbloc/tbloc.dart';
import 'package:flutter/material.dart';

/// The [FastAppSettingsBloc] is used to manage the app settings.
/// It can be used to change the language code, the country code
/// or the theme.
class FastAppSettingsBloc extends BidirectionalBloc<FastAppSettingsBlocEvent,
    FastAppSettingsBlocState> {
  final FastAppSettingsDataProvider _settingsProvider;
  late FastAppSettingsDocument _persistedSettings;

  FastAppSettingsBloc({
    super.initialState = const FastAppSettingsBlocState(),
  }) : _settingsProvider = FastAppSettingsDataProvider();

  @override
  @mustCallSuper
  void close() {
    if (!closed && canClose()) {
      super.close();
      _settingsProvider.disconnect();
    }
  }

  @override
  Stream<FastAppSettingsBlocState> mapEventToState(
    FastAppSettingsBlocEvent event,
  ) async* {
    final payload = event.payload;
    final type = event.type;

    if (type == FastAppSettingsBlocEventType.init) {
      yield* handleInitEvent();
    } else if (type == FastAppSettingsBlocEventType.initialized) {
      yield* handleInitializedEvent(payload);
    } else if (isInitialized) {
      switch (type) {
        case FastAppSettingsBlocEventType.languageCodeChanged:
          yield* handleLanguageCodeChangedEvent(payload);
          break;
        case FastAppSettingsBlocEventType.themeChanged:
          yield* handleThemeChangedEvent(payload);
          break;
        case FastAppSettingsBlocEventType.countryCodeChanged:
          yield* handleCountryCodeChangedEvent(payload);
          break;
        default:
          break;
      }
    } else {
      assert(false, 'SettingsBloc is not initialized yet.');
    }
  }

  /// Handle the [FastAppSettingsBlocEventType.init] event.
  /// This event is used to initialize the bloc.
  /// It will retrieve the settings from the data provider and
  /// dispatch a [FastAppSettingsBlocEventType.initialized] event.
  Stream<FastAppSettingsBlocState> handleInitEvent() async* {
    if (canInitialize) {
      isInitializing = true;
      yield const FastAppSettingsBlocState(isInitializing: true);

      final settings = await _retrivePersistedSettings();

      addEvent(FastAppSettingsBlocEvent.initialized(
        theme: settings.theme ?? kFastSettingsThemeMap[ThemeMode.system],
        languageCode: settings.languageCode,
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
      isInitialized = true;

      yield FastAppSettingsBlocState(
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
    if (payload?.countryCode != null) {
      final countryCode = payload?.countryCode;
      await _persistCountryCode(countryCode);

      yield currentState.copyWith(
        countryCode: _persistedSettings.countryCode,
      );
    }
  }

  /// Persist the language code in the data provider.
  /// If the language code is the same as the current state,
  /// nothing will be done.
  Future<void> _persistLanguageCode(String? languageCode) async {
    if (languageCode != null && languageCode != currentState.languageCode) {
      final newSettings = _persistedSettings.copyWith(
        languageCode: languageCode,
      );

      await _settingsProvider.persistSettings(newSettings);
      await _retrivePersistedSettings();
    }
  }

  /// Persist the theme in the data provider.
  /// If the theme is the same as the current state, nothing will be done.
  Future<void> _persistTheme(String? theme) async {
    if (theme != null && theme != currentState.theme) {
      final newSettings = _persistedSettings.copyWith(theme: theme);
      await _settingsProvider.persistSettings(newSettings);
      await _retrivePersistedSettings();
    }
  }

  /// Persist the country code in the data provider.
  /// If the country code is the same as the current state,
  /// nothing will be done.
  Future<void> _persistCountryCode(String? countryCode) async {
    if (countryCode != null && countryCode != currentState.countryCode) {
      final newSettings = _persistedSettings.copyWith(countryCode: countryCode);
      await _settingsProvider.persistSettings(newSettings);
      await _retrivePersistedSettings();
    }
  }

  /// Retrieve the settings from the data provider.
  Future<FastAppSettingsDocument> _retrivePersistedSettings() async {
    await _settingsProvider.connect();

    return (_persistedSettings = await _settingsProvider.retrieveSettings());
  }
}
