import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'digit_calculator_keyboard_listener.dart';
import 'digit_calculator_keyboard_button.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';

/// This class defines a calculator keyboard
class FastDigitCalculatorKeyboard extends StatelessWidget {
  /// A function that is called when a key is pressed on the keyboard
  final Function(String) onKeyPressed;

  /// The background color of the keyboard (optional)
  final Color? backgroundColor;

  const FastDigitCalculatorKeyboard({
    super.key,
    required this.onKeyPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // The overall container for the keyboard, with a secondary background color
    return Container(
      color: ThemeHelper.colors.getSecondaryBackgroundColor(context),
      child: FastDigitCalculatorKeyboardListener(
        onKeyPressed: onKeyPressed,
        child: Container(
          decoration: BoxDecoration(
            color: _getBackgroundColor(context),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              // Padding for the rows of keys
              padding:
                  const EdgeInsets.symmetric(vertical: 28.0, horizontal: 16),
              child: Column(
                // The rows of keys on the keyboard
                children: [
                  _buildRow1(context),
                  _buildRow2(context),
                  _buildRow3(context),
                  _buildRow4(context),
                  _buildRow5(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Builds the first row of the calculator keyboard, including the 'AC', 'delete',
  Widget _buildRow1(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildClearButton(context),
        _buildDeleteButton(context),
        _buildPlusMinusButton(context),
        _buildDivideButton(context),
      ],
    );
  }

  // Builds the second row of the calculator keyboard, including the '7', '8', '9',
  Widget _buildRow2(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNumberButton('7'),
        _buildNumberButton('8'),
        _buildNumberButton('9'),
        _buildMultiplyButton(context),
      ],
    );
  }

  // Builds the third row of the calculator keyboard, including the '4', '5', '6',
  Widget _buildRow3(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNumberButton('4'),
        _buildNumberButton('5'),
        _buildNumberButton('6'),
        _buildMinusButton(context),
      ],
    );
  }

  // Builds the fourth row of the calculator keyboard, including the '1', '2', '3',
  Widget _buildRow4(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNumberButton('1'),
        _buildNumberButton('2'),
        _buildNumberButton('3'),
        _buildPlusButton(context),
      ],
    );
  }

  // Builds the fifth row of the calculator keyboard, including the '0', '.', and
  Widget _buildRow5(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNumberButton('0', flex: 2),
        _buildNumberButton('.'),
        _buildEqualsButton(context),
      ],
    );
  }

  // Builds a numeric button with the provided value and optional flex parameter
  Widget _buildNumberButton(String value, {int flex = 1}) {
    return _buildKeyboardButton(value, flex: flex);
  }

  // Builds the All Clear (AC) button with a value "c" and a 'AC label
  Widget _buildClearButton(BuildContext context) {
    return _buildKeyboardButton(
      'c',
      textColor: _getMintColor(context),
      label: 'AC',
    );
  }

  // Builds the backspace button with a value "<" and a deleteLeft icon
  Widget _buildDeleteButton(BuildContext context) {
    return _buildKeyboardButton(
      '<',
      icon: FaIcon(
        FontAwesomeIcons.deleteLeft,
        color: _getMintColor(context),
        size: 16,
      ),
    );
  }

  // Builds the plus-minus button with a value "±" and a plus-minus icon
  Widget _buildPlusMinusButton(BuildContext context) {
    return _buildKeyboardButton(
      '±',
      icon: FaIcon(
        FontAwesomeIcons.plusMinus,
        color: _getMintColor(context),
        size: 16,
      ),
    );
  }

  // Builds the division button with a value "÷" and a division icon
  Widget _buildDivideButton(BuildContext context) {
    return _buildKeyboardButton(
      '÷',
      icon: FaIcon(
        FontAwesomeIcons.divide,
        size: 16,
        color: _getPinkColor(context),
      ),
    );
  }

  // Builds the multiplication button with a value "×" and a multiplication icon
  Widget _buildMultiplyButton(BuildContext context) {
    return _buildKeyboardButton(
      '×',
      icon: FaIcon(
        FontAwesomeIcons.xmark,
        size: 16,
        color: _getPinkColor(context),
      ),
    );
  }

  // Builds the subtraction button with a value "-" and a subtraction icon
  Widget _buildMinusButton(BuildContext context) {
    return _buildKeyboardButton(
      '-',
      icon: FaIcon(
        FontAwesomeIcons.minus,
        size: 16,
        color: _getPinkColor(context),
      ),
    );
  }

  // Builds the addition button with a value "+" and a addition icon
  Widget _buildPlusButton(BuildContext context) {
    return _buildKeyboardButton(
      '+',
      icon: FaIcon(
        FontAwesomeIcons.plus,
        color: _getPinkColor(context),
        size: 16,
      ),
    );
  }

  // Builds the equals button with a value "=" and a equals icon
  Widget _buildEqualsButton(BuildContext context) {
    return _buildKeyboardButton(
      '=',
      icon: FaIcon(
        FontAwesomeIcons.equals,
        size: 16,
        color: _getPinkColor(context),
      ),
    );
  }

  // This is a helper method that generates a CalculatorKeyboardButton with
  Widget _buildKeyboardButton(
    String value, {
    int flex = 1, // optional parameter with default value of 1
    Color? textColor, // optional parameter with null safety
    String? label, // optional parameter with null safety
    Widget? icon, // optional parameter with null safety
  }) {
    // If the icon and label parameters are both null,
    // use the value parameter as the label
    if (icon == null && label == null) {
      label = value;
    }

    // Return a new CalculatorKeyboardButton object with the provided parameters
    return FastDigitCalculatorKeyboardButton<String>(
      // a function that will be called when the button is pressed
      onPressed: onKeyPressed,
      textColor: textColor, // the text color of the button
      label: label, // the text displayed on the button
      value: value, // the value returned by the button when pressed
      icon: icon, // the icon displayed on the button (if any)
      flex: flex, // the flex property of the button
    );
  }

  // This helper method returns a color representing a shade of teal in
  Color _getMintColor(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);
    return palette.teal.light;
  }

  // This helper method returns a color representing a shade of pink in
  Color _getPinkColor(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);
    return palette.pink.light;
  }

  // This helper method returns the tertiary background color in
  Color _getBackgroundColor(BuildContext context) {
    final colors = ThemeHelper.colors;

    // If the backgroundColor parameter is not null, return its value
    if (backgroundColor != null) {
      return backgroundColor!;
    }

    // Otherwise, return the tertiary background color from
    // the current color palette
    return colors.getTertiaryBackgroundColor(context);
  }
}
