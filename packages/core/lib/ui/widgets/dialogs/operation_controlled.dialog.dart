import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';

/// Callback for when the operation status changes.
typedef OperationStatusChanged = void Function(FastOperationStatus)?;

/// This widget manages and displays various states of an operation.
///
/// It handles operations such as verifying and granting rights, as well as
/// managing various visual states.
///
class FastOperationControlledDialog extends StatefulWidget {
  /// Callback triggered when the operation status changes.
  final OperationStatusChanged? onOperationStatusChanged;

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
  final WidgetBuilder? errorBuilder;

  /// Builder for the operation in progress state.
  final WidgetBuilder? operationInProgressBuilder;

  /// Builder for the operation succeeded state.
  final WidgetBuilder? operationSucceededBuilder;

  /// Builder for the operation failed state.
  final WidgetBuilder? operationFailedBuilder;

  /// Constructs a [FastOperationControlledDialog].
  const FastOperationControlledDialog({
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
  });

  @override
  FastOperationControlledDialogState createState() =>
      FastOperationControlledDialogState();
}

/// The state associated with [FastOperationControlledDialog].
class FastOperationControlledDialogState
    extends State<FastOperationControlledDialog> {
  /// Current status of the operation.
  FastOperationStatus _currentStatus = FastOperationStatus.initial;

  /// Handles valid tap events based on the current operation status.
  void handleValidTap() {
    if (_currentStatus == FastOperationStatus.initial) {
      _verifyRights();
    } else if (_currentStatus == FastOperationStatus.missingRights) {
      _grantRights();
    } else if (_currentStatus == FastOperationStatus.operationFailed ||
        _currentStatus == FastOperationStatus.operationSucceeded ||
        _currentStatus == FastOperationStatus.rightsDenied ||
        _currentStatus == FastOperationStatus.error) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget currentWidget;
    bool showValidButton = false;
    bool showCancelButton = false;

    // Logic to determine which widget to display based on current status.
    switch (_currentStatus) {
      case FastOperationStatus.initial:
        currentWidget = widget.intialBuilder(context);
        showValidButton = true;
        showCancelButton = true;
      case FastOperationStatus.verifyingRights:
        currentWidget = _getVerifyingRightsBuilder(context);
      case FastOperationStatus.missingRights:
        currentWidget = _getMissingRightsBuilder(context);
        showValidButton = true;
        showCancelButton = true;
      case FastOperationStatus.grantingRights:
        currentWidget = _getGrantingRightsBuilder(context);
      case FastOperationStatus.rightsDenied:
        currentWidget = _getRightsDeniedBuillder(context);
        showValidButton = true;
      case FastOperationStatus.operationInProgress:
        currentWidget = _getOperationInProgressBuilder(context);
      case FastOperationStatus.operationSucceeded:
        currentWidget = _getOperationSucceededBuilder(context);
        showValidButton = true;
      case FastOperationStatus.operationFailed:
        currentWidget = _getOperationFailedBuilder(context);
        showValidButton = true;
      case FastOperationStatus.error:
        currentWidget = _getErrorBuilder(context);
        showValidButton = true;
    }

    // Build the main dialog widget.
    return FastAlertDialog(
      showValid: showValidButton,
      showCancel: showCancelButton,
      onCancel: () => Navigator.of(context).pop(),
      onValid: handleValidTap,
      titleText: titleText,
      validText: validText,
      cancelText: cancelText,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40),
          child: Center(child: currentWidget),
        ),
      ],
    );
  }

  /// Returns the title text based on the current operation status.
  String? get titleText {
    if (widget.onGetTitleText != null) {
      return widget.onGetTitleText!(_currentStatus);
    }

    return null;
  }

  /// Returns the valid button text based on the current operation status.
  String? get validText {
    if (widget.onGetValidText != null) {
      return widget.onGetValidText!(_currentStatus);
    }

    return null;
  }

  /// Returns the cancel button text based on the current operation status.
  String? get cancelText {
    if (widget.onGetCancelText != null) {
      return widget.onGetCancelText!(_currentStatus);
    }

    return null;
  }

  /// Returns a widget representing the verifying rights state.
  Widget _getVerifyingRightsBuilder(BuildContext context) {
    if (widget.operationInProgressBuilder != null) {
      return widget.operationInProgressBuilder!(context);
    }

    return const FastThreeBounceIndicator();
  }

  /// Returns a widget representing the missing rights state.
  Widget _getMissingRightsBuilder(BuildContext context) {
    if (widget.missingRightsBuilder != null) {
      return widget.missingRightsBuilder!(context);
    }

    return const FastBody(text: 'Missing rights');
  }

  /// Returns a widget representing the granting rights state.
  Widget _getGrantingRightsBuilder(BuildContext context) {
    if (widget.operationInProgressBuilder != null) {
      return widget.operationInProgressBuilder!(context);
    }

    return const FastThreeBounceIndicator();
  }

  /// Returns a widget representing the rights denied state.
  Widget _getRightsDeniedBuillder(BuildContext context) {
    if (widget.rightsDeniedBuillder != null) {
      return widget.rightsDeniedBuillder!(context);
    }

    return const FastBody(text: 'Rights denied');
  }

  /// Returns a widget representing the operation in progress state.
  Widget _getOperationInProgressBuilder(BuildContext context) {
    if (widget.operationInProgressBuilder != null) {
      return widget.operationInProgressBuilder!(context);
    }

    return const FastThreeBounceIndicator();
  }

  /// Returns a widget representing the operation succeeded state.
  Widget _getOperationSucceededBuilder(BuildContext context) {
    if (widget.operationSucceededBuilder != null) {
      return widget.operationSucceededBuilder!(context);
    }

    return const FastBody(text: 'Operation succeeded');
  }

  /// Returns a widget representing the operation failed state.
  Widget _getOperationFailedBuilder(BuildContext context) {
    if (widget.operationFailedBuilder != null) {
      return widget.operationFailedBuilder!(context);
    }

    return const FastBody(text: 'Failed to perform operation');
  }

  /// Returns a widget representing the error state.
  Widget _getErrorBuilder(BuildContext context) {
    if (widget.errorBuilder != null) {
      return widget.errorBuilder!(context);
    }

    return const FastBody(text: 'An error occurred');
  }

  /// Verifies if the user has the necessary rights to proceed with the operation.
  void _verifyRights() async {
    _updateStatus(FastOperationStatus.verifyingRights);

    bool hasRights = true;

    if (widget.onVerifyRights != null) {
      try {
        hasRights = await widget.onVerifyRights!();
      } catch (_) {
        _updateStatus(FastOperationStatus.error);

        return;
      }
    }

    if (hasRights) {
      _proceedWithOperation();
    } else {
      _updateStatus(FastOperationStatus.missingRights);
    }
  }

  /// Grants the necessary rights to the user to proceed with the operation.
  void _grantRights() async {
    _updateStatus(FastOperationStatus.grantingRights);

    bool hasRights = false;

    if (widget.onGrantRights != null) {
      try {
        hasRights = await widget.onGrantRights!();
      } catch (_) {
        _updateStatus(FastOperationStatus.error);

        return;
      }
    }

    if (hasRights) {
      _proceedWithOperation();
    } else {
      _updateStatus(FastOperationStatus.rightsDenied);
    }
  }

  /// Proceeds with the actual operation.
  void _proceedWithOperation() async {
    _updateStatus(FastOperationStatus.operationInProgress);

    bool operationSuccess = false;

    try {
      operationSuccess = await widget.onCreateOperation();
    } catch (_) {
      operationSuccess = false;
    }

    _updateStatus(
      operationSuccess
          ? FastOperationStatus.operationSucceeded
          : FastOperationStatus.operationFailed,
    );
  }

  /// Updates the operation status and optionally notifies listeners.
  void _updateStatus(FastOperationStatus status) {
    if (widget.onOperationStatusChanged != null) {
      widget.onOperationStatusChanged!(status);
    }

    setState(() => _currentStatus = status);
  }
}
