// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

class FastFavoriteIconButton extends FastActionButton with FastButtonMixin2 {
  /// Whether the item is a favorite.
  final bool isFavorite;

  const FastFavoriteIconButton({
    super.key,
    required this.isFavorite,
    super.trottleTimeDuration = kFastButtonTrottleTimeDuration,
    super.emphasis = FastButtonEmphasis.low,
    super.iconAlignment = Alignment.center,
    super.shouldTrottleTime = true,
    super.isEnabled = true,
    super.highlightColor,
    super.disabledColor,
    super.semanticLabel,
    super.constraints,
    super.focusColor,
    super.hoverColor,
    super.debugLabel,
    super.iconColor,
    super.flexible,
    super.iconSize,
    super.tooltip,
    super.padding,
    super.onTap,
    super.icon,
  });

  @override
  Future<void> handleTap(BuildContext context) async {
    onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return FastIconButton2(
      highlightColor: _getHighlightColor(context),
      trottleTimeDuration: trottleTimeDuration,
      shouldTrottleTime: shouldTrottleTime,
      hoverColor: _getHoverColor(context),
      onTap: () => handleTap(context),
      disabledColor: disabledColor,
      iconAlignment: iconAlignment,
      icon: buildIcon(context),
      constraints: constraints,
      debugLabel: debugLabel,
      focusColor: focusColor,
      iconColor: iconColor,
      isEnabled: isEnabled,
      emphasis: emphasis,
      iconSize: iconSize,
      padding: padding,
    );
  }

  @override
  Widget buildIcon(BuildContext context) {
    late Widget icon;

    if (isFavorite) {
      icon = _getFilledHeartIcon(context);
    } else {
      icon = _getHollowHeartIcon(context);
    }

    return icon;
  }

  Color? _getHoverColor(BuildContext context) {
    return hoverColor ??
        getEmphasisedColor(context, emphasis: emphasis)
            ?.withAlpha(kFastButtonHoverAlpha);
  }

  Color? _getHighlightColor(BuildContext context) {
    return highlightColor ??
        getEmphasisedColor(context, emphasis: emphasis)
            ?.withAlpha(kFastButtonHighlightAlpha);
  }

  /// Returns a widget that displays a hollow heart icon.
  Widget _getHollowHeartIcon(BuildContext context) {
    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightHeart);
    }

    return const FaIcon(FastFontAwesomeIcons.heart);
  }

  /// Returns a widget that displays a filled heart icon.
  Widget _getFilledHeartIcon(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);

    return FaIcon(FontAwesomeIcons.solidHeart, color: palette.red.mid);
  }
}
