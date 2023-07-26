import 'package:flutter/material.dart';
import 'package:fastyle_dart/fastyle_dart.dart';

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
      fontWeight: kFastFontWeightMedium,
      overflow: TextOverflow.ellipsis,
      text: text,
      fontSize: 16,
      maxLines: 1,
    );
  }
}
