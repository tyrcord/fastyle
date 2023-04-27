import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fastyle_digit_calculator/digit_calculator.dart';
import 'package:fastyle_forms/fastyle_forms.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:t_helpers/helpers.dart';

/// A custom [StatefulWidget] that creates a number input field with a
/// calculator icon.
///
/// Tapping the calculator icon opens a digit calculator overlay.
class FastDigitCalculatorField extends StatefulWidget {
  // Called when the field value changes.
  final ValueChanged<String?>? onValueChanged;

  // Placeholder text for the input field.
  final String? placeholderText;

  // Caption text for the input field.
  final String? captionText;

  // Suffix icon for the input field.
  final Widget? suffixIcon;

  // Valid icon for the digit calculator overlay.
  final Widget? validIcon;

  // Close icon for the digit calculator overlay.
  final Widget closeIcon;

  // Label text for the input field.
  final String labelText;

  // Initial value text for the input field.
  final String valueText;

  // Determines if the input field is enabled.
  final bool isEnabled;

  /// Creates a new instance of [FastDigitCalculatorField].
  ///
  /// [labelText] is the label of the input field.
  /// [closeIcon], [isEnabled], and [valueText] are optional parameters.
  /// Other optional parameters include [placeholderText], [onValueChanged],
  /// [captionText], [suffixIcon], and [validIcon].
  const FastDigitCalculatorField({
    super.key,
    required this.labelText,
    this.closeIcon = kFastCloseIcon,
    this.isEnabled = true,
    this.valueText = '',
    this.placeholderText,
    this.onValueChanged,
    this.captionText,
    this.suffixIcon,
    this.validIcon,
  });

  @override
  State<FastDigitCalculatorField> createState() =>
      _FastDigitCalculatorFieldState();
}

/// The state for the [FastDigitCalculatorField] widget.
class _FastDigitCalculatorFieldState extends State<FastDigitCalculatorField> {
  // Holds the instance of the TSimpleOperation object.
  TSimpleOperation? _operation;

  @override
  Widget build(BuildContext context) {
    return FastNumberField(
      suffixIcon: GestureDetector(
        onTap: () => _handleOnTapCalculator(context),
        child: widget.suffixIcon ?? const FaIcon(FontAwesomeIcons.calculator),
      ),
      placeholderText: widget.placeholderText,
      onValueChanged: widget.onValueChanged,
      captionText: widget.captionText,
      isEnabled: widget.isEnabled,
      labelText: widget.labelText,
      valueText: widget.valueText,
    );
  }

  /// Handles tap on the calculator icon and opens the digit calculator overlay.
  Future<void> _handleOnTapCalculator(BuildContext context) async {
    if (widget.isEnabled) {
      await Navigator.push(
        context,
        CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (BuildContext context) {
            return FastFieldOverlayContainer(
              titleText: widget.labelText,
              closeIcon: widget.closeIcon,
              validIcon: widget.validIcon,
              willValid: _onValid,
              child: FastDigitCalculator(
                onValueChanged: _onValueChanged,
                valueText: widget.valueText,
              ),
            );
          },
        ),
      );
    }
  }

  /// Handles the value change event from the digit calculator.
  ///
  /// Stores the [TSimpleOperation] object in the [_operation] instance
  /// variable.
  void _onValueChanged(TSimpleOperation operation) {
    _operation = operation;
  }

  /// Validates the digit calculator overlay and updates the input field value.
  ///
  /// If the [_operation] instance variable is set, it evaluates the result and
  /// calls the [widget.onValueChanged] callback with the calculated result.
  void _onValid() {
    if (_operation != null) {
      widget.onValueChanged?.call(_operation?.evaluate().result);
    }
  }
}
