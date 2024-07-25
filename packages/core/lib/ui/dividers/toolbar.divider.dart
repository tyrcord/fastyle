import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';

class FastToolbarDivider extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsets padding;

  const FastToolbarDivider({
    super.key,
    this.height = 24,
    this.width = 1,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        color: ThemeHelper.colors.getDisabledColor(context),
        height: height,
        width: width,
      ),
    );
  }
}
