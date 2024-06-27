// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:
import './export_pdf.dialog.dart';
import './operation_rewared.dialog.dart';
import 'export_csv.dialog.dart';
import 'export_excel.dialog.dart';

// Exports:
export './export_pdf.dialog.dart';
export './operation_rewared.dialog.dart';
export 'export_excel.dialog.dart';
export 'export_csv.dialog.dart';

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

void showRewardedExportPdfDialog({
  required BuildContext context,
  required FutureBoolCallback onCreateOperation,
  WidgetBuilder? intialBuilder,
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
  FastOperationStatusChanged? onAlternativeAction,
  String? Function(FastOperationStatus)? onGetAlternativeText,
}) {
  showAnimatedFastOverlay(
    context: context,
    barrierDismissible: barrierDismissible,
    child: FastExportPdfRewardedDialog(
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
      onGetAlternativeText: onGetAlternativeText,
      onAlternativeAction: onAlternativeAction,
    ),
  );
}

void showRewardedExportCsvDialog({
  required BuildContext context,
  required FutureBoolCallback onCreateOperation,
  WidgetBuilder? intialBuilder,
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
  FastOperationStatusChanged? onAlternativeAction,
  String? Function(FastOperationStatus)? onGetAlternativeText,
}) {
  showAnimatedFastOverlay(
    context: context,
    barrierDismissible: barrierDismissible,
    child: FastExportCsvRewardedDialog(
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
      onGetAlternativeText: onGetAlternativeText,
      onAlternativeAction: onAlternativeAction,
      errorBuilder: errorBuilder,
      onCancel: onCancel,
      onValid: onValid,
    ),
  );
}

void showRewardedExportExcelDialog({
  required BuildContext context,
  required FutureBoolCallback onCreateOperation,
  WidgetBuilder? intialBuilder,
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
  FastOperationStatusChanged? onAlternativeAction,
  String? Function(FastOperationStatus)? onGetAlternativeText,
}) {
  showAnimatedFastOverlay(
    context: context,
    barrierDismissible: barrierDismissible,
    child: FastExportExcelRewardedDialog(
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
      onGetAlternativeText: onGetAlternativeText,
      onAlternativeAction: onAlternativeAction,
      operationFailedBuilder: operationFailedBuilder,
      missingRightsBuilder: missingRightsBuilder,
      errorBuilder: errorBuilder,
      onCancel: onCancel,
      onValid: onValid,
    ),
  );
}
