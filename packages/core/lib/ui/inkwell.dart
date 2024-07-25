import 'package:flutter/material.dart';

import 'package:fastyle_core/fastyle_core.dart';

class FastInkWell extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? highlightColor;
  final Color? hoverColor;
  final Color? focusColor;
  final bool isEnabled;
  final BorderRadius borderRadius;

  const FastInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.highlightColor,
    this.hoverColor,
    this.focusColor,
    this.isEnabled = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
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

  Color _getFocusColor(BuildContext context) {
    return focusColor ?? ThemeHelper.colors.getFocusColor(context);
  }

  Color _getHoverColor(BuildContext context) {
    return hoverColor ?? ThemeHelper.colors.getHoverColor(context);
  }

  Color _getHighlightColor(BuildContext context) {
    return highlightColor ?? ThemeHelper.colors.getHighlightColor(context);
  }
}
