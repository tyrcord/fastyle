import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';
import 'digit_calculator_history_list.dart';
import 'package:t_helpers/helpers.dart';
import 'package:flutter/widgets.dart';

/// A custom widget that displays a calculator screen consisting of a
/// [FastDigitCalculatorHistoryList] widget and a current operation
/// display widget.
class FastDigitCalculatorDisplay extends StatelessWidget {
  /// The scroll controller for the [FastDigitCalculatorHistoryList] widget.
  final ScrollController scrollController;

  /// A `ValueNotifier` that holds a `TSimpleOperation` object.
  /// Used to notify listeners whenever the current operation changes.
  final ValueNotifier<List<TSimpleOperation>> historyNotifier;

  /// The background color for the calculator display.
  final Color? backgroundColor;

  /// A `ValueNotifier` that holds a list of `TSimpleOperation` objects.
  /// Used to notify listeners whenever the history of operations changes.
  final ValueNotifier<TSimpleOperation> operationNotifier;

  /// The callback function to trigger when the user taps on the current
  /// operation display widget.
  final VoidCallback? onTap;

  /// Creates a [FastDigitCalculatorDisplay] widget.
  ///
  /// * [scrollController]: The scroll controller for the
  /// [FastDigitCalculatorHistoryList] widget.
  ///
  /// * [history]: The list of history items to display in the
  /// [FastDigitCalculatorHistoryList] widget.
  ///
  /// * [backgroundColor]: The background color for the calculator display. If
  /// null, the secondary background color of the theme is used.
  ///
  /// * [operation]: The current operation to display in the calculator.
  ///
  /// * [onTap]: The callback function to trigger when the user taps on
  /// the current operation display widget.
  const FastDigitCalculatorDisplay({
    Key? key,
    required this.operationNotifier,
    required this.scrollController,
    required this.historyNotifier,
    this.backgroundColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        color: _getBackgroundColor(context),
        child: SafeArea(
          bottom: false,
          top: false,
          child: Column(
            children: [
              if (constraints.maxHeight >= 128)
                // CalculatorHistoryList
                Expanded(
                  flex: 2,
                  child: ValueListenableBuilder<List<TSimpleOperation>>(
                    valueListenable: historyNotifier,
                    builder: (context, history, child) {
                      return FastDigitCalculatorHistoryList(
                        scrollController: scrollController,
                        history: history,
                      );
                    },
                  ),
                ),
              // Current operation display
              GestureDetector(
                onTap: onTap,
                child: ValueListenableBuilder<TSimpleOperation>(
                  valueListenable: operationNotifier,
                  builder: (context, operation, child) {
                    return _buildCurrentOperation(context, operation);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// Builds the current operation display widget.
  ///
  /// * [context]: The build context.
  ///
  /// Returns a [Container] widget that displays the current operation.
  Widget _buildCurrentOperation(
    BuildContext context,
    TSimpleOperation operation,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      alignment: Alignment.centerRight,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: FastDisplay(
          fontWeight: kFastFontWeightSemiBold,
          text: _getDisplayText(operation),
        ),
      ),
    );
  }

  /// Gets the background color of the calculator screen.
  ///
  /// * [context]: The build context.
  ///
  /// Returns the provided background color or the secondary background color of
  /// the theme if no background color is provided.
  Color _getBackgroundColor(BuildContext context) {
    final colors = ThemeHelper.colors;

    return backgroundColor ?? colors.getSecondaryBackgroundColor(context);
  }

  /// Gets the formatted text of the current operation.
  ///
  /// Returns the formatted text of the [operation] object.
  /// If the [operation] object is empty, returns "0".
  String _getDisplayText(TSimpleOperation operation) {
    return operation.isEmpty ? "0" : operation.format();
  }
}
