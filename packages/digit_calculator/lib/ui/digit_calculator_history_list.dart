// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'digit_calculator_history_list_item.dart';

/// A custom widget that displays a list of history items for a
/// calculator screen.
class FastDigitCalculatorHistoryList extends StatelessWidget {
  /// The scroll controller for the list.
  final ScrollController? scrollController;

  /// The list of history items to display.
  final List<TSimpleOperation> history;

  /// The background color of the list.
  final Color? backgroundColor;

  /// Creates a [FastDigitCalculatorHistoryList] widget.
  ///
  /// * [scrollController]: The scroll controller for the list.
  ///
  /// * [history]: The list of history items to display.
  ///
  /// * [backgroundColor]: The background color of the list. If null,
  /// the default background color of the parent widget is used.
  const FastDigitCalculatorHistoryList({
    super.key,
    required this.history,
    this.scrollController,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        controller: scrollController,
        reverse: true,
        itemCount: history.length,
        itemBuilder: (context, index) {
          // Get the operation for the current history item
          final reversedIndex = history.length - index - 1;
          final operation = history[reversedIndex];

          // Build a FastDigitCalculatorHistoryListItem for the current
          // history item
          return FastDigitCalculatorHistoryListItem(operation: operation);
        },
      ),
    );
  }
}
