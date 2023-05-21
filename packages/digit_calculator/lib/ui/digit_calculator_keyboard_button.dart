import 'dart:math';

import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';
import 'package:t_helpers/helpers.dart';

// A custom Flutter widget for a calculator keyboard button
class FastDigitCalculatorKeyboardButton<T> extends StatelessWidget {
  /// The elevation of the button
  final double buttonElevation;

  /// The function to call when the button is pressed
  final Function(T) onPressed;

  /// The background color of the button
  final Color? backgroundColor;

  /// The highlight color of the button
  final Color? highlightColor;

  /// The text color of the button
  final Color? textColor;

  /// The label to display on the button
  final String? label;

  /// The icon to display on the button
  final Widget? icon;

  /// The flex value to use for the button's `Expanded` widget
  final int flex;

  /// The value associated with the button
  final T value;

  // Constants for button font sizes
  static const double kDesktopFontSize = 28.0;
  static const double kTabletFontSize = 22.0;
  static const double kHandsetFontSize = 18.0;

  // Constants for button heights
  static const double kMinHeight = 64.0;
  static const double kMaxHeight = 96.0;

  // Constructor for FastDigitCalculatorKeyboardButton
  const FastDigitCalculatorKeyboardButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.value,
    this.backgroundColor,
    this.buttonElevation = 0,
    this.flex = 1,
    this.highlightColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Use Expanded to fill the available space
    return Expanded(
      flex: flex,
      child: FastMediaLayoutBuilder(
        // Build the button based on the media type (desktop, tablet, or mobile)
        builder: (context, mediaType) => _buildButton(context, mediaType),
      ),
    );
  }

  // Private method to build the button UI
  Widget _buildButton(BuildContext context, FastMediaType mediaType) {
    final fontSize = _calculateButtonFontSize(mediaType);

    // Use a container to customize the height and padding of the button
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (notification) => true,
      child: SizeChangedLayoutNotifier(
        child: Builder(builder: (context) {
          final screenSize = MediaQuery.of(context).size;
          final height = _calculateButtonHeight(mediaType, screenSize);

          return Container(
            padding: kFastEdgeInsets6,
            height: height,
            child: FastFilledButton(
              highlightColor: _getButtonHighlightColor(context),
              backgroundColor: _getButtonBackgroundColor(context),
              onTap: () => onPressed(value),
              elevation: buttonElevation,
              textColor: textColor,
              fontSize: fontSize,
              padding: EdgeInsets.zero,
              text: label,
              child: icon,
            ),
          );
        }),
      ),
    );
  }

  // Private method to determine the button's highlight color
  Color _getButtonHighlightColor(BuildContext context) {
    if (highlightColor != null) {
      return highlightColor!;
    }

    final texts = ThemeHelper.texts;
    final color = textColor ?? texts.getBodyTextStyle(context).color!;

    return lightenColor(color, 0.25);
  }

  // Private method to determine the button's background color
  Color _getButtonBackgroundColor(BuildContext context) {
    final colors = ThemeHelper.colors;

    return backgroundColor ??
        darkenColor(colors.getTertiaryBackgroundColor(context), 0.01);
  }

  // Private method to calculate the button's height based on the media type
  double _calculateButtonHeight(FastMediaType mediaType, Size size) {
    var height = size.height * 0.1;
    height = min(max(kMinHeight, height), kMaxHeight);

    return height;
  }

  // Private method to calculate the button's font size based on the media type
  double _calculateButtonFontSize(FastMediaType mediaType) {
    if (mediaType >= FastMediaType.desktop) {
      return kDesktopFontSize;
    } else if (mediaType >= FastMediaType.tablet) {
      return kTabletFontSize;
    }

    return kHandsetFontSize;
  }
}
