// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastStatus extends StatelessWidget {
  final Color? textColor;

  final String? text;

  final Widget? icon;

  const FastStatus({
    super.key,
    this.text,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) icon!,
        if (text != null) ...appendText(context),
      ],
    );
  }

  List<Widget> appendText(BuildContext context) {
    return [
      kFastVerticalSizedBox16,
      FastSecondaryBody(textColor: _getTextColor(context), text: text!),
    ];
  }

  Color _getTextColor(BuildContext context) {
    return textColor ?? ThemeHelper.texts.getTertiaryLabelColor(context);
  }
}
