// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

//TODO: @need-review: code from fastyle_dart

const kFastFontSize64 = 64.0;
const kFastFontSize48 = 48.0;
const kFastFontSize40 = 40.0;
const kFastFontSize34 = 34.0;
const kFastFontSize28 = 28.0;
const kFastFontSize24 = 24.0;
const kFastFontSize20 = 20.0;
const kFastFontSize18 = 18.0;
const kFastFontSize16 = 16.0;
const kFastFontSize14 = 14.0;
const kFastFontSize12 = 12.0;
const kFastFontSize10 = 10.0;

const kFastFontWeightLight = FontWeight.w300;
const kFastFontWeightRegular = FontWeight.w400;
const kFastFontWeightMedium = FontWeight.w500;
const kFastFontWeightSemiBold = FontWeight.w600;
const kFastFontWeightBold = FontWeight.w700;

const _kFontFamilyFallback = <String>[
  'San Francisco',
  'Helvetica Neue',
  'Helvetica',
  'Roboto',
  'Arial',
];

final kFastTextTheme = TextTheme(
  headlineMedium: GoogleFonts.barlowSemiCondensed(
    fontWeight: kFastFontWeightRegular,
    fontSize: kFastFontSize48,
  ).copyWith(fontFamilyFallback: _kFontFamilyFallback),
  headlineSmall: GoogleFonts.barlowSemiCondensed(
    fontWeight: kFastFontWeightMedium,
    fontSize: kFastFontSize34,
  ).copyWith(fontFamilyFallback: _kFontFamilyFallback),
  displaySmall: GoogleFonts.barlowSemiCondensed(
    fontWeight: kFastFontWeightSemiBold,
    fontSize: kFastFontSize18,
  ).copyWith(fontFamilyFallback: _kFontFamilyFallback),
  titleLarge: GoogleFonts.barlowSemiCondensed(
    fontWeight: kFastFontWeightRegular,
    fontSize: kFastFontSize24,
  ).copyWith(fontFamilyFallback: _kFontFamilyFallback),
  titleMedium: GoogleFonts.barlowSemiCondensed(
    fontWeight: kFastFontWeightSemiBold,
    fontSize: kFastFontSize16,
  ).copyWith(fontFamilyFallback: _kFontFamilyFallback),
  titleSmall: GoogleFonts.barlowSemiCondensed(
    fontWeight: kFastFontWeightMedium,
    fontSize: kFastFontSize14,
  ).copyWith(fontFamilyFallback: _kFontFamilyFallback),
  bodyLarge: GoogleFonts.barlowSemiCondensed(
    fontWeight: kFastFontWeightRegular,
    fontSize: kFastFontSize18,
  ).copyWith(fontFamilyFallback: _kFontFamilyFallback),
  bodyMedium: GoogleFonts.barlowSemiCondensed(
    fontWeight: kFastFontWeightRegular,
    fontSize: kFastFontSize16,
  ).copyWith(fontFamilyFallback: _kFontFamilyFallback),
  labelLarge: GoogleFonts.barlowSemiCondensed(
    fontWeight: kFastFontWeightMedium,
    fontSize: kFastFontSize16,
  ).copyWith(fontFamilyFallback: _kFontFamilyFallback),
  bodySmall: GoogleFonts.barlowSemiCondensed(
    fontWeight: kFastFontWeightRegular,
    fontSize: kFastFontSize16,
  ).copyWith(fontFamilyFallback: _kFontFamilyFallback),
  labelSmall: GoogleFonts.barlowSemiCondensed(
    fontWeight: kFastFontWeightRegular,
    fontSize: kFastFontSize14,
  ).copyWith(fontFamilyFallback: _kFontFamilyFallback),
);
