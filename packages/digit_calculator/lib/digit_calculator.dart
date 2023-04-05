library fastyle_digit_calculator;

import 'digit_calculator_display.dart';
import 'package:flutter/material.dart';
import 'package:t_helpers/helpers.dart';
import 'digit_calculator_keyboard.dart';
import 'package:intl/intl.dart';

class FastDigitCalculator extends StatefulWidget {
  final Color? backgroundColor;

  const FastDigitCalculator({
    super.key,
    this.backgroundColor,
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
    try {
      // Evaluate the current operation and add it to the history
      final result = evaluateExpression(_currentOperation);
      final formattedResult = NumberFormat.decimalPattern().format(result);
      _history.add(_currentOperation);
      _currentOperation = formattedResult;
    } catch (e) {
      // If there was an error, clear the current operation and
      // don't add it to the history
      _currentOperation = '';
    }
  }

  void _appendToCurrentLine(String key) {
    // TODO: decide limit length
    if (_currentOperation.length >= 15) {
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