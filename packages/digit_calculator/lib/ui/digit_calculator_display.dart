import 'package:fastyle_dart/fastyle_dart.dart';
import 'digit_calculator_history_list.dart';
import 'package:t_helpers/helpers.dart';
import 'package:flutter/widgets.dart';

/// A custom widget that displays a calculator screen consisting of a
/// [FastDigitCalculatorHistoryList] widget and a current operation display widget.
class FastDigitCalculatorDisplay extends StatelessWidget {
  /// The scroll controller for the [FastDigitCalculatorHistoryList] widget.
  final ScrollController scrollController;

  /// The list of history items to display in the [FastDigitCalculatorHistoryList]
  /// widget.
  final List<TSimpleOperation> history;

  /// The background color for the calculator display.
  final Color? backgroundColor;

  /// The current operation to display in the calculator.
  final TSimpleOperation operation;

  /// The callback function to trigger when the user taps on the current operation
  /// display widget.
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
  /// * [onTap]: The callback function to trigger when the user taps on the current
  /// operation display widget.
  const FastDigitCalculatorDisplay({
    Key? key,
    required this.scrollController,
    required this.operation,
    required this.history,
    this.backgroundColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _getBackgroundColor(context),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // CalculatorHistoryList
            Expanded(
              flex: 2,
              child: FastDigitCalculatorHistoryList(
                scrollController: scrollController,
                history: history,
              ),
            ),
            // Current operation display
            GestureDetector(
              onTap: onTap, // Custom onTap function
              child: _buildCurrentOperation(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the current operation display widget.
  ///
  /// * [context]: The build context.
  ///
  /// Returns a [Container] widget that displays the current operation.
  Widget _buildCurrentOperation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      alignment: Alignment.centerRight,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: FastDisplay(
          fontWeight: kFastFontWeightSemiBold,
          text: _getDisplayText(),
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
  /// Returns the formatted text of the [operation] object. If the [operation] object
  /// is empty, returns "0".
  String _getDisplayText() {
    return operation.isEmpty ? "0" : operation.format();
  }
}
