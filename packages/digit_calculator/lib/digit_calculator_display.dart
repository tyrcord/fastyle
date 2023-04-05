import 'digit_calculator_history_list.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/widgets.dart';

class FastDigitCalculatorDisplay extends StatelessWidget {
  // The scroll controller for the CalculatorHistoryList widget
  final ScrollController scrollController;

  // The current operation to display in the calculator
  final String? currentOperation;

  // The background color for the calculator display
  final Color? backgroundColor;

  // The list of history items to display in the CalculatorHistoryList widget
  final List<String> history;

  // The callback function to trigger when the user taps on
  // the current operation display
  final VoidCallback? onTap;

  const FastDigitCalculatorDisplay({
    Key? key,
    required this.scrollController,
    required this.history,
    this.currentOperation,
    this.backgroundColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // CalculatorHistoryList
        Expanded(
          flex: 2,
          child: FastDigitCalculatorHistoryList(
            history: history,
            scrollController: scrollController,
          ),
        ),
        // Current operation display
        GestureDetector(
          onTap: onTap, // Custom onTap function
          child: _buildCurrentOperation(context),
        ),
      ],
    );
  }

  // Current operation display widget
  Widget _buildCurrentOperation(BuildContext context) {
    return Container(
      color: _getBackgroundColor(context),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      alignment: Alignment.centerRight,
      child: FastDisplay(
        text: _getDisplayText(),
        fontWeight: kFastFontWeightSemiBold,
      ),
    );
  }

  // Background color for the display widget
  Color _getBackgroundColor(BuildContext context) {
    final colors = ThemeHelper.colors;

    return backgroundColor ?? colors.getSecondaryBackgroundColor(context);
  }

  // Text to display in the current operation display widget
  String _getDisplayText() {
    return currentOperation?.isNotEmpty == true ? currentOperation! : "0";
  }
}
