// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastDialog extends AlertDialog {
  final List<Widget> children;
  final Color? titleColor;
  final String? titleText;

  const FastDialog({
    super.key,
    this.titleText,
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
      title: buildTitle(),
      surfaceTintColor: _getBackgroundColor(context),
      contentPadding: _getContentPadding(),
      titlePadding: _getTitlePadding(),
      actionsPadding: _getActionsPadding(),
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

  Widget? buildTitle() {
    if (titleText != null) {
      return FastTitle(text: titleText!, textColor: titleColor);
    }

    return null;
  }

  EdgeInsets _getTitlePadding() {
    if (titleText != null) {
      return const EdgeInsets.only(
        top: 16.0,
        bottom: 32.0,
        left: 16.0,
        right: 16.0,
      );
    }

    return const EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0);
  }

  EdgeInsetsGeometry _getActionsPadding() {
    return const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0);
  }

  EdgeInsets _getContentPadding() {
    if (titleText != null) {
      return const EdgeInsets.only(left: 16.0, right: 16.0);
    }

    return const EdgeInsets.only(top: 48.0, left: 16.0, right: 16.0);
  }
}
