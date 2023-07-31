// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class ThemeColorHelper {
  Color getColorWithBestConstrast({
    required BuildContext context,
    required Color darkColor,
    required Color lightColor,
    Color? backgroundColor,
  }) {
    final theme = Theme.of(context);
    final primaryColor = backgroundColor ?? theme.primaryColor;

    return primaryColor.computeLuminance() > 0.5 ? darkColor : lightColor;
  }

  Color getShadowColor(BuildContext context) {
    final themeBloc = BlocProvider.of<FastThemeBloc>(context);

    return themeBloc.currentState.brightness == Brightness.light
        ? kFastLightShadowColor
        : kFastDarkShadowColor;
  }

  Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).primaryColor;
  }

  Color getSecondaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.secondary;
  }

  Color getTertiaryColor(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall!.color!;
  }

  Color getHintColor(BuildContext context) {
    return Theme.of(context).hintColor;
  }

  Color getPrimaryBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  Color getSecondaryBackgroundColor(BuildContext context) {
    final themeBloc = BlocProvider.of<FastThemeBloc>(context);

    return themeBloc.currentState.brightness == Brightness.light
        ? kFastLightSecondaryBackgroundColor
        : kFastDarkSecondaryBackgroundColor;
  }

  Color getTertiaryBackgroundColor(BuildContext context) {
    final themeBloc = BlocProvider.of<FastThemeBloc>(context);

    return themeBloc.currentState.brightness == Brightness.light
        ? kFastLightTertiaryBackgroundColor
        : kFastDarkTertiaryBackgroundColor;
  }

  Color getSurfaceTintColor(BuildContext context) {
    final themeBloc = BlocProvider.of<FastThemeBloc>(context);
    final brightness = themeBloc.currentState.brightness;
    final palette = ThemeHelper.getPaletteColors(context);
    final isBrightnessLight = brightness == Brightness.light;
    final grayPalette = palette.gray;
    const opacity = 0.5;

    return isBrightnessLight
        ? grayPalette.lighter.withOpacity(opacity)
        : grayPalette.darker.withOpacity(opacity);
  }

  SystemUiOverlayStyle getOverlayStyleForColor({
    required BuildContext context,
    required Color color,
  }) {
    return color.computeLuminance() > 0.5
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light;
  }

  Color getDisabledColor(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);
    final themeBloc = BlocProvider.of<FastThemeBloc>(context);
    final brightness = themeBloc.currentState.brightness;
    final isBrightnessLight = brightness == Brightness.light;

    return isBrightnessLight ? palette.gray.ultraLight : palette.gray.darkest;
  }
}
