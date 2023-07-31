// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastCover extends StatelessWidget {
  final Color? backgroundColor;
  final Widget? child;

  const FastCover({
    super.key,
    this.backgroundColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: getBackgroundColor(context),
      child: child,
    );
  }

  Color getBackgroundColor(BuildContext context) {
    final palettes = ThemeHelper.getPaletteColors(context);
    final palette = palettes.gray;

    return backgroundColor ?? palette.ultraDark.withOpacity(0.75);
  }
}
