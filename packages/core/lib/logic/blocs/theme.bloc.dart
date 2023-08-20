// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastThemeBloc
    extends BidirectionalBloc<FastThemeBlocEvent, FastThemeBlocState> {
  static bool _hasBeenInstantiated = false;
  static late FastThemeBloc instance;

  factory FastThemeBloc({FastThemeBlocState? initialState}) {
    if (!_hasBeenInstantiated) {
      instance = FastThemeBloc._(initialState: initialState);
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  @override
  bool canClose() => false;

  FastThemeBloc._({FastThemeBlocState? initialState})
      : assert((initialState != null && initialState.brightness != null) ||
            initialState == null),
        super(initialState: initialState ?? FastThemeBlocState()) {
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        onPlatformBrightnessChanged;
  }

  @override
  Stream<FastThemeBlocState> mapEventToState(FastThemeBlocEvent event) async* {
    if (event.type == FastThemeBlocEventType.light) {
      yield FastThemeBlocState(
        brightness: Brightness.light,
        themeMode: ThemeMode.light,
      );
    } else if (event.type == FastThemeBlocEventType.dark) {
      yield FastThemeBlocState(
        brightness: Brightness.dark,
        themeMode: ThemeMode.dark,
      );
    } else {
      yield FastThemeBlocState(
        brightness:
            WidgetsBinding.instance.platformDispatcher.platformBrightness,
        themeMode: ThemeMode.system,
      );
    }
  }

  @protected
  void onPlatformBrightnessChanged() {
    final newBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final brightness = currentState.brightness;
    final themeMode = currentState.themeMode;

    if (themeMode == ThemeMode.system && newBrightness != brightness) {
      addEvent(const FastThemeBlocEvent.system());
    }
  }
}
