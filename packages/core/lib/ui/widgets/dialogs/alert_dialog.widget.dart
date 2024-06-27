// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastAlertDialog extends AlertDialog {
  final VoidCallback? onAlternative;
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
  final String? alternativeText;
  final bool showAlternative;

  const FastAlertDialog({
    super.key,
    this.titleText,
    super.backgroundColor,
    this.alternativeText,
    this.onAlternative,
    this.messageColor,
    this.messageText,
    this.cancelText,
    this.titleColor,
    this.validText,
    this.onCancel,
    this.children,
    super.actions,
    this.onValid,
    bool? showCancel,
    bool? showValid,
    bool? showAlternative,
  })  : assert(messageText == null || children == null),
        assert(messageText != null || children != null),
        showAlternative = showAlternative ?? false,
        showValid = showValid ?? true,
        showCancel = showCancel ?? false;

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
    final actions = [
      if (showCancel)
        FastTextButton(
          text: cancelText ?? CoreLocaleKeys.core_label_cancel.tr(),
          onTap: () {
            if (onCancel != null) {
              onCancel!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      if (showAlternative && onAlternative != null && alternativeText != null)
        FastTextButton(
          textColor: ThemeHelper.getPaletteColors(context).blue.mid,
          text: alternativeText,
          onTap: onAlternative,
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

    if (actions.length == 3) {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            actions[0],
            Row(
              children: [
                actions[1],
                actions[2],
              ],
            ),
          ],
        )
      ];
    }

    return actions;
  }
}
