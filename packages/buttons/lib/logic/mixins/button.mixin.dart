// Flutter imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';

mixin FastButtonMixin2 {
  double getIconSize(
    BuildContext context, {
    double? iconSize,
    Widget? icon,
  }) {
    if (iconSize != null) return iconSize;
    if ((icon is FaIcon) && icon.size != null) return icon.size!;
    if ((icon is Icon) && icon.size != null) return icon.size!;

    return kFastIconSizeSmall;
  }

  Color? getColor(
    BuildContext context, {
    FastButtonEmphasis? emphasis,
    bool isEnabled = true,
    Color? disabledColor,
    Color? color,
    Widget? icon,
  }) {
    if (!isEnabled) {
      return getDisabledColor(
        context,
        disabledColor: disabledColor,
        isEnabled: isEnabled,
        emphasis: emphasis,
        color: color,
        icon: icon,
      );
    }

    if (color != null) return color;

    if ((icon is FaIcon) && icon.color != null) return icon.color!;

    if ((icon is Icon) && icon.color != null) return icon.color!;

    return getEmphasisedColor(context, emphasis: emphasis);
  }

  Color? getDisabledColor(
    BuildContext context, {
    FastButtonEmphasis? emphasis,
    bool isEnabled = true,
    Color? disabledColor,
    Color? color,
    Widget? icon,
  }) {
    if (disabledColor != null) return disabledColor;
    if (color != null) return color.withAlpha(kDisabledAlpha);

    if ((icon is FaIcon) && icon.color != null) {
      return icon.color!.withAlpha(kDisabledAlpha);
    }

    if ((icon is Icon) && icon.color != null) {
      return icon.color!.withAlpha(kDisabledAlpha);
    }

    return getEmphasisedColor(context, emphasis: emphasis)
        ?.withAlpha(kDisabledAlpha);
  }

  Color? getEmphasisedColor(
    BuildContext context, {
    FastButtonEmphasis? emphasis,
  }) {
    if (emphasis == FastButtonEmphasis.high) {
      return ThemeHelper.colors.getPrimaryColor(context);
    }

    final palette = ThemeHelper.getPaletteColors(context);

    return palette.gray.mid;
  }

  Color? getHoverColor(
    BuildContext context, {
    FastButtonEmphasis? emphasis,
    Color? hoverColor,
    Color? color,
    Widget? icon,
  }) {
    if (hoverColor != null) return hoverColor;
    if (color != null) return color.withAlpha(kFastButtonHoverAlpha);

    if ((icon is FaIcon) && icon.color != null) {
      return icon.color!.withAlpha(kFastButtonHoverAlpha);
    }

    if ((icon is Icon) && icon.color != null) {
      return icon.color!.withAlpha(kFastButtonHoverAlpha);
    }

    return getEmphasisedColor(context, emphasis: emphasis)
        ?.withAlpha(kFastButtonHoverAlpha);
  }

  Color? getHighlightColor(
    BuildContext context, {
    FastButtonEmphasis? emphasis,
    Color? highlightColor,
    Color? color,
    Widget? icon,
  }) {
    if (highlightColor != null) return highlightColor;

    if (color != null) {
      return color.withAlpha(kFastButtonHighlightAlpha);
    }

    if ((icon is FaIcon) && icon.color != null) {
      return icon.color!.withAlpha(kFastButtonHighlightAlpha);
    }

    if ((icon is Icon) && icon.color != null) {
      return icon.color!.withAlpha(kFastButtonHighlightAlpha);
    }

    return getEmphasisedColor(context, emphasis: emphasis)
        ?.withAlpha(kFastButtonHighlightAlpha);
  }

  Widget buildIcon(
    BuildContext context,
    Widget icon, {
    FastButtonEmphasis? emphasis,
    bool isEnabled = true,
    Color? disabledColor,
    Color? iconColor,
    double? iconSize,
  }) {
    return IconTheme(
      data: IconThemeData(
        color: getColor(
          context,
          disabledColor: disabledColor,
          isEnabled: isEnabled,
          emphasis: emphasis,
          color: iconColor,
          icon: icon,
        ),
        size: getIconSize(
          context,
          iconSize: iconSize,
          icon: icon,
        ),
      ),
      child: icon,
    );
  }

  Widget buildButton(
    BuildContext context,
    Widget child, {
    FastButtonEmphasis emphasis = FastButtonEmphasis.low,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? padding,
    BoxDecoration? decoration,
    bool isEnabled = true,
    String? semanticLabel,
    Color? highlightColor,
    Alignment? alignment,
    VoidCallback? onTap,
    Color? focusColor,
    Color? hoverColor,
    String? tooltip,
    Color? color,
    Widget? icon,
  }) {
    Widget button = Container(
      alignment: alignment ?? Alignment.center,
      constraints: constraints,
      padding: padding,
      child: child,
    );

    if (decoration != null) {
      button = Ink(
        decoration: decoration,
        child: button,
      );
    }

    button = FastInkWell(
      highlightColor: getHighlightColor(
        context,
        highlightColor: highlightColor,
        emphasis: emphasis,
        color: color,
        icon: icon,
      ),
      hoverColor: getHoverColor(
        context,
        hoverColor: hoverColor,
        emphasis: emphasis,
        color: color,
        icon: icon,
      ),
      focusColor: focusColor,
      isEnabled: isEnabled,
      onTap: onTap,
      child: button,
    );

    button = Semantics(
      label: semanticLabel,
      enabled: isEnabled,
      button: true,
      child: button,
    );

    if (tooltip != null) {
      button = FastTooltip(
        message: tooltip,
        child: button,
      );
    }

    return button;
  }
}
