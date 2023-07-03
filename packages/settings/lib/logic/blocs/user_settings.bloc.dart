import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:flutter/material.dart';
import 'package:tbloc/tbloc.dart';

/// A BLoC (Business Logic Component) class for managing user settings.
class FastUserSettingsBloc extends BidirectionalBloc<FastUserSettingsBlocEvent,
    FastUserSettingsBlocState> {
  final FastUserSettingsDataProvider _settingsProvider;
  late FastUserSettingsDocument _persistedSettings;
  static FastUserSettingsBloc? _singleton;

  /// Creates a [FastUserSettingsBloc] instance.
  ///
  /// The [initialState] parameter is optional and defaults to
  /// [FastUserSettingsBlocState()].

  FastUserSettingsBloc._({FastUserSettingsBlocState? initialState})
      : _settingsProvider = FastUserSettingsDataProvider(),
        super(initialState: initialState ?? const FastUserSettingsBlocState());

  factory FastUserSettingsBloc({FastUserSettingsBlocState? initialState}) {
    _singleton ??= FastUserSettingsBloc._(initialState: initialState);

    return _singleton!;
  }

  @override
  @mustCallSuper
  void close() {
    if (!closed && canClose()) {
      super.close();
      _settingsProvider.disconnect();
    }
  }

  @override
  Stream<FastUserSettingsBlocState> mapEventToState(
    FastUserSettingsBlocEvent event,
  ) async* {
    final payload = event.payload;
    final type = event.type;

    if (type == FastUserSettingsBlocEventType.init) {
      yield* handleInitEvent();
    } else if (type == FastUserSettingsBlocEventType.initialized) {
      yield* handleInitializedEvent(payload);
    } else if (isInitialized) {
      switch (type) {
        case FastUserSettingsBlocEventType.primaryCurrencyCodeChanged:
          yield* handlePrimaryCurrencyCodeChangedEvent(payload);
          break;
        case FastUserSettingsBlocEventType.secondaryCurrencyCodeChanged:
          yield* handleSecondaryCurrencyCodeChangedEvent(payload);
          break;
        case FastUserSettingsBlocEventType.saveEntryChanged:
          yield* handleSaveEntryChangedEvent(payload);
          break;
        default:
          break;
      }
    } else {
      assert(false, 'FastUserSettingsBloc is not initialized yet.');
    }
  }

  /// Handles the `init` event by initializing the bloc.
  ///
  /// If the bloc can be initialized, it retrieves the persisted settings and
  /// emits an `initialized` event with the retrieved settings.
  Stream<FastUserSettingsBlocState> handleInitEvent() async* {
    if (canInitialize) {
      isInitializing = true;
      yield const FastUserSettingsBlocState(isInitializing: true);

      final settings = await _retrievePersistedSettings();

      addEvent(FastUserSettingsBlocEvent.initialized(
        primaryCurrencyCode: settings.primaryCurrencyCode,
        secondaryCurrencyCode: settings.secondaryCurrencyCode,
        saveEntry: settings.saveEntry,
      ));
    }
  }

  /// Handles the `initialized` event by marking the bloc as initialized.
  ///
  /// The [payload] parameter contains the initial settings to be applied.
  Stream<FastUserSettingsBlocState> handleInitializedEvent(
    FastUserSettingsBlocEventPayload? payload,
  ) async* {
    if (isInitializing) {
      isInitialized = true;

      yield FastUserSettingsBlocState(
        primaryCurrencyCode: payload?.primaryCurrencyCode,
        secondaryCurrencyCode: payload?.secondaryCurrencyCode,
        saveEntry: payload?.saveEntry ?? kFastUserSettingSaveEntry,
        isInitializing: false,
        isInitialized: true,
      );
    }
  }

  /// Handles the `primaryCurrencyCodeChanged` event by persisting the new
  /// primary currency code and updating the state.
  ///
  /// The [payload] parameter contains the new primary currency code.
  Stream<FastUserSettingsBlocState> handlePrimaryCurrencyCodeChangedEvent(
    FastUserSettingsBlocEventPayload? payload,
  ) async* {
    if (payload?.primaryCurrencyCode != null) {
      final primaryCurrencyCode = payload?.primaryCurrencyCode;
      await _persistPrimaryCurrencyCode(primaryCurrencyCode);

      yield currentState.copyWith(
        primaryCurrencyCode: _persistedSettings.primaryCurrencyCode,
      );
    }
  }

  /// Handles the `secondaryCurrencyCodeChanged` event by persisting the new
  /// secondary currency code and updating the state.
  ///
  /// The [payload] parameter contains the new secondary currency code.
  Stream<FastUserSettingsBlocState> handleSecondaryCurrencyCodeChangedEvent(
    FastUserSettingsBlocEventPayload? payload,
  ) async* {
    if (payload?.secondaryCurrencyCode != null) {
      final secondaryCurrencyCode = payload?.secondaryCurrencyCode;
      await _persistSecondaryCurrencyCode(secondaryCurrencyCode);

      yield currentState.copyWith(
        secondaryCurrencyCode: _persistedSettings.secondaryCurrencyCode,
      );
    }
  }

  /// Handles the `saveEntryChanged` event by persisting the new save entry value
  /// and updating the state.
  ///
  /// The [payload] parameter contains the new save entry value.
  Stream<FastUserSettingsBlocState> handleSaveEntryChangedEvent(
    FastUserSettingsBlocEventPayload? payload,
  ) async* {
    if (payload?.saveEntry != null) {
      final saveEntry = payload?.saveEntry;
      await _persistSaveEntry(saveEntry);

      yield currentState.copyWith(saveEntry: _persistedSettings.saveEntry);
    }
  }

  /// Persists the new primary currency code.
  ///
  /// The [primaryCurrencyCode] parameter represents the new primary currency
  /// code to be persisted.
  Future<FastUserSettingsDocument> _persistPrimaryCurrencyCode(
    String? primaryCurrencyCode,
  ) async {
    if (primaryCurrencyCode != null &&
        primaryCurrencyCode != currentState.primaryCurrencyCode) {
      final newSettings = _persistedSettings.copyWith(
        primaryCurrencyCode: primaryCurrencyCode,
      );

      await _settingsProvider.persistUserSettings(newSettings);
    }

    return _retrievePersistedSettings();
  }

  /// Persists the new secondary currency code.
  ///
  /// The [secondaryCurrencyCode] parameter represents the new secondary currency
  /// code to be persisted.
  Future<FastUserSettingsDocument> _persistSecondaryCurrencyCode(
    String? secondaryCurrencyCode,
  ) async {
    if (secondaryCurrencyCode != null &&
        secondaryCurrencyCode != currentState.secondaryCurrencyCode) {
      final newSettings = _persistedSettings.copyWith(
        secondaryCurrencyCode: secondaryCurrencyCode,
      );

      await _settingsProvider.persistUserSettings(newSettings);
    }

    return _retrievePersistedSettings();
  }

  /// Persists the new save entry value.
  ///
  /// The [saveEntry] parameter represents the new save entry value to be
  /// persisted.
  Future<FastUserSettingsDocument> _persistSaveEntry(bool? saveEntry) async {
    if (saveEntry != null && saveEntry != currentState.saveEntry) {
      final newSettings = _persistedSettings.copyWith(saveEntry: saveEntry);
      await _settingsProvider.persistUserSettings(newSettings);
    }

    return _retrievePersistedSettings();
  }

  /// Retrieves the persisted user settings.
  ///
  /// It connects to the settings provider, retrieves the persisted settings,
  /// and returns them.
  Future<FastUserSettingsDocument> _retrievePersistedSettings() async {
    await _settingsProvider.connect();
    _persistedSettings = await _settingsProvider.retrieveUserSettings();

    return _persistedSettings;
  }
}
