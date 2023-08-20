// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class ThemeTextHelper {
  Color getLabelColor(BuildContext context) {
    final themeBloc = FastThemeBloc.instance;

    return themeBloc.currentState.brightness == Brightness.light
        ? kFastLightLabelColor
        : kFastDarkLabelColor;
  }

  Color getSecondaryLabelColor(BuildContext context) {
    final themeBloc = FastThemeBloc.instance;

    return themeBloc.currentState.brightness == Brightness.light
        ? kFastLightSecondaryLabelColor
        : kFastDarkSecondaryLabelColor;
  }

  Color getTertiaryLabelColor(BuildContext context) {
    final themeBloc = FastThemeBloc.instance;

    return themeBloc.currentState.brightness == Brightness.light
        ? kFastLightTertiaryLabelColor
        : kFastDarkTertiaryLabelColor;
  }

  TextStyle getDisplayTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium!;
  }

  TextStyle getHeadlineTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!;
  }

  TextStyle getPlaceHolderHeadlineTextStyle(BuildContext context) {
    final theme = Theme.of(context);

    return theme.textTheme.headlineSmall!.copyWith(
      fontWeight: kFastFontWeightLight,
      color: theme.hintColor,
    );
  }

  TextStyle getSubheadTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.displaySmall!;
  }

  TextStyle getTitleTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!;
  }

  TextStyle getPlaceHolderTitleTextStyle(BuildContext context) {
    final theme = Theme.of(context);

    return theme.textTheme.titleLarge!.copyWith(
      fontWeight: kFastFontWeightLight,
      color: theme.hintColor,
    );
  }

  TextStyle getSubtitleTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!;
  }

  TextStyle getSecondarySubtitleTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall!;
  }

  TextStyle getBodyTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!;
  }

  TextStyle getSecondaryBodyTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!;
  }

  TextStyle getPlaceholderTextStyle(BuildContext context) {
    final theme = Theme.of(context);

    return theme.textTheme.bodyLarge!.copyWith(
      fontWeight: kFastFontWeightLight,
      color: theme.hintColor,
    );
  }

  TextStyle getButtonTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge!;
  }

  TextStyle getSecondaryButtonTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(
          color: getTertiaryLabelColor(context),
          fontSize: kFastFontSize14,
        );
  }

  TextStyle getCaptionTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!;
  }

  TextStyle getSecondaryCaptionTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
          color: getTertiaryLabelColor(context),
          fontWeight: kFastFontWeightMedium,
          fontSize: kFastFontSize12,
        );
  }

  TextStyle getOverlineTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall!;
  }

  TextStyle getSecondaryOverlineTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
          color: getTertiaryLabelColor(context),
          fontWeight: kFastFontWeightMedium,
          fontSize: kFastFontSize10,
        );
  }
}
