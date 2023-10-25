import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';

Color? getColorBasedOnValue(BuildContext context, double? value) {
  final palette = ThemeHelper.getPaletteColors(context);

  if (value == null || value == 0) return null;

  // If value is positive, return green.
  if (value > 0) return palette.green.mid;

  // If value is negative, return red.
  return palette.red.mid;
}
