// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lingua_ad/generated/locale_keys.g.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:fastyle_ad/logic/logic.dart';
import 'package:t_helpers/helpers.dart';

class FastOperationRewardedDialog extends StatelessWidget {
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
  final WidgetBuilder intialBuilder;

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

  /// Constructs a [FastOperationRewardedDialog].
  FastOperationRewardedDialog({
    super.key,
    required this.onCreateOperation,
    required this.intialBuilder,
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

  static String? handleTitleChange(FastOperationStatus status) {
    if (status == FastOperationStatus.error ||
        status == FastOperationStatus.rightsDenied) {
      return CoreLocaleKeys.core_message_whoops.tr();
    }

    return CoreLocaleKeys.core_message_please_wait.tr();
  }

  static String? handleValidTextChange(FastOperationStatus status) {
    if (status == FastOperationStatus.initial) {
      return CoreLocaleKeys.core_label_continue.tr();
    } else if (status == FastOperationStatus.missingRights) {
      return CoreLocaleKeys.core_label_watch_now.tr();
    } else if (status == FastOperationStatus.operationFailed ||
        status == FastOperationStatus.rightsDenied ||
        status == FastOperationStatus.error ||
        status == FastOperationStatus.operationSucceeded) {
      return CoreLocaleKeys.core_label_done.tr();
    }

    return null;
  }

  Future<bool> handleGrantRights() async {
    await _clearAndCancelAdRequest();

    rewardedAdBloc.addEvent(
      const FastRewardedAdBlocEvent.loadAndShowAd(),
    );

    // Wait for the ad to be dismissed
    final response = await RaceStream([
      rewardedAdBloc.onError,
      rewardedAdBloc.onReward,
      rewardedAdBloc.onData.where((FastRewardedAdBlocState state) {
        return state.error != null;
      }),
      rewardedAdBloc.onData.where((FastRewardedAdBlocState state) {
        return state.hasDismissedAd;
      }),
    ]).first;

    if (response is RewardItem) {
      return true;
    }

    if (response is FastRewardedAdBlocState) {
      if (response.hasDismissedAd) {
        return false;
      }

      if (response.error is FastRewardedAdBlocError) {
        debugLog(
          'Error while granting rights',
          debugLabel: 'FastOperationRewardedDialog',
          value: response.error,
        );

        throw response.error as FastRewardedAdBlocError;
      }
    }

    debugLog(
      'Error while granting rights',
      debugLabel: 'FastOperationRewardedDialog',
      value: response,
    );

    throw FastRewardedAdBlocError.unknown;
  }

  @override
  Widget build(BuildContext context) {
    return FastOperationControlledDialog(
      operationFailedBuilder: operationFailedBuilder ?? buildOperationFailed,
      rightsDeniedBuillder: rightsDeniedBuillder ?? buildRightsDenied,
      onGetValidText: onGetValidText ?? handleValidTextChange,
      operationInProgressBuilder: operationInProgressBuilder,
      onGetTitleText: onGetTitleText ?? handleTitleChange,
      onOperationStatusChanged: onOperationStatusChanged,
      onGrantRights: onGrantRights ?? handleGrantRights,
      verifyingRightsBuilder: verifyingRightsBuilder,
      grantingRightsBuilder: grantingRightsBuilder,
      missingRightsBuilder: missingRightsBuilder,
      errorBuilder: errorBuilder ?? buildError,
      onCreateOperation: onCreateOperation,
      onGetCancelText: onGetCancelText,
      onVerifyRights: onVerifyRights,
      intialBuilder: intialBuilder,
      onCancel: onCancel,
      onValid: onValid,
      operationSucceededBuilder:
          operationSucceededBuilder ?? buildOperationSucceeded,
    );
  }

  Widget buildError(context, error) {
    var message = CoreLocaleKeys.core_error_error_occurred.tr();
    bool isWarning = false;

    if (error is FastRewardedAdBlocError) {
      switch (error) {
        case FastRewardedAdBlocError.noAdAvailable:
          message = AdLocaleKeys.ad_error_no_ads_available.tr();
          isWarning = true;
        case FastRewardedAdBlocError.adFailedToLoad:
          message = AdLocaleKeys.ad_error_failed_to_load_ad.tr();
        case FastRewardedAdBlocError.unknown:
          message = message;
      }
    }

    if (isWarning) {
      return FastWarningStatus(text: message);
    }

    return FastErrorStatus(text: message);
  }

  Widget buildOperationSucceeded(BuildContext context) {
    return FastSuccessStatus(
      text: AdLocaleKeys.ad_message_enjoy_your_reward.tr(),
    );
  }

  Widget buildOperationFailed(BuildContext context) {
    return FastErrorStatus(
      text: CoreLocaleKeys.core_error_error_occurred.tr(),
    );
  }

  Widget buildRightsDenied(BuildContext context) {
    return FastWarningStatus(
      text: AdLocaleKeys.ad_error_dimissed_ad.tr(),
    );
  }

  Future<void> _clearAndCancelAdRequest() async {
    rewardedAdBloc.addEvent(
      const FastRewardedAdBlocEvent.clearAndCancelAdRequest(),
    );

    await rewardedAdBloc.onData
        .where((state) => state.requestId == null && state.error == null)
        .first;
  }
}
