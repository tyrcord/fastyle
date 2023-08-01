// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

final _baseTextTheme = kBaseFastTheme.textTheme;
final _baseTabBarTheme = kBaseFastTheme.tabBarTheme;

final _defaultUnderlineInputBorder = UnderlineInputBorder(
  borderSide: BorderSide(
    color: kFastDarkSeparatorColor,
    width: kFastBorderSize,
  ),
);

final kDarkFastTheme = kBaseFastTheme.copyWith(
  scaffoldBackgroundColor: kFastDarkPrimaryBackgroundColor,
  dialogBackgroundColor: kFastDarkTertiaryBackgroundColor,
  hintColor: kFastDarkHintLabelColor,
  textTheme: _baseTextTheme.copyWith(
    headlineMedium: _baseTextTheme.headlineMedium!.copyWith(
      color: kFastDarkLabelColor,
    ),
    headlineSmall: _baseTextTheme.headlineSmall!.copyWith(
      color: kFastDarkLabelColor,
    ),
    displaySmall: _baseTextTheme.titleMedium!.copyWith(
      color: kFastDarkSecondaryLabelColor,
    ),
    titleLarge: _baseTextTheme.titleLarge!.copyWith(
      color: kFastDarkLabelColor,
    ),
    titleMedium: _baseTextTheme.titleMedium!.copyWith(
      color: kFastDarkSecondaryLabelColor,
    ),
    titleSmall: _baseTextTheme.titleMedium!.copyWith(
      color: kFastDarkTertiaryLabelColor,
    ),
    bodyLarge: _baseTextTheme.bodyLarge!.copyWith(
      color: kFastDarkLabelColor,
    ),
    bodyMedium: _baseTextTheme.bodyMedium!.copyWith(
      color: kFastDarkSecondaryLabelColor,
    ),
    labelLarge: _baseTextTheme.labelLarge!.copyWith(
      color: kFastDarkLabelColor,
    ),
    bodySmall: _baseTextTheme.bodySmall!.copyWith(
      color: kFastDarkSecondaryLabelColor,
    ),
    labelSmall: _baseTextTheme.labelSmall!.copyWith(
      color: kFastDarkSecondaryLabelColor,
    ),
  ),
  iconTheme: const IconThemeData(color: kFastDarkLabelColor),
  tabBarTheme: _baseTabBarTheme.copyWith(
    labelColor: kFastDarkLabelColor,
    unselectedLabelColor: kFastDarkSecondaryLabelColor,
  ),
  cardTheme: const CardTheme(
    color: kFastDarkSecondaryBackgroundColor,
  ),
  dividerColor: kFastDarkSeparatorColor,
  dividerTheme: DividerThemeData(
    color: kFastDarkSeparatorColor,
    thickness: kFastDividerSize,
    indent: kFastDividerIndent,
  ),
  inputDecorationTheme: kInputDecorationTheme.copyWith(
    hintStyle: TextStyle(color: kFastDarkHintLabelColor),
    enabledBorder: _defaultUnderlineInputBorder,
    disabledBorder: _defaultUnderlineInputBorder,
  ),
  popupMenuTheme: const PopupMenuThemeData(
    color: kFastDarkTertiaryBackgroundColor,
  ),
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      const interactiveStates = <MaterialState>{
        MaterialState.hovered,
        MaterialState.dragged,
      };

      if (states.any(interactiveStates.contains)) {
        return kFastDarkGrayPaletteColors.lighter;
      }

      return kFastDarkGrayPaletteColors.light;
    }),
  ),
  shadowColor: kFastDarkShadowColor,
  navigationBarTheme: kFastNavigationBarTheme.copyWith(
    surfaceTintColor: kFastDarkSecondaryBackgroundColor,
    iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((states) {
      if (states.contains(MaterialState.disabled)) {
        return IconThemeData(color: kFastDarkTertiaryLabelColor);
      } else if (states.contains(MaterialState.selected)) {
        return const IconThemeData(color: kFastDarkWhiteColor);
      }

      return IconThemeData(color: kFastDarkSecondaryLabelColor);
    }),
    labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
      (
        Set<MaterialState> states,
      ) {
        final base = GoogleFonts.barlowSemiCondensed(
          fontWeight: kFastFontWeightRegular,
          fontSize: kFastFontSize16,
          color: kFastLightLabelColor,
        );

        if (states.contains(MaterialState.disabled)) {
          return base.copyWith(color: kFastDarkTertiaryLabelColor);
        } else if (states.contains(MaterialState.selected)) {
          return base.copyWith(color: kFastDarkLabelColor);
        }

        return base.copyWith(color: kFastDarkSecondaryLabelColor);
      },
    ),
  ),
  navigationRailTheme: kFastNavigationRailTheme.copyWith(
    backgroundColor: kFastDarkSecondaryBackgroundColor,
    selectedIconTheme: const IconThemeData(color: kFastDarkLabelColor),
    unselectedIconTheme: IconThemeData(color: kFastDarkSecondaryLabelColor),
    selectedLabelTextStyle: GoogleFonts.barlowSemiCondensed(
      fontWeight: kFastFontWeightRegular,
      fontSize: kFastFontSize16,
      color: kFastDarkLabelColor,
    ),
    unselectedLabelTextStyle: GoogleFonts.barlowSemiCondensed(
      fontWeight: kFastFontWeightRegular,
      fontSize: kFastFontSize16,
      color: kFastDarkSecondaryLabelColor,
    ),
  ),
);
