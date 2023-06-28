import 'dart:async';

import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:tbloc/tbloc.dart';
import 'package:flutter/material.dart';

/// The [FastSettingsThemeListener] class is a [StatefulWidget] that listens
/// to the [FastAppSettingsBloc] and updates the [FastThemeBloc] when the theme
/// mode changes.
class FastSettingsThemeListener extends StatefulWidget {
  /// The child widget.
  final Widget child;

  const FastSettingsThemeListener({
    super.key,
    required this.child,
  });

  @override
  State<FastSettingsThemeListener> createState() =>
      _FastSettingsThemeListenerState();
}

class _FastSettingsThemeListenerState extends State<FastSettingsThemeListener>
    with FastSettingsThemeMixin {
  late final StreamSubscription<FastAppSettingsBlocState> _subscription;
  late final FastAppSettingsBloc _settingsBloc;
  late final FastThemeBloc _themeBloc;

  @override
  void initState() {
    super.initState();

    _settingsBloc = BlocProvider.of<FastAppSettingsBloc>(context);
    _themeBloc = BlocProvider.of<FastThemeBloc>(context);

    _subscription = _settingsBloc.onData
        .skipWhile((state) => !state.isInitialized)
        .distinct((previous, next) => previous.theme == next.theme)
        .listen((state) => handleThemeModeChanged(state.themeMode));
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  /// Updates the theme mode of the application.
  void handleThemeModeChanged(ThemeMode themeMode) {
    dispatchThemeModeChanged(_themeBloc, themeMode);
  }
}
