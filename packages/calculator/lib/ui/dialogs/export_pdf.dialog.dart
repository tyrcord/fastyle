// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_ad/generated/locale_keys.g.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';

class FastExportPdfRewardedDialog extends StatelessWidget {
  /// Callback triggered when the operation status changes.
  final FastOperationStatusChanged? onOperationStatusChanged;

  /// Callback to create an operation.
  final FutureBoolCallback onCreateOperation;

  /// Callback to verify rights.
  final FutureBoolCallback? onVerifyRights;

  /// Callback to grant rights.
  final FutureBoolCallback? onGrantRights;

  /// Function to retrieve valid text based on operation status.
  final String? Function(FastOperationStatus)? onGetValidText;

  /// Function to retrieve cancel text based on operation status.
  final String? Function(FastOperationStatus)? onGetCancelText;

  /// Function to retrieve title text based on operation status.
  final String? Function(FastOperationStatus)? onGetTitleText;

  /// Builder for the initial state.
  final WidgetBuilder? intialBuilder;

  /// Builder for the verifying rights state.
  final WidgetBuilder? verifyingRightsBuilder;

  /// Builder for the missing rights state.
  final WidgetBuilder? missingRightsBuilder;

  /// Builder for the granting rights state.
  final WidgetBuilder? grantingRightsBuilder;

  /// Builder for the rights denied state.
  final WidgetBuilder? rightsDeniedBuillder;

  /// Builder for the error state.
  final Widget Function(BuildContext context, dynamic error)? errorBuilder;

  /// Builder for the operation in progress state.
  final WidgetBuilder? operationInProgressBuilder;

  /// Builder for the operation succeeded state.
  final WidgetBuilder? operationSucceededBuilder;

  /// Builder for the operation failed state.
  final WidgetBuilder? operationFailedBuilder;

  /// Callback for when the cancel button is tapped.
  final FastOperationStatusChanged? onCancel;

  /// Callback for when the valid button is tapped.
  final FastOperationStatusChanged? onValid;

  final rewardedAdBloc = FastRewardedAdBloc();

  /// Constructs a [FastExportPdfRewardedDialog].
  FastExportPdfRewardedDialog({
    super.key,
    required this.onCreateOperation,
    this.intialBuilder,
    this.onOperationStatusChanged,
    this.onGrantRights,
    this.onVerifyRights,
    this.verifyingRightsBuilder,
    this.missingRightsBuilder,
    this.grantingRightsBuilder,
    this.rightsDeniedBuillder,
    this.operationInProgressBuilder,
    this.operationSucceededBuilder,
    this.operationFailedBuilder,
    this.onGetValidText,
    this.errorBuilder,
    this.onGetCancelText,
    this.onGetTitleText,
    this.onCancel,
    this.onValid,
  });

  Future<bool> handleVerifyRights() async {
    return isAdFreeEnabled();
  }

  @override
  Widget build(BuildContext context) {
    return FastOperationRewardedDialog(
      missingRightsBuilder: missingRightsBuilder ?? buildMissingRights,
      onGetValidText: onGetValidText ?? handleValidTextChange,
      operationInProgressBuilder: operationInProgressBuilder,
      operationSucceededBuilder: operationSucceededBuilder,
      onVerifyRights: onVerifyRights ?? handleVerifyRights,
      onGetTitleText: onGetTitleText ?? handleTitleChange,
      onOperationStatusChanged: onOperationStatusChanged,
      operationFailedBuilder: operationFailedBuilder,
      verifyingRightsBuilder: verifyingRightsBuilder,
      intialBuilder: intialBuilder ?? buildInitial,
      grantingRightsBuilder: grantingRightsBuilder,
      rightsDeniedBuillder: rightsDeniedBuillder,
      onCreateOperation: onCreateOperation,
      onGetCancelText: onGetCancelText,
      onGrantRights: onGrantRights,
      errorBuilder: errorBuilder,
      onCancel: onCancel,
      onValid: onValid,
    );
  }

  Widget buildInitial(BuildContext context) {
    return FastBody(
      text: CoreLocaleKeys.core_question_export_data_pdf.tr(),
    );
  }

  Widget buildMissingRights(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FastBody(
          text: PurchasesLocaleKeys
              .purchases_message_have_not_acquired_premium_version
              .tr(),
        ),
        kFastVerticalSizedBox16,
        FastBody(
          text: AdLocaleKeys.ad_message_watch_ad_unlock_pdf.tr(),
        ),
      ],
    );
  }

  String? handleTitleChange(FastOperationStatus status) {
    if (status == FastOperationStatus.initial) {
      return CoreLocaleKeys.core_label_export_pdf.tr();
    } else if (status == FastOperationStatus.missingRights) {
      return PurchasesLocaleKeys.purchases_label_free_version.tr();
    } else if (status == FastOperationStatus.operationSucceeded) {
      return CoreLocaleKeys.core_message_pdf_ready.tr();
    } else if (status == FastOperationStatus.operationFailed) {
      return CoreLocaleKeys.core_message_failed_to_generate_pdf.tr();
    } else if (status == FastOperationStatus.operationInProgress) {
      return CoreLocaleKeys.core_message_generating_pdf.tr();
    }

    return FastOperationRewardedDialog.handleTitleChange(status);
  }

  String? handleValidTextChange(FastOperationStatus status) {
    if (status == FastOperationStatus.initial) {
      return CoreLocaleKeys.core_label_generate.tr();
    } else if (status == FastOperationStatus.operationSucceeded) {
      return CoreLocaleKeys.core_label_save_text.tr();
    }

    return FastOperationRewardedDialog.handleValidTextChange(status);
  }
}
