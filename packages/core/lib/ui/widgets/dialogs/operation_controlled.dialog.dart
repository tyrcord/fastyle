// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:t_helpers/helpers.dart';

/// Callback for when the operation status changes.
typedef FastOperationStatusChanged = void Function(FastOperationStatus)?;

/// This widget manages and displays various states of an operation.
///
/// It handles operations such as verifying and granting rights, as well as
/// managing various visual states.
///
class FastOperationControlledDialog extends StatefulWidget {
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

  final double tabletWidthFactor;

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
    this.onCancel,
    this.onValid,
    double? tabletWidthFactor = 0.6,
  }) : tabletWidthFactor = tabletWidthFactor ?? 0.6;

  @override
  FastOperationControlledDialogState createState() =>
      FastOperationControlledDialogState();
}

/// The state associated with [FastOperationControlledDialog].
class FastOperationControlledDialogState
    extends State<FastOperationControlledDialog> {
  /// Current status of the operation.
  FastOperationStatus _currentStatus = FastOperationStatus.initial;
  dynamic _currentError;

  /// Handles valid tap events based on the current operation status.
  void handleValidTap() {
    widget.onValid?.call(_currentStatus);

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

  void handleCancelTap() {
    widget.onCancel?.call(_currentStatus);
    Navigator.of(context).pop();
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
    return FastMediaLayoutBuilder(
      builder: (BuildContext context, FastMediaType mediaType) {
        final isHandset = mediaType < FastMediaType.tablet;

        return FractionallySizedBox(
          widthFactor: isHandset ? 1 : widget.tabletWidthFactor,
          child: FastAlertDialog(
            showValid: showValidButton,
            showCancel: showCancelButton,
            onCancel: handleCancelTap,
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
          ),
        );
      },
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
    return _getWidget(
      context,
      widget.verifyingRightsBuilder,
      _getDefaultLoadingBuilder(),
    );
  }

  /// Returns a widget representing the missing rights state.
  Widget _getMissingRightsBuilder(BuildContext context) {
    return _getWidget(
      context,
      widget.missingRightsBuilder,
      const FastBody(text: 'Missing rights'),
    );
  }

  /// Returns a widget representing the granting rights state.
  Widget _getGrantingRightsBuilder(BuildContext context) {
    return _getWidget(
      context,
      widget.grantingRightsBuilder,
      _getDefaultLoadingBuilder(),
    );
  }

  /// Returns a widget representing the rights denied state.
  Widget _getRightsDeniedBuillder(BuildContext context) {
    return _getWidget(
      context,
      widget.rightsDeniedBuillder,
      const FastBody(text: 'Rights denied'),
    );
  }

  /// Returns a widget representing the operation in progress state.
  Widget _getOperationInProgressBuilder(BuildContext context) {
    return _getWidget(
      context,
      widget.operationInProgressBuilder,
      _getDefaultLoadingBuilder(),
    );
  }

  /// Returns a widget representing the operation succeeded state.
  Widget _getOperationSucceededBuilder(BuildContext context) {
    return _getWidget(
      context,
      widget.operationSucceededBuilder,
      const FastBody(text: 'Operation succeeded'),
    );
  }

  /// Returns a widget representing the operation failed state.
  Widget _getOperationFailedBuilder(BuildContext context) {
    return _getWidget(
      context,
      widget.operationFailedBuilder,
      const FastBody(text: 'Failed to perform operation'),
    );
  }

  /// Returns a widget representing the error state.
  Widget _getErrorBuilder(BuildContext context) {
    if (widget.errorBuilder != null) {
      return widget.errorBuilder!(context, _currentError);
    }

    return const FastBody(text: 'An error occurred');
  }

  /// Returns the widget built by the given builder or the default widget if
  /// the builder is null.
  Widget _getWidget(
    BuildContext context,
    WidgetBuilder? builder,
    Widget defaultWidget,
  ) {
    return builder != null ? builder(context) : defaultWidget;
  }

  /// Returns the default loading widget.
  Widget _getDefaultLoadingBuilder() => const FastThreeBounceIndicator();

  /// Verifies if the user has the necessary rights to proceed with the
  /// operation.
  void _verifyRights() async {
    _updateStatus(FastOperationStatus.verifyingRights);

    bool hasRights = true;

    if (widget.onVerifyRights != null) {
      try {
        hasRights = await widget.onVerifyRights!();
      } catch (error) {
        _updateStatus(FastOperationStatus.error, error);

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
      } catch (error) {
        _updateStatus(FastOperationStatus.error, error);

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

      _updateStatus(
        operationSuccess
            ? FastOperationStatus.operationSucceeded
            : FastOperationStatus.operationFailed,
      );
    } catch (error) {
      debugLog('Failed to perform operation', value: error);
      operationSuccess = false;

      _updateStatus(
        FastOperationStatus.operationFailed,
        error,
      );
    }
  }

  /// Updates the operation status and optionally notifies listeners.
  void _updateStatus(FastOperationStatus status, [dynamic error]) {
    if (widget.onOperationStatusChanged != null) {
      widget.onOperationStatusChanged!(status);
    }

    setState(() {
      _currentStatus = status;
      _currentError = error;
    });
  }
}
