// Flutter imports:

//TODO: @need-review: code from fastyle_dart

import 'package:flutter/material.dart';

class FastPaletteScheme {
  final Color ultraLight;
  final Color lightest;
  final Color lighter;
  final Color light;
  final Color mid;
  final Color dark;
  final Color darker;
  final Color darkest;
  final Color ultraDark;

  const FastPaletteScheme._internal({
    required this.ultraLight,
    required this.lightest,
    required this.lighter,
    required this.light,
    required this.mid,
    required this.dark,
    required this.darker,
    required this.darkest,
    required this.ultraDark,
  });

  factory FastPaletteScheme.fromColor(Color color) {
    final base = HSLColor.fromColor(color);

    return FastPaletteScheme._internal(
      ultraLight: base.withLightness(0.90).toColor(),
      lightest: base.withLightness(0.84).toColor(),
      lighter: base.withLightness(0.73).toColor(),
      light: base.withLightness(0.62).toColor(),
      mid: base.withLightness(0.51).toColor(),
      dark: base.withLightness(0.42).toColor(),
      darker: base.withLightness(0.33).toColor(),
      darkest: base.withLightness(0.24).toColor(),
      ultraDark: base.withLightness(0.1).toColor(),
    );
  }
}
