// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

/// A widget that displays the result of a calculator category.
class FastCalculatorCategoryResult extends StatelessWidget {
  /// The text to display in the result.
  final String text;

  /// Creates a new [FastCalculatorCategoryResult] instance.
  const FastCalculatorCategoryResult({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        kFastSizedBox12,
        DecoratedBox(
          decoration: ThemeHelper.createBorderSide(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FastSubtitle(text: text),
              kFastSizedBox8,
            ],
          ),
        ),
        kFastSizedBox12,
      ],
    );
  }
}
