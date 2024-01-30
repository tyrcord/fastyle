// ignore_for_file: use_build_context_synchronously

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// A [FastJob] that initializes the [FastAppSettingsBloc].
/// It is used to load the settings of the application
/// and initialize the [FastAppSettingsBloc] before the [FastAppSettingsBloc]
/// is used.
class FastAppSettingsJob extends FastJob with FastSettingsThemeMixin {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static const _debugLabel = 'FastAppSettingsJobs';
  static final _manager = TLoggerManager();
  static FastAppSettingsJob? _singleton;

  factory FastAppSettingsJob() {
    return (_singleton ??= const FastAppSettingsJob._());
  }

  const FastAppSettingsJob._() : super(debugLabel: _debugLabel);

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    _logger.debug('Initializing...');
    final settingsState = await initializeSettingsBloc(
      context,
      errorReporter: errorReporter,
    );
    _logger
      ..debug('Initialized')

      // We apply the settings to the application.
      ..debug('Applying settings...');
    await applySettings(context, settingsState);
    _logger.debug('Settings applied');
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

    _logger
      ..info('Device language code', deviceLanguageCode)
      ..info('Device country code', deviceCountryCode)
      ..info('Is first launch', isFirstLaunch);

    // We initialize the settings bloc.
    settingsBloc.addEvent(const FastAppSettingsBlocEvent.init());

    var settingsState = await RaceStream([
      settingsBloc.onError,
      settingsBloc.onData.where((state) => state.isInitialized),
    ]).first;

    if (settingsState is! FastAppSettingsBlocState) {
      _logger.error('Failed to initialize: $settingsState');
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

      countryCode = deviceCountryCode;
    } else {
      // If it is not the first launch of the application, we use the saved
      // language code to initialize the language of the application.
      languageCode = settingsBloc.currentState.languageCode;
      countryCode = settingsBloc.currentState.countryCode;
    }

    _logger.info('User language code', languageCode);

    // We update the language code of the application if needed.
    if (languageCode != settingsBloc.currentState.languageCode) {
      _logger.debug('Updating User language code setting...');
      settingsBloc.addEvent(
        FastAppSettingsBlocEvent.languageCodeChanged(languageCode),
      );

      settingsState = await settingsBloc.onData
          .where((state) => state.languageCode == languageCode)
          .first;

      _logger.debug('User language code setting updated');
    }

    if (countryCode != null) {
      _logger.info('User country code', countryCode);

      // We update the country code of the application if needed.
      if (countryCode != settingsBloc.currentState.countryCode) {
        _logger.debug('Updating User country code setting...');

        settingsBloc.addEvent(
          FastAppSettingsBlocEvent.countryCodeChanged(countryCode),
        );

        settingsState = await settingsBloc.onData
            .where((state) => state.countryCode == countryCode)
            .first;

        _logger.debug('User country code setting updated');
      }
    }

    final use24HourFormat = await shouldUse24HourFormat(context);

    _logger
      ..info('Use 24 hour format', use24HourFormat)
      ..debug('Updating use 24 hour format setting...');

    // We update the use 24 hour format of the application if needed.
    settingsBloc.addEvent(
      FastAppSettingsBlocEvent.use24HourFormatChanged(use24HourFormat),
    );

    settingsState = await settingsBloc.onData
        .where((state) => state.use24HourFormat == use24HourFormat)
        .first;

    _logger.debug('Use 24 hour format setting updated');

    return settingsState;
  }

  Future<bool> shouldUse24HourFormat(BuildContext context) async {
    final completer = Completer<bool>();

    SchedulerBinding.instance.scheduleFrameCallback((_) {
      try {
        final use24HourFormat = MediaQuery.alwaysUse24HourFormatOf(context);

        completer.complete(use24HourFormat);
      } catch (e) {
        completer.complete(true);
      }
    });

    return completer.future;
  }

  /// Applies the settings to the application.
  /// It is used to update the theme of the application.
  Future<void> applySettings(
    BuildContext context,
    FastAppSettingsBlocState settingsState,
  ) async {
    // We update the locale of the application.
    _logger.debug('Setting Locale...');
    await context.setLocale(settingsState.languageLocale);
    _logger
      ..debug('Locale set')

      // We update the theme mode of the application.
      ..debug('Updating theme mode...');
    await updateThemeMode(context, settingsState);
    _logger.debug('Theme mode updated');
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
      _logger.error('Failed to update theme mode: $themeState');
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
      _logger.debug('User language code is supported');
      return languageCode;
    }

    _logger
      ..debug('User language code is not supported')
      ..debug('Using default language code');

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
