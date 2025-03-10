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
    color: kFastLightSeparatorColor,
    width: kFastBorderSize,
  ),
);

final kLightFastTheme = kBaseFastTheme.copyWith(
  scaffoldBackgroundColor: kFastLightPrimaryBackgroundColor,
  dialogTheme: const DialogTheme(
    backgroundColor: kFastLightSecondaryBackgroundColor,
  ),
  // dialogBackgroundColor: kFastLightSecondaryBackgroundColor,
  hintColor: kFastLightHintLabelColor,
  textTheme: _baseTextTheme.copyWith(
    headlineMedium: _baseTextTheme.headlineMedium!.copyWith(
      color: kFastLightLabelColor,
    ),
    headlineSmall: _baseTextTheme.headlineSmall!.copyWith(
      color: kFastLightLabelColor,
    ),
    displaySmall: _baseTextTheme.titleMedium!.copyWith(
      color: kFastLightSecondaryLabelColor,
    ),
    titleLarge: _baseTextTheme.titleLarge!.copyWith(
      color: kFastLightLabelColor,
    ),
    titleMedium: _baseTextTheme.titleMedium!.copyWith(
      color: kFastLightSecondaryLabelColor,
    ),
    titleSmall: _baseTextTheme.titleSmall!.copyWith(
      color: kFastLightTertiaryLabelColor,
    ),
    bodyLarge: _baseTextTheme.bodyLarge!.copyWith(
      color: kFastLightSecondaryLabelColor,
    ),
    bodyMedium: _baseTextTheme.bodyMedium!.copyWith(
      color: kFastLightTertiaryLabelColor,
    ),
    labelLarge: _baseTextTheme.labelLarge!.copyWith(
      color: kFastLightLabelColor,
    ),
    bodySmall: _baseTextTheme.bodySmall!.copyWith(
      color: kFastLightSecondaryLabelColor,
    ),
    labelSmall: _baseTextTheme.labelSmall!.copyWith(
      color: kFastLightSecondaryLabelColor,
    ),
  ),
  cardTheme: const CardTheme(color: kFastLightSecondaryBackgroundColor),
  iconTheme: IconThemeData(color: kFastLightLabelColor),
  tabBarTheme: _baseTabBarTheme.copyWith(
    labelColor: kFastLightLabelColor,
    unselectedLabelColor: kFastLightSecondaryLabelColor,
  ),
  dividerColor: kFastLightSeparatorColor,
  dividerTheme: DividerThemeData(
    color: kFastLightSeparatorColor,
    thickness: kFastBorderSize,
    indent: kFastDividerIndent,
  ),
  inputDecorationTheme: kInputDecorationTheme.copyWith(
    hintStyle: TextStyle(color: kFastLightHintLabelColor),
    enabledBorder: _defaultUnderlineInputBorder,
    disabledBorder: _defaultUnderlineInputBorder,
  ),
  popupMenuTheme: const PopupMenuThemeData(
    color: kFastLightSecondaryBackgroundColor,
  ),
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      const interactiveStates = <WidgetState>{
        WidgetState.hovered,
        WidgetState.dragged,
      };

      if (states.any(interactiveStates.contains)) {
        return kFastLightGrayPaletteColors.mid;
      }

      return kFastLightGrayPaletteColors.light;
    }),
  ),
  shadowColor: kFastLightShadowColor,
  navigationBarTheme: kFastNavigationBarTheme.copyWith(
    surfaceTintColor: kFastLightWhiteColor,
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
      if (states.contains(WidgetState.disabled)) {
        return IconThemeData(color: kFastLightTertiaryLabelColor);
      } else if (states.contains(WidgetState.selected)) {
        return const IconThemeData(color: kFastLightWhiteColor);
      }

      return IconThemeData(color: kFastLightSecondaryLabelColor);
    }),
    labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
      Set<WidgetState> states,
    ) {
      final base = GoogleFonts.barlowSemiCondensed(
        fontWeight: kFastFontWeightRegular,
        fontSize: kFastFontSize16,
      );

      if (states.contains(WidgetState.disabled)) {
        return base.copyWith(color: kFastLightTertiaryLabelColor);
      } else if (states.contains(WidgetState.selected)) {
        return base.copyWith(color: kFastLightLabelColor);
      }

      return base.copyWith(color: kFastLightSecondaryLabelColor);
    }),
  ),
  navigationRailTheme: kFastNavigationRailTheme.copyWith(
    backgroundColor: kFastLightWhiteColor,
    selectedIconTheme: const IconThemeData(color: kFastLightWhiteColor),
    unselectedIconTheme: IconThemeData(color: kFastLightSecondaryLabelColor),
    selectedLabelTextStyle: GoogleFonts.barlowSemiCondensed(
      fontWeight: kFastFontWeightRegular,
      fontSize: kFastFontSize16,
      color: kFastLightLabelColor,
    ),
    unselectedLabelTextStyle: GoogleFonts.barlowSemiCondensed(
      fontWeight: kFastFontWeightRegular,
      fontSize: kFastFontSize16,
      color: kFastLightSecondaryLabelColor,
    ),
  ),
);
