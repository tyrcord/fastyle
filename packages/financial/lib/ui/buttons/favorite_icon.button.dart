// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FastItemFavoriteIcon extends StatelessWidget {
  final VoidCallback onIconTapped;
  final bool isFavorite;

  const FastItemFavoriteIcon({
    super.key,
    required this.onIconTapped,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    late Widget icon;

    if (isFavorite) {
      icon = _getFilledHeartIcon(context);
    } else {
      icon = _getHollowHeartIcon(context);
    }

    return Stack(
      alignment: Alignment.center,
      children: [icon, _getHeartIconHitZone()],
    );
  }

  /// Returns a widget that displays a hollow heart icon.
  Widget _getHollowHeartIcon(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);

    return FaIcon(
      FastFontAwesomeIcons.lightHeart,
      color: palette.gray.light,
      size: kFastFontSize16,
    );
  }

  /// Returns a widget that displays a filled heart icon.
  Widget _getFilledHeartIcon(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);

    return FaIcon(
      FontAwesomeIcons.solidHeart,
      size: kFastFontSize16,
      color: palette.red.mid,
    );
  }

  Widget _getHeartIconHitZone() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onIconTapped,
        child: const SizedBox(width: 40, height: 40),
      ),
    );
  }
}
