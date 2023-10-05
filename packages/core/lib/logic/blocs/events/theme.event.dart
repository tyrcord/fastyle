// Package imports:
import 'package:flutter/material.dart';
import 'package:tbloc/tbloc.dart';

/// Defines the types of events related to theme management.
enum FastThemeBlocEventType {
  initialized,
  system,
  light,
  dark,
  init,
}

/// Represents an event for the `FastThemeBloc`.
///
/// Each event type corresponds to a specific theme-related action
/// that can be dispatched to the `FastThemeBloc`.
class FastThemeBlocEvent extends BlocEvent<FastThemeBlocEventType, ThemeMode> {
  /// Creates a new theme event.
  ///
  /// [type] specifies the kind of theme action to be taken.
  /// [payload] contains additional data needed for the event (e.g. `ThemeMode`).
  const FastThemeBlocEvent({
    required FastThemeBlocEventType super.type,
    super.payload,
  });

  /// Represents the initialization event with a given [mode].
  const FastThemeBlocEvent.init(ThemeMode mode)
      : this(type: FastThemeBlocEventType.init, payload: mode);

  /// Represents an event indicating that the theme has been initialized.
  const FastThemeBlocEvent.initialized()
      : this(type: FastThemeBlocEventType.initialized);

  /// Represents an event to switch to the system's theme.
  const FastThemeBlocEvent.system() : this(type: FastThemeBlocEventType.system);

  /// Represents an event to switch to the light theme.
  const FastThemeBlocEvent.light() : this(type: FastThemeBlocEventType.light);

  /// Represents an event to switch to the dark theme.
  const FastThemeBlocEvent.dark() : this(type: FastThemeBlocEventType.dark);
}
