// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FastVideoReplayButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget? icon;

  const FastVideoReplayButton({
    super.key,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final palettes = ThemeHelper.getPaletteColors(context);
    final palette = palettes.gray;

    return GestureDetector(
      onTap: onTap,
      child: FastRoundedIcon(
        backgroundColor: palette.mid.withOpacity(0.5),
        iconColor: palette.ultraLight,
        size: kFastIconSizeMedium,
        icon: buildIcon(context),
      ),
    );
  }

  Widget buildIcon(BuildContext context) {
    if (icon != null) {
      return icon!;
    }

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightRotateLeft);
    }

    return const FaIcon(FontAwesomeIcons.rotateLeft);
  }
}
