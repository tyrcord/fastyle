// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastBoxPlaceholder extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  final Widget? child;

  const FastBoxPlaceholder({
    super.key,
    this.height,
    this.width,
    this.color,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _getBackgroundColor(context),
      height: height ?? double.infinity,
      width: width ?? double.infinity,
      child: child,
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (color != null) {
      return color!;
    }

    final palette = ThemeHelper.getPaletteColors(context);

    return palette.blueGray.lightest;
  }
}
