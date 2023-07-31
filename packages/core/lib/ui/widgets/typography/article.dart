// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastArticle extends StatelessWidget {
  final Iterable<Widget>? children;
  final EdgeInsets titleMargin;
  final String titleText;

  const FastArticle({
    Key? key,
    required this.titleText,
    this.titleMargin = const EdgeInsets.symmetric(vertical: 16.0),
    this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: titleMargin,
          child: FastTitle(text: titleText, fontWeight: kFastFontWeightBold),
        ),
        if (children != null) ...children!,
      ],
    );
  }
}
