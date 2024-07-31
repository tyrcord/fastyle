// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tenhance/tenhance.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

// A custom Flutter widget for a calculator keyboard button
class FastDigitCalculatorKeyboardButton<T> extends StatelessWidget {
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

  /// Whether the button is enabled or not.
  ///
  /// If `true`, the button is enabled and can be interacted with. If `false`,
  /// the button is disabled and cannot be interacted with.
  final bool isEnabled;

  // Constants for button font sizes
  static const double kDesktopFontSize = kFastFontSize34;
  static const double kTabletFontSize = kFastFontSize24;
  static const double kHandsetFontSize = kFastFontSize18;

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
    this.flex = 1,
    this.highlightColor,
    this.textColor,
    this.icon,
    bool? isEnabled,
  }) : isEnabled = isEnabled ?? true;

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
          final screenSize = MediaQuery.sizeOf(context);
          final height = _calculateButtonHeight(mediaType, screenSize);

          return Container(
            padding: kFastEdgeInsets6,
            height: height,
            child: FastTextButton2(
              onTap: () => isEnabled ? onPressed(value) : null,
              backgroundColor: _getButtonBackgroundColor(context),
              isEnabled: isEnabled,
              textStyle: TextStyle(
                fontSize: fontSize,
                color: textColor,
              ),
              labelText: label,
              child: icon,
            ),
          );
        }),
      ),
    );
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
