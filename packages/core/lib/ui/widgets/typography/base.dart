// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastBaseTypography extends StatelessWidget {
  final bool enableInteractiveSelection;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;
  final bool? softWrap;
  final double? letterSpacing;
  final TextAlign textAlign;
  final double lineHeight;
  final Color? textColor;
  final double? fontSize;
  final bool upperCase;
  final int? maxLines;
  final String text;

  const FastBaseTypography({
    super.key,
    required this.text,
    this.enableInteractiveSelection = false,
    this.lineHeight = kFastLineHeight,
    this.textAlign = TextAlign.left,
    this.upperCase = false,
    this.letterSpacing,
    this.fontWeight,
    this.textColor,
    this.fontSize,
    this.maxLines,
    this.overflow,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    final textValue = upperCase ? text.toUpperCase() : text;
    final textStyle = getDefaultTextStyle(context).copyWith(
      height: lineHeight,
      fontSize: fontSize,
      color: textColor,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight,
    );

    if (enableInteractiveSelection) {
      return SelectableText(
        textValue,
        textAlign: textAlign,
        style: textStyle,
        maxLines: maxLines,
      );
    }

    return Text(
      textValue,
      textAlign: textAlign,
      style: textStyle,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  TextStyle getDefaultTextStyle(BuildContext context) {
    return ThemeHelper.texts.getBodyTextStyle(context);
  }
}
