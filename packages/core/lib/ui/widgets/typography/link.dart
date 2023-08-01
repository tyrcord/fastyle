// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastLink extends StatelessWidget {
  final TextAlign textAlign;
  final VoidCallback onTap;
  final Color? color;
  final String text;

  const FastLink({
    super.key,
    required this.text,
    required this.onTap,
    this.textAlign = TextAlign.left,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bodyTextStyle = ThemeHelper.texts.getBodyTextStyle(context);
    final palette = ThemeHelper.getPaletteColors(context);
    final linkTextStyle = bodyTextStyle.copyWith(
      fontSize: bodyTextStyle.fontSize!,
      color: color ?? palette.blue.mid,
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 34.0),
        child: Align(
          alignment: _getAlignment(),
          child: RichText(
            textAlign: textAlign,
            text: TextSpan(style: linkTextStyle, text: text),
          ),
        ),
      ),
    );
  }

  Alignment _getAlignment() {
    if (textAlign == TextAlign.center) {
      return Alignment.center;
    } else if (textAlign == TextAlign.right) {
      return Alignment.centerRight;
    }

    return Alignment.centerLeft;
  }
}
