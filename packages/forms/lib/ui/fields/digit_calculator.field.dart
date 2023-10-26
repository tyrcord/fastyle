// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_digit_calculator/digit_calculator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:fastyle_forms/fastyle_forms.dart';

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

  // Label text for the input field.
  final String labelText;

  // Initial value text for the input field.
  final String valueText;

  // Determines if the input field is enabled.
  final bool isEnabled;

  final bool acceptDecimal;

  final FastRoundingMethod roundingMethod;

  /// Creates a new instance of [FastDigitCalculatorField].
  ///
  /// [labelText] is the label of the input field.
  /// [isEnabled], and [valueText] are optional parameters.
  /// Other optional parameters include [placeholderText], [onValueChanged],
  /// [captionText], [suffixIcon], and [validIcon].
  const FastDigitCalculatorField({
    super.key,
    required this.labelText,
    this.validIcon,
    this.isEnabled = true,
    String? valueText,
    this.placeholderText,
    this.onValueChanged,
    this.captionText,
    this.suffixIcon,
    bool? acceptDecimal = true,
    FastRoundingMethod? roundingMethod = FastRoundingMethod.round,
  })  : roundingMethod = roundingMethod ?? FastRoundingMethod.round,
        valueText = valueText ?? '',
        acceptDecimal = acceptDecimal ?? true;

  @override
  State<FastDigitCalculatorField> createState() =>
      _FastDigitCalculatorFieldState();
}

/// The state for the [FastDigitCalculatorField] widget.
class _FastDigitCalculatorFieldState extends State<FastDigitCalculatorField> {
  // Holds the instance of the TSimpleOperation object.
  TSimpleOperation? _operation;

  /// Handles the value change event from the digit calculator.
  ///
  /// Stores the [TSimpleOperation] object in the [_operation] instance
  /// variable.
  set operation(TSimpleOperation operation) => _operation = operation;

  @override
  Widget build(BuildContext context) {
    return FastNumberField(
      suffixIcon: GestureDetector(
        onTap: () => _handleOnTapCalculator(context),
        child: buildSuffixIcon(context),
      ),
      placeholderText: widget.placeholderText,
      onValueChanged: widget.onValueChanged,
      acceptDecimal: widget.acceptDecimal,
      captionText: widget.captionText,
      isEnabled: widget.isEnabled,
      labelText: widget.labelText,
      valueText: widget.valueText,
    );
  }

  Widget buildSuffixIcon(BuildContext context) {
    if (widget.suffixIcon != null) {
      return widget.suffixIcon!;
    }

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.thinCalculatorSimple);
    }

    return const FaIcon(FontAwesomeIcons.calculator);
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
              validIcon: _buildValidIcon(context),
              titleText: widget.labelText,
              willValid: _onValid,
              willClose: _onClose,
              child: FastDigitCalculator(
                onValueChanged: (op) => operation = op,
                valueText: widget.valueText,
              ),
            );
          },
        ),
      );
    }
  }

  Widget _buildValidIcon(BuildContext context) {
    if (widget.validIcon != null) return widget.validIcon!;

    final useProIcons = FastIconHelper.of(context).useProIcons;
    final palette = ThemeHelper.getPaletteColors(context);

    if (useProIcons) {
      return FaIcon(FastFontAwesomeIcons.lightCheck, color: palette.green.mid);
    }

    return FaIcon(FontAwesomeIcons.check, color: palette.green.mid);
  }

  /// Validates the digit calculator overlay and updates the input field value.
  ///
  /// If the [_operation] instance variable is set, it evaluates the result and
  /// calls the [widget.onValueChanged] callback with the calculated result.
  void _onValid() {
    if (_operation != null) {
      final operation = _operation!.evaluate();

      var result = operation.result;
      result ??= operation.lastOperand;

      if (result.isEmpty &&
          operation.hasOperator &&
          operation.operands.isNotEmpty) {
        result = operation.operands.first;
      }

      if (isStringNumber(result)) {
        widget.onValueChanged?.call(result);

        // Check if the result should be an integer and apply the specified
        // rounding method.
        if (!widget.acceptDecimal) {
          final number = double.parse(result);
          String roundedResult;

          switch (widget.roundingMethod) {
            case FastRoundingMethod.floor:
              roundedResult = number.floor().toString();
            default:
              roundedResult = number.ceil().toString();
          }

          widget.onValueChanged?.call(roundedResult);
        } else {
          widget.onValueChanged?.call(result);
        }
      }
    }

    _onClose();
  }

  /// Resets the [_operation] instance variable to null when the
  /// digit calculator overlay is closed.
  void _onClose() => _operation = null;
}
