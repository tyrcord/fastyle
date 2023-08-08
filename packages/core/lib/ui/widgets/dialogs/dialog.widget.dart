// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

const _kPaddingContent = EdgeInsets.symmetric(horizontal: 16.0);

class FastDialog extends AlertDialog {
  final List<Widget> children;
  final Color? titleColor;
  final String titleText;

  const FastDialog({
    super.key,
    required this.titleText,
    required this.children,
    super.backgroundColor,
    this.titleColor,
    super.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            ...children,
            kFastVerticalSizedBox16,
          ],
        ),
      ),
      title: FastTitle(text: titleText, textColor: titleColor),
      surfaceTintColor: _getBackgroundColor(context),
      contentPadding: _kPaddingContent,
      titlePadding: kFastEdgeInsets16,
      actions: actions,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    return backgroundColor ??
        ThemeHelper.colors.getSecondaryBackgroundColor(context);
  }
}
