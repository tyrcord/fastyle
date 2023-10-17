// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// The [FastAppSettingsThemeListener] class is a [StatefulWidget] that listens
/// to the [FastAppSettingsBloc] and updates the [FastThemeBloc] when the theme
/// mode changes.
class FastAppSettingsThemeListener extends StatefulWidget {
  /// The child widget.
  final Widget child;

  const FastAppSettingsThemeListener({
    super.key,
    required this.child,
  });

  @override
  State<FastAppSettingsThemeListener> createState() =>
      _FastAppSettingsThemeListenerState();
}

class _FastAppSettingsThemeListenerState
    extends State<FastAppSettingsThemeListener> with FastSettingsThemeMixin {
  late final StreamSubscription<FastAppSettingsBlocState> _subscription;
  late final FastAppSettingsBloc _settingsBloc;
  late final FastThemeBloc _themeBloc;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.scheduleFrameCallback((_) {
      _settingsBloc = FastAppSettingsBloc.instance;
      _themeBloc = FastThemeBloc.instance;

      // Listen to the onData stream of FastAppSettingsBloc.
      // Skip the initial states until the bloc is initialized.
      // Distinct states based on the theme to prevent unnecessary updates.
      // Call handleThemeModeChanged when a new theme mode is received.
      _subscription = _settingsBloc.onData
          .skipWhile((state) => !state.isInitialized)
          .distinct((previous, next) => previous.theme == next.theme)
          .listen((state) => handleThemeModeChanged(state.themeMode));
    });
  }

  @override
  void dispose() {
    super.dispose();
    // Cancel the stream subscription to avoid memory leaks.
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  /// Updates the theme mode of the application.
  void handleThemeModeChanged(ThemeMode themeMode) {
    dispatchThemeModeChanged(_themeBloc, themeMode);
  }
}
