// ignore_for_file: use_build_context_synchronously

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:rxdart/rxdart.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// A [FastJob] that initializes the [FastAppSettingsBloc].
/// It is used to load the settings of the application
/// and initialize the [FastAppSettingsBloc] before the [FastAppSettingsBloc]
/// is used.
class FastAppSettingsJob extends FastJob with FastSettingsThemeMixin {
  static FastAppSettingsJob? _singleton;

  factory FastAppSettingsJob() {
    return (_singleton ??= const FastAppSettingsJob._());
  }

  const FastAppSettingsJob._() : super(debugLabel: 'FastAppSettingsJobs');

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
    final appInfoBloc = FastAppInfoBloc.instance;
    final settingsBloc = FastAppSettingsBloc.instance;
    final appInfoState = appInfoBloc.currentState;
    final deviceLanguageCode = appInfoState.deviceLanguageCode;
    final deviceCountryCode = appInfoState.deviceCountryCode;
    final isFirstLaunch = appInfoBloc.currentState.isFirstLaunch;
    final supportedLocales = appInfoBloc.currentState.supportedLocales;
    late final String languageCode;
    final String? countryCode;

    await notifiyErrorReporterIfNeeded(
      deviceLanguageCode,
      deviceCountryCode,
      errorReporter: errorReporter,
    );

    // We initialize the settings bloc.
    settingsBloc.addEvent(const FastAppSettingsBlocEvent.init());

    var settingsState = await RaceStream([
      settingsBloc.onError,
      settingsBloc.onData.where((state) => state.isInitialized),
    ]).first;

    if (settingsState is! FastAppSettingsBlocState) {
      throw settingsState;
    }

    // Once the settings bloc is initialized, we determine the language code
    // that will be used to initialize the language of the application.

    if (isFirstLaunch) {
      debugLog('First launch of the application.', debugLabel: debugLabel);

      // If it is the first launch of the application, we use the device locale
      // to initialize the language of the application.
      languageCode = await determineUserLanguageCode(
        deviceLanguageCode,
        supportedLocales,
      );

      countryCode = deviceCountryCode;
    } else {
      // If it is not the first launch of the application, we use the saved
      // language code to initialize the language of the application.
      languageCode = settingsBloc.currentState.languageCode;
      countryCode = settingsBloc.currentState.countryCode;
    }

    debugLog('Language code', value: languageCode, debugLabel: debugLabel);

    // We update the language code of the application if needed.
    if (languageCode != settingsBloc.currentState.languageCode) {
      debugLog('Updating language code', debugLabel: debugLabel);

      settingsBloc.addEvent(
        FastAppSettingsBlocEvent.languageCodeChanged(languageCode),
      );

      settingsState = await settingsBloc.onData
          .where((state) => state.languageCode == languageCode)
          .first;
    }

    if (countryCode != null) {
      debugLog('Country code', value: countryCode, debugLabel: debugLabel);

      // We update the country code of the application if needed.
      if (countryCode != settingsBloc.currentState.countryCode) {
        debugLog('Updating country code', debugLabel: debugLabel);

        settingsBloc.addEvent(
          FastAppSettingsBlocEvent.countryCodeChanged(countryCode),
        );

        settingsState = await settingsBloc.onData
            .where((state) => state.countryCode == countryCode)
            .first;
      }
    }

    final use24HourFormat = await shouldUse24HourFormat(context);

    settingsBloc.addEvent(
      FastAppSettingsBlocEvent.use24HourFormatChanged(use24HourFormat),
    );

    settingsState = await settingsBloc.onData
        .where((state) => state.use24HourFormat == use24HourFormat)
        .first;

    return settingsState;
  }

  Future<bool> shouldUse24HourFormat(BuildContext context) async {
    final completer = Completer<bool>();

    try {
      SchedulerBinding.instance.scheduleFrameCallback((_) {
        final use24HourFormat = MediaQuery.alwaysUse24HourFormatOf(context);

        debugLog(
          'Always use 24 hour format',
          value: use24HourFormat,
          debugLabel: debugLabel,
        );

        completer.complete(use24HourFormat);
      });
    } catch (e) {
      completer.complete(true);
    }

    return completer.future;
  }

  /// Applies the settings to the application.
  /// It is used to update the theme of the application.
  Future<void> applySettings(
    BuildContext context,
    FastAppSettingsBlocState settingsState,
  ) async {
    debugLog('Applying settings', debugLabel: debugLabel);

    await context.setLocale(settingsState.languageLocale);

    return updateThemeMode(context, settingsState);
  }

  /// Updates the theme mode of the application.
  Future<void> updateThemeMode(
    BuildContext context,
    FastAppSettingsBlocState settingsState,
  ) async {
    final themeBloc = FastThemeBloc.instance;

    themeBloc.addEvent(FastThemeBlocEvent.init(settingsState.themeMode));

    final themeState = await RaceStream([
      themeBloc.onError,
      themeBloc.onData.where(
        (state) {
          return state.themeMode == settingsState.themeMode &&
              state.isInitialized;
        },
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
