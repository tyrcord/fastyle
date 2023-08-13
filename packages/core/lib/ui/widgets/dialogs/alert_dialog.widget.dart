// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

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
  final String? titleText;
  final bool showCancel;
  final bool showValid;

  const FastAlertDialog({
    super.key,
    this.titleText,
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
    this.showCancel = true,
    this.showValid = true,
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
      if (onCancel != null && showCancel)
        FastTextButton(
          text: cancelText ?? CoreLocaleKeys.core_label_cancel.tr(),
          onTap: onCancel!,
        ),
      if (showValid)
        FastTextButton(
          onTap: () {
            if (onValid != null) {
              onValid!();
            } else {
              Navigator.pop(context);
            }
          },
          text: validText ?? CoreLocaleKeys.core_label_valid.tr(),
          emphasis: FastButtonEmphasis.high,
        ),
    ];
  }
}
