// ignore_for_file: use_build_context_synchronously

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
    final appInfoBloc = BlocProvider.of<FastAppInfoBloc>(context);
    final settingsBloc = BlocProvider.of<FastAppSettingsBloc>(context);
    final appInfoState = appInfoBloc.currentState;
    final deviceLanguageCode = appInfoState.deviceLanguageCode;
    final deviceCountryCode = appInfoState.deviceCountryCode;
    final isFirstLaunch = appInfoBloc.currentState.isFirstLaunch;
    final supportedLocales = settingsBloc.currentState.supportedLocales;
    late final String languageCode;

    await notifiyErrorReporterIfNeeded(
      deviceLanguageCode,
      deviceCountryCode,
      errorReporter: errorReporter,
    );

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

    settingsBloc.addEvent(FastAppSettingsBlocEvent.init(
      languageCode,
      deviceCountryCode,
    ));

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
