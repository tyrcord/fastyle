library fastyle_digit_calculator;

import 'ui/digit_calculator_display.dart';
import 'package:flutter/material.dart';
import 'package:t_helpers/helpers.dart';
import 'ui/digit_calculator_keyboard.dart';

/// A Flutter widget that provides a digit calculator with a display and keyboard.
///
/// The calculator provides basic arithmetic operations (+, -, *, /)
/// The display shows the current operation and the history of operations.
/// The keyboard provides buttons for input.
///
/// To use this widget, simply create a new instance of the [FastDigitCalculator]
/// class and add it to your widget tree.
///
/// {@tool dart}
///
/// ```dart
/// FastDigitCalculator(
///   maxOperationLength: 50,
/// )
/// ```
/// {@end-tool}
class FastDigitCalculator extends StatefulWidget {
  /// The maximum length of the text that can be displayed in the calculator's display.
  final int maxOperationLength;

  /// Creates a new instance of the [FastDigitCalculator] widget.
  ///
  /// The [maxOperationLength] parameter sets the maximum length of the text that can be displayed
  /// in the calculator's display.
  const FastDigitCalculator({
    super.key,
    this.maxOperationLength = 35,
  });

  @override
  FastDigitCalculatorState createState() => FastDigitCalculatorState();
}

// The state class for the [FastDigitCalculator] widget.
class FastDigitCalculatorState extends State<FastDigitCalculator> {
  // The scroll controller used to scroll the display of the calculator.
  final ScrollController _scrollController = ScrollController();
  // The current operation being performed on the calculator.
  TSimpleOperation _currentOperation = const TSimpleOperation();
  // The history of operations that have been performed on the calculator.
  final List<TSimpleOperation> _history = [];

  // Called when a key is pressed on the calculator.
  void _onKeyPressed(String key) {
    setState(() {
      if (key == '<') {
        _deleteLastCharacter();
      } else if (key == '=') {
        _evaluateCurrentLine();
      } else if (key == 'c') {
        _clearHistoryAndCurrentLine();
      } else if (key == '±') {
        _toggleSign();
      } else {
        _appendToCurrentLine(key);
      }
    });
  }

  // Toggles the sign of the last operand in the current operation.
  void _toggleSign() {
    if (_currentOperation.hasOperator) {
      return;
    }

    if (_currentOperation.lastOperand.isNotEmpty) {
      final lastOperand = _currentOperation.lastOperand;
      final value = double.tryParse(lastOperand) ?? 0;
      final toggledValue = (-value);

      if (toggledValue == 0) {
        _currentOperation = _currentOperation.clear();
      } else {
        final toggledOperand = (isDoubleInteger(toggledValue)
                ? toggledValue.toInt()
                : toggledValue)
            .toString();

        _currentOperation =
            _currentOperation.replaceLastOperand(toggledOperand);
      }
    } else {
      _currentOperation = _currentOperation.append('-');
      _currentOperation = _currentOperation.append('0');
    }
  }

  /// Clears the history and the current operation.
  void _clearHistoryAndCurrentLine() {
    _currentOperation = _currentOperation.clear();
    _history.clear();
  }

  /// Deletes the last character from the current operation.
  void _deleteLastCharacter() {
    _currentOperation = _currentOperation.deleteLastCharacter();
  }

  // Evaluates the current operation and adds the result to the history.
  void _evaluateCurrentLine() {
    if (!_currentOperation.isValid) {
      // If the current operation does not contain any operators,
      // don't evaluate and don't add to history
      return;
    }

    try {
      // Evaluate the current operation and add it to the history
      final result = _currentOperation.evaluate();
      _history.add(result);
      _currentOperation = TSimpleOperation(operands: [result.result!]);
    } catch (e) {
      // If there was an error, clear the current operation and
      // don't add it to the history
      _currentOperation = _currentOperation.clear();
    }
  }

  // Appends the pressed key to the current operation.
  void _appendToCurrentLine(String key) {
    if (_currentOperation.length >= widget.maxOperationLength) {
      return;
    }

    if (isOperator(key) && _currentOperation.isValid) {
      // If the current operation already contains an operator,
      // don't append the new operator
      _evaluateCurrentLine();
      _appendToCurrentLine(key);

      return;
    }

    _currentOperation = _currentOperation.append(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FastDigitCalculatorDisplay(
              scrollController: _scrollController,
              operation: _currentOperation,
              history: _history,
            ),
          ),
          FastDigitCalculatorKeyboard(onKeyPressed: _onKeyPressed)
        ],
      ),
    );
  }
}
