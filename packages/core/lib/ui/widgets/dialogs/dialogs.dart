// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

export './alert_dialog.widget.dart';
export './dialog.widget.dart';
export './operation_controlled.dialog.dart';

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
    pageBuilder: (_, __, ___) => SafeArea(child: child),
    transitionBuilder: (ctx, a1, a2, child) {
      final curve = Curves.linear.transform(a1.value);

      return Transform.scale(scale: curve, child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

Future<T?> showAnimatedFastAlertDialog<T extends Object?>({
  required BuildContext context,
  String? titleText,
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
  bool? showCancel,
  bool? showValid,
}) {
  return showGeneralDialog<T>(
    barrierDismissible: barrierDismissible,
    barrierLabel: kFastEmptyString,
    context: context,
    pageBuilder: (_, __, ___) => SafeArea(
      child: FastAlertDialog(
        titleText: titleText,
        cancelText: cancelText,
        validText: validText,
        showValid: showValid,
        showCancel: showCancel,
        titleColor: titleColor,
        actions: actions,
        backgroundColor: backgroundColor,
        onValid: onValid,
        onCancel: onCancel,
        messageText: messageText,
        children: children,
      ),
    ),
    transitionBuilder: (ctx, a1, a2, child) {
      final curve = Curves.linear.transform(a1.value);

      return Transform.scale(scale: curve, child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

void showOperationControlledDialog({
  required BuildContext context,
  required WidgetBuilder intialBuilder,
  required FutureBoolCallback onCreateOperation,
  String? Function(FastOperationStatus)? onGetValidText,
  String? Function(FastOperationStatus)? onGetCancelText,
  String? Function(FastOperationStatus)? onGetTitleText,
  Widget Function(BuildContext context, dynamic error)? errorBuilder,
  bool barrierDismissible = false,
  FastOperationStatusChanged? onOperationStatusChanged,
  FutureBoolCallback? onVerifyRights,
  FutureBoolCallback? onGrantRights,
  WidgetBuilder? verifyingRightsBuilder,
  WidgetBuilder? grantingRightsBuilder,
  WidgetBuilder? rightsDeniedBuillder,
  WidgetBuilder? operationInProgressBuilder,
  WidgetBuilder? operationSucceededBuilder,
  WidgetBuilder? operationFailedBuilder,
  WidgetBuilder? missingRightsBuilder,
  FastOperationStatusChanged? onCancel,
  FastOperationStatusChanged? onValid,
}) {
  showAnimatedFastOverlay(
    context: context,
    barrierDismissible: barrierDismissible,
    child: FastOperationControlledDialog(
      onGetTitleText: onGetTitleText,
      onGetCancelText: onGetCancelText,
      onGetValidText: onGetValidText,
      onCreateOperation: onCreateOperation,
      intialBuilder: intialBuilder,
      onOperationStatusChanged: onOperationStatusChanged,
      onGrantRights: onGrantRights,
      onVerifyRights: onVerifyRights,
      verifyingRightsBuilder: verifyingRightsBuilder,
      grantingRightsBuilder: grantingRightsBuilder,
      rightsDeniedBuillder: rightsDeniedBuillder,
      operationInProgressBuilder: operationInProgressBuilder,
      operationSucceededBuilder: operationSucceededBuilder,
      operationFailedBuilder: operationFailedBuilder,
      missingRightsBuilder: missingRightsBuilder,
      errorBuilder: errorBuilder,
      onCancel: onCancel,
      onValid: onValid,
    ),
  );
}
