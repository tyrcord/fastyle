// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastListHeader extends StatelessWidget {
  final Color? categoryColor;
  final Color? captionColor;
  final String categoryText;
  final String? captionText;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const FastListHeader({
    super.key,
    required this.categoryText,
    this.margin = const EdgeInsets.symmetric(vertical: 16.0),
    this.padding = EdgeInsets.zero,
    this.categoryColor,
    this.captionColor,
    this.captionText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FastSubhead(text: categoryText, textColor: categoryColor),
          if (captionText != null)
            FastCaption(text: captionText!, textColor: captionColor),
        ],
      ),
    );
  }
}
