// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

/// A widget that displays the result of a calculator category.
class FastCalculatorCategoryResult extends StatelessWidget {
  /// The text to display in the result.
  final String text;

  final String? value;

  final Color? borderColor;

  /// Creates a new [FastCalculatorCategoryResult] instance.
  const FastCalculatorCategoryResult({
    super.key,
    required this.text,
    this.value,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      decoration: ThemeHelper.createBorderSide(
        context,
        color: borderColor,
      ),
      padding: const EdgeInsets.only(bottom: 6.0),
      child: FastSubtitle(text: text),
    );
  }
}
