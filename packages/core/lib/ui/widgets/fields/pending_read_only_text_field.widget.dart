// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:shimmer/shimmer.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastPendingReadOnlyTextField extends StatelessWidget {
  final bool enableInteractiveSelection;
  final bool showHelperBoundaries;
  final bool showBorder;
  final String placeholderText;
  final Color? helperTextColor;
  final Color? valueTextColor;
  final Color? highlightColor;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final String? captionText;
  final String? pendingText;
  final Widget? suffixIcon;
  final String? helperText;
  final String? valueText;
  final String labelText;
  final bool isPending;
  final double? fontSize;
  final Widget? child;

  const FastPendingReadOnlyTextField({
    super.key,
    required this.labelText,
    this.placeholderText = kFastEmptyString,
    this.enableInteractiveSelection = true,
    this.fontWeight = kFastFontWeightBold,
    this.showHelperBoundaries = true,
    this.showBorder = false,
    this.textAlign = TextAlign.left,
    this.isPending = false,
    this.helperTextColor,
    this.highlightColor,
    this.valueTextColor,
    this.pendingText,
    this.captionText,
    this.suffixIcon,
    this.helperText,
    this.valueText,
    this.fontSize,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FastReadOnlyTextField(
      showHelperBoundaries: showHelperBoundaries,
      helperTextColor: helperTextColor,
      placeholderText: placeholderText,
      valueTextColor: valueTextColor,
      captionText: captionText,
      helperText: helperText,
      suffixIcon: suffixIcon,
      fontWeight: fontWeight,
      labelText: labelText,
      valueText: valueText,
      textAlign: textAlign,
      fontSize: fontSize,
      showBorder: showBorder,
      child: _buildPendingChildIfNeeded(context),
    );
  }

  Widget? _buildPendingChildIfNeeded(BuildContext context) {
    if (isPending && pendingText != null) {
      final baseColor =
          valueTextColor ?? ThemeHelper.texts.getBodyTextStyle(context).color!;

      return RepaintBoundary(
        child: Shimmer.fromColors(
          highlightColor: highlightColor ?? baseColor.withOpacity(0.1),
          baseColor: baseColor,
          child: child ??
              FastBody(
                textColor: baseColor,
                textAlign: textAlign,
                fontWeight: fontWeight,
                text: pendingText!,
              ),
        ),
      );
    }

    return null;
  }
}
