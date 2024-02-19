// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// Manages the theme related logic and state for the application.
class FastThemeBloc
    extends BidirectionalBloc<FastThemeBlocEvent, FastThemeBlocState> {
  /// Keeps track if a singleton instance has been created.
  static bool get hasBeenInstantiated => _hasBeenInstantiated;
  static bool _hasBeenInstantiated = false;

  static final _logger = TLoggerManager.instance.getLogger(debugLabel);
  static const debugLabel = 'FastAppOnboardingBloc';

  /// Singleton instance of the `FastThemeBloc`.
  static late FastThemeBloc _instance;

  static FastThemeBloc get instance {
    if (!_hasBeenInstantiated) return FastThemeBloc();

    return _instance;
  }

  // Method to reset the singleton instance
  static void reset() => _instance.resetBloc();

  /// Factory constructor to ensure that only a single instance of
  /// `FastThemeBloc` is used throughout the application.
  factory FastThemeBloc({FastThemeBlocState? initialState}) {
    if (!hasBeenInstantiated) {
      _instance = FastThemeBloc._(initialState: initialState);
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  /// Private constructor with optional initial state.
  ///
  /// If [initialState] is provided, it must have a non-null `brightness` value.
  FastThemeBloc._({FastThemeBlocState? initialState})
      : assert((initialState != null && initialState.brightness != null) ||
            initialState == null),
        super(initialState: initialState ?? FastThemeBlocState());

  /// Indicates if the Bloc can be closed.
  @override
  bool canClose() => false;

  /// Maps incoming events to output states.
  @override
  Stream<FastThemeBlocState> mapEventToState(FastThemeBlocEvent event) async* {
    final payload = event.payload;
    final type = event.type;

    _logger.debug('Event received: $type');

    if (type == FastThemeBlocEventType.init) {
      yield* handleInitEvent(payload);
    } else if (type == FastThemeBlocEventType.initialized) {
      yield* handleInitializedEvent();
    } else if (isInitialized) {
      yield* handleThemeChangeEvent(type);
    }
  }

  /// Handles the initialization event with an optional mode.
  Stream<FastThemeBlocState> handleInitEvent(ThemeMode? mode) async* {
    if (canInitialize) {
      _logger.debug('Initializing...');
      isInitializing = true;
      yield currentState.copyWith(isInitializing: true);

      WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
          onPlatformBrightnessChanged;

      if (mode == ThemeMode.light) {
        yield* handleLightEvent();
      } else if (mode == ThemeMode.dark) {
        yield* handleDarkEvent();
      } else {
        yield* handleSystemEvent();
      }

      addEvent(const FastThemeBlocEvent.initialized());
    }
  }

  /// Handles the event after initialization is done.
  Stream<FastThemeBlocState> handleInitializedEvent() async* {
    if (isInitializing) {
      _logger.debug('Initialized');

      isInitialized = true;
      yield currentState.copyWith(isInitialized: true);
    }
  }

  /// Handles the theme change events.
  Stream<FastThemeBlocState> handleThemeChangeEvent(
    FastThemeBlocEventType? type,
  ) async* {
    switch (type) {
      case FastThemeBlocEventType.light:
        yield* handleLightEvent();
      case FastThemeBlocEventType.dark:
        yield* handleDarkEvent();
      case FastThemeBlocEventType.system:
        yield* handleSystemEvent();
      default:
        break;
    }
  }

  /// Handles the event to set the light theme.
  Stream<FastThemeBlocState> handleLightEvent() async* {
    yield currentState.copyWith(
      brightness: Brightness.light,
      themeMode: ThemeMode.light,
    );
  }

  /// Handles the event to set the dark theme.
  Stream<FastThemeBlocState> handleDarkEvent() async* {
    yield currentState.copyWith(
      brightness: Brightness.dark,
      themeMode: ThemeMode.dark,
    );
  }

  /// Handles the event to set the system theme.
  Stream<FastThemeBlocState> handleSystemEvent() async* {
    yield currentState.copyWith(
      brightness: getPlatformBrightness(),
      themeMode: ThemeMode.system,
    );
  }

  /// Callback for platform brightness change events.
  @protected
  void onPlatformBrightnessChanged() {
    final newBrightness = getPlatformBrightness();
    final brightness = currentState.brightness;
    final themeMode = currentState.themeMode;

    if (themeMode == ThemeMode.system && newBrightness != brightness) {
      addEvent(const FastThemeBlocEvent.system());
    }
  }
}
