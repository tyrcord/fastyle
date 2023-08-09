// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

//TODO: @need-review: code from fastyle_dart

class FastAlertDialog extends AlertDialog {
  final VoidCallback? onCancel;
  final List<Widget>? children;
  final VoidCallback? onValid;
  final String? messageText;
  final Color? messageColor;
  final String? cancelText;
  final String? validText;
  final Color? titleColor;
  final String titleText;

  const FastAlertDialog({
    super.key,
    required this.titleText,
    super.backgroundColor,
    this.messageColor,
    this.messageText,
    this.cancelText,
    this.titleColor,
    this.validText,
    this.onCancel,
    this.children,
    super.actions,
    this.onValid,
  })  : assert(messageText == null || children == null),
        assert(messageText != null || children != null),
        assert(actions == null || cancelText == null);

  @override
  Widget build(BuildContext context) {
    return FastDialog(
      titleText: titleText,
      titleColor: titleColor,
      backgroundColor: backgroundColor,
      actions: actions ?? _buildDefaultActions(context),
      children: children ?? _buildDefaultContent(),
    );
  }

  List<Widget> _buildDefaultContent() {
    return [FastBody(text: messageText!, textColor: messageColor)];
  }

  List<Widget> _buildDefaultActions(BuildContext context) {
    return [
      if (onCancel != null)
        FastTextButton(
          text: cancelText ?? kFastCancelText,
          onTap: onCancel!,
        ),
      FastTextButton(
        onTap: () {
          if (onValid != null) {
            onValid!();
          } else {
            Navigator.pop(context);
          }
        },
        text: validText ?? kFastValidText,
        emphasis: FastButtonEmphasis.high,
      ),
    ];
  }
}
