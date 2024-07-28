// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

class FastFavoriteIconButton extends StatelessWidget {
  /// The duration for throttling button taps.
  final Duration trottleTimeDuration;

  /// Whether to throttle button taps.
  final bool shouldTrottleTime;

  /// The color when the button is highlighted.
  final Color? highlightColor;

  /// The color when the button is disabled.
  final Color? disabledColor;

  /// The color when the button is focused.
  final Color? focusColor;

  /// The color when the button is hovered.
  final Color? hoverColor;

  /// The size of the icon.
  final double? iconSize;

  /// The color of the icon.
  final Color? iconColor;

  /// The constraints for the button.
  final BoxConstraints? constraints;

  /// The icon alignment.
  final Alignment iconAlignment;

  /// Whether the button is enabled.
  final bool isEnabled;

  /// The callback when the button is tapped.
  final VoidCallback? onTap;

  /// Whether the item is a favorite.
  final bool isFavorite;

  const FastFavoriteIconButton({
    super.key,
    required this.isFavorite,
    this.trottleTimeDuration = kFastTrottleTimeDuration,
    this.iconAlignment = Alignment.center,
    this.shouldTrottleTime = false,
    this.isEnabled = true,
    this.highlightColor,
    this.disabledColor,
    this.constraints,
    this.focusColor,
    this.hoverColor,
    this.iconColor,
    this.iconSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    late Widget icon;

    if (isFavorite) {
      icon = _getFilledHeartIcon(context);
    } else {
      icon = _getHollowHeartIcon(context);
    }

    return FastIconButton2(
      trottleTimeDuration: trottleTimeDuration,
      shouldTrottleTime: shouldTrottleTime,
      highlightColor: highlightColor,
      iconAlignment: iconAlignment,
      disabledColor: disabledColor,
      constraints: constraints,
      hoverColor: hoverColor,
      focusColor: focusColor,
      iconColor: iconColor,
      isEnabled: isEnabled,
      iconSize: iconSize,
      onTap: onTap,
      icon: icon,
    );
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
