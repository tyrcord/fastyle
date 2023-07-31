// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

//TODO: @need-review: code from fastyle_dart

class FastThemeBlocState extends BlocState {
  final Brightness? brightness;
  final ThemeMode themeMode;

  FastThemeBlocState({
    this.themeMode = ThemeMode.system,
    this.brightness,
  });

  @override
  FastThemeBlocState copyWith({ThemeMode? themeMode, Brightness? brightness}) {
    return FastThemeBlocState(
      brightness: brightness ?? this.brightness,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  FastThemeBlocState clone() => copyWith();

  @override
  FastThemeBlocState merge(covariant FastThemeBlocState model) {
    return copyWith(
      brightness: model.brightness,
      themeMode: model.themeMode,
    );
  }

  @override
  List<Object?> get props => [themeMode, brightness];
}
