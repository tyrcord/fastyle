// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastReadOnlyTextField extends StatelessWidget {
  final bool enableInteractiveSelection;
  final bool showHelperBoundaries;
  final bool showBorder;
  final Color? helperTextColor;
  final String placeholderText;
  final FontWeight fontWeight;
  final Color? valueTextColor;
  final String? captionText;
  final TextAlign textAlign;
  final Widget? suffixIcon;
  final String? helperText;
  final String? valueText;
  final String labelText;
  final Widget? child;
  final double? fontSize;

  const FastReadOnlyTextField({
    super.key,
    required this.labelText,
    this.placeholderText = kFastEmptyString,
    this.enableInteractiveSelection = true,
    this.fontWeight = kFastFontWeightBold,
    this.showHelperBoundaries = true,
    this.showBorder = false,
    this.textAlign = TextAlign.left,
    this.helperTextColor,
    this.valueTextColor,
    this.captionText,
    this.suffixIcon,
    this.helperText,
    this.valueText,
    this.fontSize,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FastFieldLayout(
      labelText: labelText,
      captionText: captionText,
      helperText: helperText,
      helperTextColor: helperTextColor,
      control: _buildControl(context),
      showHelperBoundaries: showHelperBoundaries,
      suffixIcon: suffixIcon,
    );
  }

  Widget _buildControl(BuildContext context) {
    return Container(
      height: 37.0,
      decoration: showBorder ? ThemeHelper.createBorderSide(context) : null,
      alignment: Alignment.centerLeft,
      child: child ?? buildText(),
    );
  }

  Widget buildText() {
    if (valueText != null) {
      return FastBody(
        enableInteractiveSelection: enableInteractiveSelection,
        textColor: valueTextColor,
        fontWeight: fontWeight,
        textAlign: textAlign,
        fontSize: fontSize,
        text: valueText!,
      );
    }

    return FastPlaceholder(
      enableInteractiveSelection: enableInteractiveSelection,
      text: placeholderText,
      textAlign: textAlign,
      fontSize: fontSize,
    );
  }
}
