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

  FastAppSettingsJob._() : super(debugLabel: 'app_settings_job');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    final settingsState = await initializeSettingsBloc(context);

    await applySettings(context, settingsState);
  }

  /// Initializes the [FastAppSettingsBloc] by retrieving the settings
  /// from the [FastAppSettingsBloc] and returns the [FastAppSettingsBlocState].
  Future<FastAppSettingsBlocState> initializeSettingsBloc(
    BuildContext context,
  ) async {
    final settingsBloc = BlocProvider.of<FastAppSettingsBloc>(context);
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
}
