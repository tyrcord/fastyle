library fastyle_digit_calculator;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'ui/digit_calculator_display.dart';
import 'ui/digit_calculator_keyboard.dart';

/// A Flutter widget that provides a digit calculator with a display
/// and keyboard.
///
/// The calculator provides basic arithmetic operations (+, -, *, /, %)
/// The display shows the current operation and the history of operations.
/// The keyboard provides buttons for input.
///
/// To use this widget, simply create a new instance of
/// the [FastDigitCalculator]
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
  /// The maximum length of the text that can be displayed in
  /// the calculator's display.
  final int maxOperationLength;

  // The callback that is called whenever the value of the calculator changes.
  final ValueChanged<TSimpleOperation>? onValueChanged;

  // The number to display in the calculator's display.
  final String? valueText;

  /// The maximum width of the calculator widget.
  ///
  /// If the width of the widget exceeds this value, it will be constrained to
  /// this value. If this value is not provided, the default value of 640 will
  /// be used.
  final double maxWidth;

  /// Creates a new instance of the [FastDigitCalculator] widget.
  ///
  /// The [maxOperationLength] parameter sets the maximum length of the text
  /// that can be displayed
  /// in the calculator's display.
  const FastDigitCalculator({
    super.key,
    this.maxOperationLength = 35,
    this.onValueChanged,
    this.valueText,
    double? maxWidth,
  }) : maxWidth = maxWidth ?? 640;

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
  List<TSimpleOperation> _history = [];

  // A `ValueNotifier` that holds a `TSimpleOperation` object.
  // Used to notify listeners whenever the current operation changes.
  final ValueNotifier<TSimpleOperation> operationNotifier = ValueNotifier(
    const TSimpleOperation(),
  );

  // A `ValueNotifier` that holds a list of `TSimpleOperation` objects.
  // Used to notify listeners whenever the history of operations changes.
  final ValueNotifier<List<TSimpleOperation>> historyNotifier = ValueNotifier(
    [],
  );

  @override
  void initState() {
    super.initState();
    final valueText = widget.valueText;

    if (valueText != null && isStringNumber(valueText)) {
      _currentOperation = _currentOperation.replaceLastOperand(valueText);
      operationNotifier.value = _currentOperation;
    }
  }

  // Called when a key is pressed on the calculator.
  void _onKeyPressed(String key) {
    if (key == '<') {
      _deleteLastCharacter();
    } else if (key == '=') {
      _evaluateCurrentLine();
    } else if (key == 'c') {
      _clearHistoryAndCurrentLine();
    } else if (key == '±') {
      _toggleSign();
    } else if (key == '%') {
      _appendPercent();
    } else {
      _appendToCurrentLine(key);
    }

    operationNotifier.value = _currentOperation;
    historyNotifier.value = _history;

    if (widget.onValueChanged != null) {
      widget.onValueChanged!(_currentOperation);
    }
  }

  // Appends a percent sign to the current operation.
  void _appendPercent() {
    final operator = _currentOperation.operator;

    if (_currentOperation.lastOperand.isNotEmpty &&
        _currentOperation.hasOperator &&
        (operator == '+' || operator == '-')) {
      _currentOperation = _currentOperation.copyWith(
        isLastOperandPercent: true,
      );

      _evaluateCurrentLine();
    }
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
    _history = [];
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
      _history = [..._history, result];
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
    return Ink(
      color: ThemeHelper.colors.getSecondaryBackgroundColor(context),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widget.maxWidth),
          child: Column(
            children: [
              Expanded(
                child: FastDigitCalculatorDisplay(
                  operationNotifier: operationNotifier,
                  scrollController: _scrollController,
                  historyNotifier: historyNotifier,
                ),
              ),
              FastDigitCalculatorKeyboard(
                onKeyPressed: _onKeyPressed,
                operationNotifier: operationNotifier,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
