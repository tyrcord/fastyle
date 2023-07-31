// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

/// A mixin that provides a method to dispatch a theme mode change event.
mixin FastSettingsThemeMixin {
  /// Dispatches a theme mode change event.
  /// It is used to update the theme of the application.
  void dispatchThemeModeChanged(FastThemeBloc themeBloc, ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        themeBloc.addEvent(const FastThemeBlocEvent.light());
        break;
      case ThemeMode.dark:
        themeBloc.addEvent(const FastThemeBlocEvent.dark());
        break;
      default:
        themeBloc.addEvent(const FastThemeBlocEvent.system());
    }
  }
}
