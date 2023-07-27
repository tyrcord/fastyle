// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_dart/fastyle_dart.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastAdDescription extends StatelessWidget {
  final String text;
  final FastAdSize adSize;

  const FastAdDescription({
    super.key,
    required this.text,
    this.adSize = FastAdSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return FastSecondaryBody(
      maxLines: adSize == FastAdSize.large ? 3 : 2,
      overflow: TextOverflow.ellipsis,
      text: text,
      fontSize: 14,
    );
  }
}
