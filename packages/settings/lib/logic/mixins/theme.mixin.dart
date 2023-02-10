import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';

/// A mixin that provides a method to dispatch a theme mode change event.
mixin FastSettingsThemeMixin {
  /// Dispatches a theme mode change event.
  /// It is used to update the theme of the application.
  void dispatchThemeModeChanged(FastThemeBloc themeBloc, ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        themeBloc.addEvent(FastThemeBlocEvent.light());
        break;
      case ThemeMode.dark:
        themeBloc.addEvent(FastThemeBlocEvent.dark());
        break;
      default:
        themeBloc.addEvent(FastThemeBlocEvent.system());
    }
  }
}
