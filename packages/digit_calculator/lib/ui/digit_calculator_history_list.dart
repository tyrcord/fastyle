import 'digit_calculator_history_list_item.dart';
import 'package:t_helpers/helpers.dart';
import 'package:flutter/material.dart';

/// A custom widget that displays a list of history items for a
/// calculator screen.
class FastDigitCalculatorHistoryList extends StatelessWidget {
  /// The scroll controller for the list.
  final ScrollController scrollController;

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
    Key? key,
    required this.scrollController,
    required this.history,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
    );
  }
}