import 'package:flutter/material.dart';

import 'package:fastyle_core/fastyle_core.dart';

class FastInkWell extends StatelessWidget {
  final BorderRadius borderRadius;
  final Color? highlightColor;
  final VoidCallback? onTap;
  final Color? hoverColor;
  final Color? focusColor;
  final bool isEnabled;
  final Widget child;

  const FastInkWell({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.isEnabled = true,
    this.highlightColor,
    this.hoverColor,
    this.focusColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: _getHighlightColor(context),
      hoverColor: _getHoverColor(context),
      focusColor: _getFocusColor(context),
      onTap: isEnabled ? onTap : null,
      borderRadius: borderRadius,
      child: child,
    );
  }

  Color? _getFocusColor(BuildContext context) {
    return isEnabled
        ? focusColor ?? ThemeHelper.colors.getFocusColor(context)
        : null;
  }

  Color? _getHoverColor(BuildContext context) {
    return isEnabled
        ? hoverColor ?? ThemeHelper.colors.getHoverColor(context)
        : null;
  }

  Color? _getHighlightColor(BuildContext context) {
    return isEnabled
        ? highlightColor ?? ThemeHelper.colors.getHighlightColor(context)
        : null;
  }
}
