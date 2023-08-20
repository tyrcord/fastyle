// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastRichTextLink extends StatefulWidget {
  final String linkText;
  final String prefixText;
  final Color? linkColor;
  final VoidCallback? onTap;
  final double? fontSize;

  const FastRichTextLink({
    super.key,
    required this.linkText,
    required this.prefixText,
    this.linkColor,
    this.onTap,
    this.fontSize,
  });

  @override
  FastRichTextLinkState createState() => FastRichTextLinkState();
}

class FastRichTextLinkState extends State<FastRichTextLink> {
  late TapGestureRecognizer tapRecognizer;

  @override
  void initState() {
    super.initState();
    tapRecognizer = TapGestureRecognizer();
    tapRecognizer.onTap = widget.onTap;
  }

  @override
  void dispose() {
    tapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bodyTextStyle = ThemeHelper.texts.getBodyTextStyle(context);
    final scaleFactor = MediaQuery.textScaleFactorOf(context);
    final palette = ThemeHelper.getPaletteColors(context);
    final spanTextStyle = bodyTextStyle.copyWith(
      fontSize: (widget.fontSize ?? bodyTextStyle.fontSize!) * scaleFactor,
    );

    final linkTextStyle = spanTextStyle.copyWith(
      color: widget.linkColor ?? palette.blue.mid,
    );

    return RichText(
      text: TextSpan(
        style: spanTextStyle,
        text: widget.prefixText,
        children: [
          const TextSpan(text: ' '),
          TextSpan(
            recognizer: tapRecognizer,
            style: linkTextStyle,
            text: widget.linkText,
          ),
        ],
      ),
    );
  }
}
