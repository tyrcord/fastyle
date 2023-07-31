// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastThemeFactory {
  static ThemeData buildLightThemeWithColors({
    required Color primaryColor,
    Color? secondaryColor,
    Color? tertiaryColor,
    Color? primaryColorDark,
  }) {
    return buildFastThemeWithColors(
      baseTheme: kLightFastTheme,
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      secondaryColor: secondaryColor,
      tertiaryColor: tertiaryColor,
    );
  }

  static ThemeData buildDarkThemeWithColors({
    required Color primaryColor,
    Color? secondaryColor,
    Color? tertiaryColor,
    Color? primaryColorDark,
  }) {
    return buildFastThemeWithColors(
      baseTheme: kDarkFastTheme,
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      secondaryColor: secondaryColor,
      tertiaryColor: tertiaryColor,
    );
  }

  static ThemeData buildFastThemeWithColors({
    required ThemeData baseTheme,
    required Color primaryColor,
    Color? secondaryColor,
    Color? tertiaryColor,
    Color? primaryColorDark,
  }) {
    final textTheme = baseTheme.textTheme;
    final secondaryColor0 = secondaryColor ?? baseTheme.colorScheme.secondary;
    final tertiaryColor0 = tertiaryColor ?? textTheme.labelSmall!.color;

    return baseTheme.copyWith(
      inputDecorationTheme: _buildInputDecorationTheme(baseTheme, primaryColor),
      primaryColorDark: primaryColorDark ?? baseTheme.primaryColorDark,
      buttonTheme: _buildButtonThemeData(primaryColor),
      primaryColor: primaryColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
      ),
      textTheme: textTheme.copyWith(
        bodySmall: textTheme.bodySmall!.copyWith(color: secondaryColor0),
        labelSmall: textTheme.labelSmall!.copyWith(color: tertiaryColor0),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: secondaryColor0,
      ),
    );
  }

  static ButtonThemeData _buildButtonThemeData(Color color) {
    return ButtonThemeData(
      disabledColor: color.withAlpha(kDisabledAlpha),
      buttonColor: color,
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(
    ThemeData themeData,
    Color color,
  ) {
    return themeData.inputDecorationTheme.copyWith(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: color, width: kFastBorderSize),
      ),
    );
  }
}
