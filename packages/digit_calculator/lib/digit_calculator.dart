library fastyle_digit_calculator;

import 'ui/digit_calculator_display.dart';
import 'package:flutter/material.dart';
import 'package:t_helpers/helpers.dart';
import 'ui/digit_calculator_keyboard.dart';
import 'package:intl/intl.dart';

class FastDigitCalculator extends StatefulWidget {
  final Color? backgroundColor;
  final int maxLength;

  const FastDigitCalculator({
    super.key,
    this.backgroundColor,
    this.maxLength = 15,
  });

  @override
  FastDigitCalculatorState createState() => FastDigitCalculatorState();
}

class FastDigitCalculatorState extends State<FastDigitCalculator> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _history = [];
  String _currentOperation = '';

  void _onKeyPressed(String key) {
    setState(() {
      if (key == '<') {
        _deleteLastCharacter();
      } else if (key == '=') {
        _evaluateCurrentLine();
      } else if (key == 'c') {
        _clearHistoryAndCurrentLine();
      } else {
        _appendToCurrentLine(key);
      }
    });
  }

  bool _hasOperator(String operation) {
    return operation.contains(RegExp('[+\\-*/×÷]'));
  }

  void _clearHistoryAndCurrentLine() {
    _currentOperation = '';
    _history.clear();
  }

  void _deleteLastCharacter() {
    if (_currentOperation.isNotEmpty) {
      _currentOperation = _currentOperation.substring(
        0,
        _currentOperation.length - 1,
      );
    }
  }

  void _evaluateCurrentLine() {
    if (!_hasOperator(_currentOperation)) {
      // If the current operation does not contain any operators,
      // don't evaluate and don't add to history
      return;
    }

    try {
      // Evaluate the current operation and add it to the history
      final result = evaluateExpression(_currentOperation);
      final formattedResult = NumberFormat.decimalPattern().format(result);

      _history.add('$_currentOperation=$formattedResult');

      // FIXME: bug
      _currentOperation = formattedResult;
    } catch (e) {
      // If there was an error, clear the current operation and
      // don't add it to the history
      _currentOperation = '';
    }
  }

  void _appendToCurrentLine(String key) {
    if (_currentOperation.length >= widget.maxLength) {
      return;
    }

    if (key == '.') {
      if (_currentOperation.isEmpty) {
        _currentOperation = '0';
      } else if (_currentOperation.contains('.')) {
        return; // ignore duplicate dots
      }
    } else if (key == '0' &&
        _currentOperation.startsWith('0') &&
        !_currentOperation.contains('.')) {
      // ignore leading zeros before a number
      return;
    } else if (_hasOperator(_currentOperation) && _hasOperator(key)) {
      // If there are already two operators, evaluate the current operation
      // and add the pending operator to the next operation
      _evaluateCurrentLine();
      _currentOperation += key;
      return;
    }

    _currentOperation += key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FastDigitCalculatorDisplay(
              scrollController: _scrollController,
              currentOperation: _currentOperation,
              history: _history,
            ),
          ),
          FastDigitCalculatorKeyboard(onKeyPressed: _onKeyPressed)
        ],
      ),
    );
  }
}
