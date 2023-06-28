// ignore_for_file: use_build_context_synchronously

import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:tbloc/tbloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// A [FastJob] that initializes the [FastUserSettingsBloc].
/// It is used to load the settings of the user and initialize
/// the [FastUserSettingsBloc] before the [FastUserSettingsBloc] is used.
class FastUserSettingsJob extends FastJob with FastSettingsThemeMixin {
  static FastUserSettingsJob? _singleton;

  factory FastUserSettingsJob() {
    return (_singleton ??= FastUserSettingsJob._());
  }

  FastUserSettingsJob._() : super(debugLabel: 'user_settings_job');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    await initializeSettingsBloc(context);
  }

  /// Initializes the [FastUserSettingsBloc] by retrieving the settings
  /// from the [FastUserSettingsBloc] and returns the
  /// [FastUserSettingsBlocState].
  Future<FastUserSettingsBlocState> initializeSettingsBloc(
    BuildContext context,
  ) async {
    final settingsBloc = BlocProvider.of<FastUserSettingsBloc>(context);
    settingsBloc.addEvent(const FastUserSettingsBlocEvent.init());

    final settingsState = await RaceStream([
      settingsBloc.onError,
      settingsBloc.onData.where((state) => state.isInitialized),
    ]).first;

    if (settingsState is! FastUserSettingsBlocState) {
      throw settingsState;
    }

    return settingsState;
  }
}
