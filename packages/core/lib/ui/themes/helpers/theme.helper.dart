// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class ThemeHelper {
  static final _spacingHelper = FastThemeSpacingHelper();
  static final _gradientHelper = ThemeGradientHelper();
  static final _colorHelper = ThemeColorHelper();
  static final _textHelper = ThemeTextHelper();

  static double dividerIndent = kFastDividerIndent;
  static double dividerSize = kFastDividerSize;
  static double borderSize = kFastBorderSize;

  static FastThemeSpacingHelper get spacing => _spacingHelper;
  static ThemeGradientHelper get gradients => _gradientHelper;
  static ThemeColorHelper get colors => _colorHelper;
  static ThemeTextHelper get texts => _textHelper;

  static FastPaletteColors getPaletteColors(BuildContext context) {
    final themeBloc = FastThemeBloc.instance;

    return themeBloc.currentState.brightness == Brightness.light
        ? kLightPaletteColors
        : kDarkPaletteColors;
  }

  // FIXME: should belong to the ThemeData Object
  // https://github.com/flutter/flutter/issues/31247
  static ListTileTheme getListTitleTheme({
    required BuildContext context,
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return ListTileTheme(
      iconColor: theme.iconTheme.color,
      textColor: ThemeHelper.texts.getBodyTextStyle(context).color,
      dense: true,
      child: child,
    );
  }

  static BoxShadow getDefaultBoxShadow(BuildContext context) {
    return BoxShadow(
      color: ThemeHelper.colors.getShadowColor(context),
      blurRadius: kFastBlurRadius,
    );
  }

  static BoxDecoration createBorderSide(BuildContext context, {Color? color}) {
    return BoxDecoration(
      border: Border(
        bottom: Divider.createBorderSide(
          context,
          color: color ?? Theme.of(context).dividerColor,
          width: kFastBorderSize,
        ),
      ),
    );
  }
}
