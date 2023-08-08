// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

export './alert_dialog.widget.dart';
export './dialog.widget.dart';

Future<void> showFastAlertDialog({
  required BuildContext context,
  required String titleText,
  bool barrierDismissible = true,
  Color? backgroundColor,
  List<Widget>? children,
  VoidCallback? onCancel,
  List<Widget>? actions,
  VoidCallback? onValid,
  String? messageText,
  String? cancelText,
  String? validText,
  Color? titleColor,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      return FastAlertDialog(
        titleText: titleText,
        cancelText: cancelText,
        validText: validText,
        titleColor: titleColor,
        actions: actions,
        backgroundColor: backgroundColor,
        onValid: onValid,
        onCancel: onCancel,
        messageText: messageText,
        children: children,
      );
    },
  );
}

/// Shows a dialog with an animated overlay.
Future<T?> showAnimatedFastOverlay<T extends Object?>({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    barrierDismissible: barrierDismissible,
    barrierLabel: kFastEmptyString,
    context: context,
    pageBuilder: (_, __, ___) => child,
    transitionBuilder: (ctx, a1, a2, child) {
      final curve = Curves.linear.transform(a1.value);

      return Transform.scale(scale: curve, child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

Future<T?> showAnimatedFastAlertDialog<T extends Object?>({
  required BuildContext context,
  required String titleText,
  bool barrierDismissible = true,
  Color? backgroundColor,
  List<Widget>? children,
  VoidCallback? onCancel,
  List<Widget>? actions,
  VoidCallback? onValid,
  String? messageText,
  String? cancelText,
  String? validText,
  Color? titleColor,
}) {
  return showGeneralDialog<T>(
    barrierDismissible: barrierDismissible,
    barrierLabel: kFastEmptyString,
    context: context,
    pageBuilder: (_, __, ___) => FastAlertDialog(
      titleText: titleText,
      cancelText: cancelText,
      validText: validText,
      titleColor: titleColor,
      actions: actions,
      backgroundColor: backgroundColor,
      onValid: onValid,
      onCancel: onCancel,
      messageText: messageText,
      children: children,
    ),
    transitionBuilder: (ctx, a1, a2, child) {
      final curve = Curves.linear.transform(a1.value);

      return Transform.scale(scale: curve, child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
