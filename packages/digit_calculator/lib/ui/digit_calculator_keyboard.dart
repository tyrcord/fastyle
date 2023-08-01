// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'digit_calculator_keyboard_button.dart';
import 'digit_calculator_keyboard_listener.dart';

enum CustomButtonType {
  plusMinus,
  percent,
}

/// This class defines a calculator keyboard
class FastDigitCalculatorKeyboard extends StatelessWidget {
  /// A function that is called when a key is pressed on the keyboard
  final Function(String) onKeyPressed;

  /// The background color of the keyboard (optional)
  final Color? backgroundColor;

  /// The type of custom button to build (optional)
  final CustomButtonType? customButtonType;

  /// A `ValueNotifier` that holds a list of `TSimpleOperation` objects.
  /// Used to notify listeners whenever the history of operations changes.
  final ValueNotifier<TSimpleOperation> operationNotifier;

  const FastDigitCalculatorKeyboard({
    super.key,
    required this.onKeyPressed,
    required this.operationNotifier,
    this.backgroundColor,
    CustomButtonType? customButtonType,
  }) : customButtonType = customButtonType ?? CustomButtonType.percent;

  @override
  Widget build(BuildContext context) {
    // The overall container for the keyboard, with a secondary background color
    return ColoredBox(
      color: ThemeHelper.colors.getSecondaryBackgroundColor(context),
      child: FastDigitCalculatorKeyboardListener(
        onKeyPressed: onKeyPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _getBackgroundColor(context),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              // Padding for the rows of keys
              padding: kFastEdgeInsets16,
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

  // Builds the first row of the calculator keyboard, including the 'AC',
  // 'delete',
  Widget _buildRow1(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildClearButton(context),
        _buildDeleteButton(context),
        _buildCustomButton(context),
        _buildDivideButton(context),
      ],
    );
  }

  // Builds the second row of the calculator keyboard, including the '7', '8',
  // '9',
  Widget _buildRow2(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNumberButton(context, '7'),
        _buildNumberButton(context, '8'),
        _buildNumberButton(context, '9'),
        _buildMultiplyButton(context),
      ],
    );
  }

  // Builds the third row of the calculator keyboard, including the '4', '5',
  // '6',
  Widget _buildRow3(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNumberButton(context, '4'),
        _buildNumberButton(context, '5'),
        _buildNumberButton(context, '6'),
        _buildMinusButton(context),
      ],
    );
  }

  // Builds the fourth row of the calculator keyboard, including the '1', '2',
  // '3',
  Widget _buildRow4(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNumberButton(context, '1'),
        _buildNumberButton(context, '2'),
        _buildNumberButton(context, '3'),
        _buildPlusButton(context),
      ],
    );
  }

  // Builds the fifth row of the calculator keyboard, including the '0', '.',
  // and '=
  Widget _buildRow5(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNumberButton(context, '0', flex: 2),
        _buildNumberButton(context, '.'),
        _buildEqualsButton(context),
      ],
    );
  }

  // Builds a numeric button with the provided value and optional flex parameter
  Widget _buildNumberButton(
    BuildContext context,
    String value, {
    int flex = 1,
  }) {
    return _buildKeyboardButton(context, value, flex: flex);
  }

  // Builds the All Clear (AC) button with a value "c" and a 'AC label
  Widget _buildClearButton(BuildContext context) {
    return _buildKeyboardButton(
      context,
      'c',
      textColor: _getMintColor(context),
      label: 'AC',
    );
  }

  // Builds the backspace button with a value "<" and a deleteLeft icon
  Widget _buildDeleteButton(BuildContext context) {
    return _buildKeyboardButton(
      context,
      '<',
      icon: FaIcon(
        FontAwesomeIcons.deleteLeft,
        color: _getMintColor(context),
        size: 16,
      ),
    );
  }

  // Builds the division button with a value "÷" and a division icon
  Widget _buildDivideButton(BuildContext context) {
    return _buildKeyboardButton(
      context,
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
      context,
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
      context,
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
      context,
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
      context,
      '=',
      icon: FaIcon(
        FontAwesomeIcons.equals,
        size: 16,
        color: _getPinkColor(context),
      ),
    );
  }

  // Builds a custom button based on the provided CustomButtonType
  Widget _buildCustomButton(BuildContext context) {
    switch (customButtonType) {
      case CustomButtonType.plusMinus:
        return _buildPlusMinusButton(context);
      case CustomButtonType.percent:
        return _buildPercentButton(context);
      default:
        return const SizedBox.shrink();
    }
  }

  // Builds the plus-minus button with a value "±" and a plus-minus icon
  Widget _buildPlusMinusButton(BuildContext context) {
    return _buildKeyboardButton(
      context,
      '±',
      icon: FaIcon(
        FontAwesomeIcons.plusMinus,
        color: _getMintColor(context),
        size: 16,
      ),
    );
  }

  // Builds the percent button with a value "%" and a percent icon
  Widget _buildPercentButton(BuildContext context) {
    return ValueListenableBuilder<TSimpleOperation>(
      valueListenable: operationNotifier,
      builder: (context, operation, child) {
        final isEnabled = operation.isValid &&
            (operation.operator == '+' || operation.operator == '-');

        return _buildKeyboardButton(
          context,
          '%',
          isEnabled: isEnabled,
          icon: FaIcon(
            FontAwesomeIcons.percent,
            color: _getMintColor(context),
            size: 16,
          ),
        );
      },
    );
  }

  // This is a helper method that generates a CalculatorKeyboardButton with
  Widget _buildKeyboardButton(
    BuildContext context,
    String value, {
    int flex = 1, // optional parameter with default value of 1
    Color? textColor, // optional parameter with null safety
    String? label, // optional parameter with null safety
    Widget? icon, // optional parameter with null safety
    bool isEnabled = true, // optional parameter with default value of true
  }) {
    // If the icon and label parameters are both null,
    // use the value parameter as the label
    if (icon == null && label == null) {
      label = value;
    }

    if (icon is Icon && !isEnabled) {
      icon = Icon(
        icon.icon,
        color: ThemeHelper.colors.getDisabledColor(context),
        size: icon.size,
      );
    } else if (icon is FaIcon && !isEnabled) {
      icon = FaIcon(
        icon.icon,
        color: ThemeHelper.colors.getDisabledColor(context),
        size: icon.size,
      );
    }

    // Return a new CalculatorKeyboardButton object with the provided parameters
    return FastDigitCalculatorKeyboardButton<String>(
      // a function that will be called when the button is pressed
      onPressed: onKeyPressed,
      textColor: textColor, // the text color of the button
      isEnabled: isEnabled,
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
