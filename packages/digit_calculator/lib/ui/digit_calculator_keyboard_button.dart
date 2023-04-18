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
        builder: (context, mediaType) {
          return _buildButton(context, mediaType);
        },
      ),
    );
  }

  // Private method to build the button UI
  Widget _buildButton(BuildContext context, FastMediaType mediaType) {
    final padding = _calculatePadding(mediaType);
    final height = _calculateHeight(mediaType);
    final fontSize = _calculateFontSize(mediaType);

    // Use a container to customize the height and padding of the button
    return Container(
      height: height,
      padding: padding,
      child: FastFilledButton(
        backgroundColor: _getBackgroundColor(context),
        highlightColor: _getHighlightColor(context),
        onTap: () => onPressed(value),
        elevation: buttonElevation,
        textColor: textColor,
        fontSize: fontSize,
        text: label,
        child: icon,
      ),
    );
  }

  // Private method to determine the button's highlight color
  Color _getHighlightColor(BuildContext context) {
    if (highlightColor != null) {
      return highlightColor!;
    }

    final texts = ThemeHelper.texts;
    final color = textColor ?? texts.getBodyTextStyle(context).color!;

    return lightenColor(color, 0.25);
  }

  // Private method to determine the button's background color
  Color _getBackgroundColor(BuildContext context) {
    final colors = ThemeHelper.colors;

    return backgroundColor ??
        darkenColor(colors.getTertiaryBackgroundColor(context), 0.01);
  }

  // Private method to calculate the button's padding based on the media type
  EdgeInsetsGeometry _calculatePadding(FastMediaType mediaType) {
    if (mediaType >= FastMediaType.desktop) {
      return kFastEdgeInsets24;
    } else if (mediaType >= FastMediaType.tablet) {
      return kFastEdgeInsets12;
    } else {
      return kFastEdgeInsets8;
    }
  }

  // Private method to calculate the button's height based on the media type
  double _calculateHeight(FastMediaType mediaType) {
    var height = 80.0;

    if (mediaType >= FastMediaType.desktop) {
      height += 64;
    } else if (mediaType >= FastMediaType.tablet) {
      height += 32;
    }

    return height;
  }

  // Private method to calculate the button's font size based on the media type
  double _calculateFontSize(FastMediaType mediaType) {
    if (mediaType >= FastMediaType.desktop) {
      return 28.0;
    } else if (mediaType >= FastMediaType.tablet) {
      return 22.0;
    } else {
      return 20.0;
    }
  }
}
