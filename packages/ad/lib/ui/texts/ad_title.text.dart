// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAdTitle extends StatelessWidget {
  final String text;

  const FastAdTitle({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return FastBody(
      textColor: ThemeHelper.texts.getLabelColor(context),
      fontWeight: kFastFontWeightSemiBold,
      overflow: TextOverflow.ellipsis,
      text: text,
      fontSize: 16,
      maxLines: 1,
    );
  }
}
