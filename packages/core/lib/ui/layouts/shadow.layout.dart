// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastShadowLayout extends StatelessWidget {
  ///
  /// Specifies the background color of this widget.
  ///
  final Color? backgroundColor;

  ///
  /// If non-null, rounds the corners of this widget outer border edge.
  ///
  final double borderRadius;

  ///
  /// Specifies the color of shadows.
  ///
  final Color? shadowColor;

  ///
  /// Specifies the radius of the shadow's blur effect.
  ///
  final double blurRadius;

  ///
  /// The child contained by the FastButtonLayout.
  ///
  final Widget child;

  final EdgeInsets? padding;

  const FastShadowLayout({
    super.key,
    required this.child,
    this.borderRadius = kFastBorderRadius,
    this.blurRadius = kFastBlurRadius,
    this.backgroundColor,
    this.shadowColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? ThemeHelper.colors.getShadowColor(context),
            blurRadius: blurRadius,
          ),
        ],
        borderRadius: BorderRadius.circular(borderRadius),
        color: backgroundColor ??
            ThemeHelper.colors.getSecondaryBackgroundColor(context),
      ),
      child: child,
    );
  }
}
