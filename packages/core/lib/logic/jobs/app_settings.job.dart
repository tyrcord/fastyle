// ignore_for_file: use_build_context_synchronously

import 'package:devicelocale/devicelocale.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:tbloc/tbloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// A [FastJob] that initializes the [FastAppSettingsBloc].
/// It is used to load the settings of the application
/// and initialize the [FastAppSettingsBloc] before the [FastAppSettingsBloc]
/// is used.
class FastAppSettingsJob extends FastJob with FastSettingsThemeMixin {
  static FastAppSettingsJob? _singleton;

  factory FastAppSettingsJob() {
    return (_singleton ??= FastAppSettingsJob._());
  }

  FastAppSettingsJob._() : super(debugLabel: 'fast_app_settings_job');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    final settingsState = await initializeSettingsBloc(
      context,
      errorReporter: errorReporter,
    );

    await applySettings(context, settingsState);
  }

  /// Initializes the [FastAppSettingsBloc] by retrieving the settings
  /// from the [FastAppSettingsBloc] and returns the [FastAppSettingsBlocState].
  Future<FastAppSettingsBlocState> initializeSettingsBloc(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    final settingsBloc = BlocProvider.of<FastAppSettingsBloc>(context);
    final savedUserLanguageCode = settingsBloc.currentState.languageCode;
    final supportedLocales = settingsBloc.currentState.supportedLocales;

    // Determine the user language and country code from the device locale.
    final (deviceLanguageCode, deviceCountryCode) = await getPreferredLocale();

    await notifiyErrorReporterIfNeeded(
      deviceLanguageCode,
      deviceCountryCode,
      errorReporter: errorReporter,
    );

    // Determine the user language code.

    final languageCode = await determineUserLanguageCode(
      deviceLanguageCode,
      supportedLocales,
    );

    settingsBloc.addEvent(const FastAppSettingsBlocEvent.init());

    final settingsState = await RaceStream([
      settingsBloc.onError,
      settingsBloc.onData.where((state) => state.isInitialized),
    ]).first;

    if (settingsState is! FastAppSettingsBlocState) {
      throw settingsState;
    }

    return settingsState;
  }

  /// Applies the settings to the application.
  /// It is used to update the theme of the application.
  Future<void> applySettings(
    BuildContext context,
    FastAppSettingsBlocState settingsState,
  ) async {
    return updateThemeMode(context, settingsState);
  }

  /// Updates the theme mode of the application.
  Future<void> updateThemeMode(
    BuildContext context,
    FastAppSettingsBlocState settingsState,
  ) async {
    final themeBloc = BlocProvider.of<FastThemeBloc>(context);

    dispatchThemeModeChanged(themeBloc, settingsState.themeMode);

    themeBloc.onData.where((themeState) {
      return themeState.themeMode == settingsState.themeMode;
    });

    final themeState = await RaceStream([
      themeBloc.onError,
      themeBloc.onData.where(
        (themeState) => themeState.themeMode == settingsState.themeMode,
      ),
    ]).first;

    if (themeState is! FastThemeBlocState) {
      throw themeState;
    }
  }

  Future<void> notifiyErrorReporterIfNeeded(
    String languageCode,
    String? countryCode, {
    IFastErrorReporter? errorReporter,
  }) async {
    await errorReporter?.setCustomKey(
      'deviceCountryCode',
      countryCode ?? 'unknown',
    );

    await errorReporter?.setCustomKey(
      'deviceLanguageCode',
      languageCode,
    );
  }

  determineUserLanguageCode(
    String languageCode,
    Iterable<Locale> supportedLocales,
  ) async {
    final isSupported = isLanguageCodeSupported(languageCode, supportedLocales);

    if (isSupported) {
      return languageCode;
    }

    return kFastSettingsDefaultLanguageCode;
  }

  Future<(String, String?)> getPreferredLocale() async {
    final deviceIntlLocale = await getDevicelocale();

    return (deviceIntlLocale.languageCode, deviceIntlLocale.countryCode);
  }

  Future<Locale> getDevicelocale() async {
    final localeIdentifiers = await Devicelocale.preferredLanguagesAsLocales;

    return localeIdentifiers.first;
  }

  bool isLanguageCodeSupported(
    String languageCode,
    Iterable<Locale> supportedLocales,
  ) {
    final supportedLanguageCodes = supportedLocales.map(
      (locale) => locale.languageCode,
    );

    return supportedLanguageCodes.contains(languageCode);
  }
}
