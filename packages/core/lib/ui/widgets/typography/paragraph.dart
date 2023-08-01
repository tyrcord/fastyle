// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastParagraph extends StatelessWidget {
  final EdgeInsets margin;
  final Widget? child;
  final String? text;
  final double? fontSize;

  const FastParagraph({
    super.key,
    this.margin = const EdgeInsets.symmetric(vertical: 8.0),
    this.text,
    this.child,
    this.fontSize,
  })  : assert(text != null || child != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: child ?? FastBody(text: text!, fontSize: fontSize),
    );
  }
}
