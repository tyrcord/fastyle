import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// This class defines a listener for physical and logical keyboard events.
// It is designed to be used as a child of the CalculatorKeyboard widget to allow the
// calculator to receive keyboard events when it has focus.
class FastDigitCalculatorKeyboardListener extends StatefulWidget {
  /// A function that is called when a key is pressed on the keyboard
  final Function(String) onKeyPressed;

  /// The child widget of the keyboard listener
  final Widget child;

  const FastDigitCalculatorKeyboardListener({
    super.key,
    required this.onKeyPressed,
    required this.child,
  });

  @override
  FastDigitCalculatorKeyboardListenerState createState() =>
      FastDigitCalculatorKeyboardListenerState();
}

class FastDigitCalculatorKeyboardListenerState
    extends State<FastDigitCalculatorKeyboardListener> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKey: _handlePhysicalKeyPressed,
      focusNode: _focusNode,
      child: widget.child,
    );
  }

  // This method handles physical key presses in Flutter
  KeyEventResult _handlePhysicalKeyPressed(FocusNode node, RawKeyEvent event) {
    // Check if the received event is a key down event
    if (event is RawKeyDownEvent) {
      // Get the logical key associated with the event
      final logicalKey = event.logicalKey;
      // Pass the logical key to the _handleLogicalKey function to determine which action to take
      final result = _handleLogicalKey(logicalKey);

      // If the logical key was handled, return the result
      if (result != KeyEventResult.ignored) {
        return result;
      }
    }

    // If the event was not handled, return KeyEventResult.ignored
    return KeyEventResult.ignored;
  }

  // This function determines which action to take based on the logical key received
  // FIXME: add support for combinations of keys (e.g. shift + 8 = *)
  KeyEventResult _handleLogicalKey(LogicalKeyboardKey logicalKey) {
    KeyEventResult result = KeyEventResult.handled;

    // If the logical key represents a digit, extract the corresponding character from its label
    if (_isDigitKey(logicalKey)) {
      final digit = _getDigitFromKeyLabel(logicalKey.keyLabel);
      // Call the onKeyPressed callback provided by the parent widget with the digit
      widget.onKeyPressed(digit!);
    } else if (logicalKey == LogicalKeyboardKey.backspace) {
      // Call the onKeyPressed callback with the '<' character for the backspace key
      widget.onKeyPressed('<');
    } else if (logicalKey == LogicalKeyboardKey.enter ||
        logicalKey == LogicalKeyboardKey.equal ||
        logicalKey == LogicalKeyboardKey.numpadEnter) {
      // Call the onKeyPressed callback with the '=' character for the enter keys
      widget.onKeyPressed('=');
    } else if (logicalKey == LogicalKeyboardKey.minus ||
        logicalKey == LogicalKeyboardKey.numpadSubtract) {
      // Call the onKeyPressed callback with the '-' character for the minus keys
      widget.onKeyPressed('-');
    } else if (logicalKey == LogicalKeyboardKey.period ||
        logicalKey == LogicalKeyboardKey.numpadDecimal) {
      // Call the onKeyPressed callback with the '.' character for the period keys
      widget.onKeyPressed('.');
    } else if (logicalKey == LogicalKeyboardKey.numpadAdd) {
      // Call the onKeyPressed callback with the '+' character for the numpad plus key
      widget.onKeyPressed('+');
    } else if (logicalKey == LogicalKeyboardKey.slash ||
        logicalKey == LogicalKeyboardKey.numpadDivide) {
      // Call the onKeyPressed callback with the '/' character for the slash keys
      widget.onKeyPressed('÷');
    } else if (logicalKey == LogicalKeyboardKey.asterisk ||
        logicalKey == LogicalKeyboardKey.numpadMultiply) {
      // Call the onKeyPressed callback with the '×' character for the asterisk keys
      widget.onKeyPressed('×');
    } else if (logicalKey == LogicalKeyboardKey.keyC) {
      // Call the onKeyPressed callback with the 'c' character for the 'c' key
      widget.onKeyPressed('c');
    } else {
      // If the logical key was not handled, return KeyEventResult.ignored
      result = KeyEventResult.ignored;
    }

    return result;
  }

  // This function takes a key label and returns the digit contained in it (if any)
  // For example, if the key label is '1', the function will return '1'
  // If the key label is 'x', the function will return null
  String? _getDigitFromKeyLabel(String? keyLabel) {
    // Use a regular expression to search for the first digit in the key label
    final digitMatch = RegExp(r'\d').firstMatch(keyLabel ?? '');

    // If a digit was found, return it
    return digitMatch?.group(0);
  }

  // This function checks if a given logical key represents a digit
  bool _isDigitKey(LogicalKeyboardKey logicalKey) {
    return (logicalKey.keyId >= LogicalKeyboardKey.digit0.keyId &&
            logicalKey.keyId <= LogicalKeyboardKey.digit9.keyId) ||
        (logicalKey.keyId >= LogicalKeyboardKey.numpad0.keyId &&
            logicalKey.keyId <= LogicalKeyboardKey.numpad9.keyId);
  }
}
