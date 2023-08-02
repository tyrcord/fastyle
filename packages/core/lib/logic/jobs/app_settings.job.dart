// ignore_for_file: use_build_context_synchronously

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

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

    return applySettings(context, settingsState);
  }

  /// Initializes the [FastAppSettingsBloc] by retrieving the settings
  /// from the [FastAppSettingsBloc] and returns the [FastAppSettingsBlocState].
  Future<FastAppSettingsBlocState> initializeSettingsBloc(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    final appInfoBloc = BlocProvider.of<FastAppInfoBloc>(context);
    final settingsBloc = BlocProvider.of<FastAppSettingsBloc>(context);
    final appInfoState = appInfoBloc.currentState;
    final deviceLanguageCode = appInfoState.deviceLanguageCode;
    final deviceCountryCode = appInfoState.deviceCountryCode;
    final isFirstLaunch = appInfoBloc.currentState.isFirstLaunch;
    final supportedLocales = appInfoBloc.currentState.supportedLocales;
    late final String languageCode;

    await notifiyErrorReporterIfNeeded(
      deviceLanguageCode,
      deviceCountryCode,
      errorReporter: errorReporter,
    );

    // We initialize the settings bloc with the device country code.
    settingsBloc.addEvent(FastAppSettingsBlocEvent.init(deviceCountryCode));

    final settingsState = await RaceStream([
      settingsBloc.onError,
      settingsBloc.onData.where((state) => state.isInitialized),
    ]).first;

    if (settingsState is! FastAppSettingsBlocState) {
      throw settingsState;
    }

    // Once the settings bloc is initialized, we determine the language code
    // that will be used to initialize the language of the application.

    if (isFirstLaunch) {
      // If it is the first launch of the application, we use the device locale
      // to initialize the language of the application.
      languageCode = await determineUserLanguageCode(
        deviceLanguageCode,
        supportedLocales,
      );
    } else {
      // If it is not the first launch of the application, we use the saved
      // language code to initialize the language of the application.
      languageCode = settingsBloc.currentState.languageCode;
    }

    // We update the language code of the application if needed.
    if (languageCode != settingsBloc.currentState.languageCode) {
      settingsBloc.addEvent(
        FastAppSettingsBlocEvent.languageCodeChanged(languageCode),
      );

      await settingsBloc.onData
          .where((state) => state.languageCode == languageCode)
          .first;
    }

    return settingsState;
  }

  /// Applies the settings to the application.
  /// It is used to update the theme of the application.
  Future<void> applySettings(
    BuildContext context,
    FastAppSettingsBlocState settingsState,
  ) async {
    await context.setLocale(settingsState.locale);

    return updateThemeMode(context, settingsState);
  }

  /// Updates the theme mode of the application.
  Future<void> updateThemeMode(
    BuildContext context,
    FastAppSettingsBlocState settingsState,
  ) async {
    final themeBloc = BlocProvider.of<FastThemeBloc>(context);

    dispatchThemeModeChanged(themeBloc, settingsState.themeMode);

    final themeState = await RaceStream([
      themeBloc.onError,
      themeBloc.onData
          .where((state) => state.themeMode == settingsState.themeMode),
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

  Future<String> determineUserLanguageCode(
    String languageCode,
    Iterable<Locale> supportedLocales,
  ) async {
    final isSupported = isLanguageCodeSupported(languageCode, supportedLocales);

    if (isSupported) {
      return languageCode;
    }

    return kFastSettingsDefaultLanguageCode;
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
