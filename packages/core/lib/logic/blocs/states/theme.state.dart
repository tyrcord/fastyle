// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

/// Represents the state for the `FastThemeBloc`.
///
/// It holds the information related to the current theme, including the
/// brightness and the chosen theme mode (light, dark, or system).
class FastThemeBlocState extends BlocState {
  /// The current brightness of the theme (light or dark).
  final Brightness? brightness;

  /// The current theme mode (light, dark, or system).
  final ThemeMode themeMode;

  /// Constructs a `FastThemeBlocState`.
  ///
  /// [isInitialized] and [isInitializing] are inherited from `BlocState` and
  /// represent the initialization status of the state.
  /// [themeMode] defaults to `ThemeMode.system` if not provided.
  /// [brightness] is optional and can be null.
  FastThemeBlocState({
    super.isInitialized,
    super.isInitializing,
    this.themeMode = ThemeMode.system,
    this.brightness,
  });

  /// Creates a copy of the current state with the given updated values.
  @override
  FastThemeBlocState copyWith({
    bool? isInitialized,
    bool? isInitializing,
    ThemeMode? themeMode,
    Brightness? brightness,
  }) {
    return FastThemeBlocState(
      isInitializing: isInitializing ?? this.isInitializing,
      isInitialized: isInitialized ?? this.isInitialized,
      brightness: brightness ?? this.brightness,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  /// Creates an exact clone of the current state.
  @override
  FastThemeBlocState clone() => copyWith();

  /// Merges the current state with the provided [model].
  ///
  /// Any non-null property of [model] replaces the corresponding property
  /// of the current state.
  @override
  FastThemeBlocState merge(covariant FastThemeBlocState model) {
    return copyWith(
      isInitializing: model.isInitializing,
      isInitialized: model.isInitialized,
      brightness: model.brightness,
      themeMode: model.themeMode,
    );
  }

  /// Provides a list of properties used for diffing and debugging.
  @override
  List<Object?> get props => [
        isInitializing,
        isInitialized,
        brightness,
        themeMode,
      ];
}
