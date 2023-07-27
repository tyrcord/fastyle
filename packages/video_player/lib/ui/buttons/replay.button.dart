// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FastVideoReplayButton extends StatelessWidget {
  final VoidCallback? onTap;

  const FastVideoReplayButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final palettes = ThemeHelper.getPaletteColors(context);
    final palette = palettes.gray;

    return GestureDetector(
      onTap: onTap,
      child: FastRoundedIcon(
        icon: const FaIcon(FontAwesomeIcons.rotateLeft),
        backgroundColor: palette.mid.withOpacity(0.5),
        iconColor: palette.ultraLight,
        size: kFastIconSizeMedium,
      ),
    );
  }
}
