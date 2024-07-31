// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

// TODO: rename to FastShadow
class FastShadowLayout extends StatelessWidget {
  /// Specifies the background color of this widget.
  final Color? backgroundColor;

  /// If non-null, rounds the corners of this widget outer border edge.
  final double borderRadius;

  /// Specifies the color of shadows.
  final Color? shadowColor;

  /// Specifies the radius of the shadow's blur effect.
  final double blurRadius;

  /// The child contained by the FastButtonLayout.
  final Widget child;

  /// The spread radius of the shadow.
  final double? spreadRadius;

  /// The offset of the shadow.
  final Offset? shadowOffset;

  /// The padding of the shadow layout.
  final EdgeInsets? padding;

  const FastShadowLayout({
    super.key,
    required this.child,
    this.borderRadius = kFastBorderRadius,
    this.blurRadius = kFastBlurRadius,
    this.backgroundColor,
    this.spreadRadius,
    this.shadowOffset,
    this.shadowColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(borderRadius);
    Widget content = child;

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    final boxShadow = BoxShadow(
      color: shadowColor ?? ThemeHelper.colors.getShadowColor(context),
      offset: shadowOffset ?? const Offset(0, 0),
      spreadRadius: spreadRadius ?? 0.0,
      blurRadius: blurRadius,
    );

    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: border, boxShadow: [boxShadow]),
      child: Material(
        color: _getBackgroundColor(context),
        borderRadius: border,
        child: content,
      ),
    );
  }

  Color? _getBackgroundColor(BuildContext context) {
    return backgroundColor ??
        ThemeHelper.colors.getSecondaryBackgroundColor(context);
  }
}
