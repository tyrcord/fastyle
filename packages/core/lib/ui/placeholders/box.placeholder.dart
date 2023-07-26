import 'package:flutter/material.dart';
import 'package:fastyle_dart/fastyle_dart.dart';

class FastBoxPlaceholder extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;

  const FastBoxPlaceholder({
    super.key,
    this.height,
    this.width,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _getBackgroundColor(context),
      height: height,
      width: width,
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (color != null) {
      return color!;
    }

    final palette = ThemeHelper.getPaletteColors(context);

    return palette.gray.lightest;
  }
}
