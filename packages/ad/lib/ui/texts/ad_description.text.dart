// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastAdDescription extends StatelessWidget {
  final String text;
  final FastAdSize adSize;
  final int? maxLines;

  const FastAdDescription({
    super.key,
    required this.text,
    this.adSize = FastAdSize.medium,
    int? maxLines,
  }) : maxLines = maxLines ?? (adSize == FastAdSize.large ? 3 : 2);

  @override
  Widget build(BuildContext context) {
    return FastSecondaryBody(
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      fontSize: 14,
      text: text,
    );
  }
}
