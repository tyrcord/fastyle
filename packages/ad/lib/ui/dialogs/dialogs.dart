// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:
import './operation_rewared.dialog.dart';

export './operation_rewared.dialog.dart';

void showOperationRewardedDialog({
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
    child: FastOperationRewardedDialog(
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
