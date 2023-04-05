import 'digit_calculator_history_list_item.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';

class FastDigitCalculatorHistoryList extends StatelessWidget {
  final List<String> history;
  final ScrollController scrollController;
  final Color? backgroundColor;

  const FastDigitCalculatorHistoryList({
    Key? key,
    required this.history,
    required this.scrollController,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _getBackgroundColor(context),
      padding: const EdgeInsets.only(top: 24.0),
      child: ListView.builder(
        controller: scrollController,
        reverse: true,
        itemCount: history.length,
        itemBuilder: (context, index) {
          final reversedIndex = history.length - index - 1;
          final operation = history[reversedIndex];

          return FastDigitCalculatorHistoryListItem(operation: operation);
        },
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    final colors = ThemeHelper.colors;

    return backgroundColor ?? colors.getSecondaryBackgroundColor(context);
  }
}
