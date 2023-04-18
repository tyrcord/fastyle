// ignore_for_file: use_build_context_synchronously

import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:tbloc/tbloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// A [FastJob] that initializes the [FastSettingsBloc].
/// It is used to load the settings of the application
/// and initialize the [FastSettingsBloc] before the [FastSettingsBloc] is used.
class FastSettingsJob extends FastJob with FastSettingsThemeMixin {
  static FastSettingsJob? _singleton;

  factory FastSettingsJob() {
    return (_singleton ??= FastSettingsJob._());
  }

  FastSettingsJob._() : super(debugLabel: 'app_settings_job');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    final settingsState = await initializeSettingsBloc(context);

    await applySettings(context, settingsState);
  }

  /// Initializes the [FastSettingsBloc] by retrieving the settings
  /// from the [FastSettingsBloc] and returns the [FastSettingsBlocState].
  Future<FastSettingsBlocState> initializeSettingsBloc(
    BuildContext context,
  ) async {
    final settingsBloc = BlocProvider.of<FastSettingsBloc>(context);
    settingsBloc.addEvent(const FastSettingsBlocEvent.init());

    final settingsState = await RaceStream([
      settingsBloc.onError,
      settingsBloc.onData.where((state) => state.isInitialized),
    ]).first;

    if (settingsState is! FastSettingsBlocState) {
      throw settingsState;
    }

    return settingsState;
  }

  /// Applies the settings to the application.
  /// It is used to update the theme of the application.
  Future<void> applySettings(
    BuildContext context,
    FastSettingsBlocState settingsState,
  ) async {
    return updateThemeMode(context, settingsState);
  }

  /// Updates the theme mode of the application.
  Future<void> updateThemeMode(
    BuildContext context,
    FastSettingsBlocState settingsState,
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
}
