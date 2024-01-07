// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:intl/intl.dart';

//TODO: @need-review: code from fastyle_dart

///
/// TextInputFormatter for numbers validation and formatting.
///
/// FIXME: Only support period decimal separator and english locale.
class NumberInputFormatter extends TextInputFormatter {
  ///
  /// Specifies whether to allow transformation of invalid numbers.
  ///
  final bool transformInvalidNumber;

  ///
  /// Specifies whether to allow decimal values.
  ///
  final bool allowDecimals;

  ///
  /// Specifies the maximum number of digits allowed.
  ///
  final int maxLength;

  ///
  /// Represents the largest possible value.
  ///
  final int maxValue;

  static const int safeInteger = 9007199254740992; // 2^53
  static const String defaultLocale = 'en_US';
  static const int safeIntegerMaxLength = 16;

  static const String _defaultDecimalSeparator = '.';
  static const String _commaDecimalSeparator = ',';

  static final RegExp _integerRegExp = RegExp(r'^\d*$');
  static final RegExp _periodRegExp = RegExp('\\.');
  static final RegExp _commaRegExp = RegExp(',');

  static TextEditingValue? _zeroTextEditingValue;
  static NumberFormat? _defaultNumberFormat;

  static NumberFormat get _defaultNumberFormatter {
    _defaultNumberFormat ??= NumberFormat.decimalPattern(defaultLocale);

    return _defaultNumberFormat!;
  }

  static TextEditingValue get _prefixedDecimalSeprator {
    _zeroTextEditingValue ??= TextEditingValue(
      text: NumberFormat('0.', defaultLocale).format(0),
      selection: const TextSelection(baseOffset: 2, extentOffset: 2),
    );

    return _zeroTextEditingValue!;
  }

  NumberInputFormatter({
    this.maxLength = NumberInputFormatter.safeIntegerMaxLength,
    this.maxValue = NumberInputFormatter.safeInteger,
    this.transformInvalidNumber = true,
    this.allowDecimals = true,
  })  : assert(maxValue <= NumberInputFormatter.safeInteger),
        assert(maxLength <= NumberInputFormatter.safeIntegerMaxLength);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var valueText = newValue.text;

    if (valueText.isEmpty) {
      return newValue;
    }

    valueText = _sanitizeDecimalSeparatorIfNeeded(valueText);

    if (allowDecimals && valueText == _defaultDecimalSeparator) {
      return allowDecimals ? _prefixedDecimalSeprator : oldValue;
    }

    if (!_isNumber(valueText)) {
      return oldValue;
    }

    final periods = _periodRegExp.allMatches(valueText);

    if (periods.length > 1) {
      return oldValue;
    }

    if (_isStringTooLong(valueText)) {
      return oldValue;
    }

    num? number;

    try {
      number = _defaultNumberFormatter.parse(valueText);
      // ignore: empty_catches
    } catch (e) {}

    if (number != null) {
      if (number > maxValue) return oldValue;

      final text = _formatNumberToString(number, valueText, periods.isNotEmpty);

      //  Calculate the new cursor position
      int cursorPosition = newValue.selection.baseOffset;
      cursorPosition = min(cursorPosition, text.length);

      return TextEditingValue(
        selection: TextSelection.collapsed(offset: cursorPosition),
        text: text,
      );
    }

    return oldValue;
  }

  bool _isStringTooLong(String text) {
    final decimalSeparatorPosition = text.indexOf(
      _defaultDecimalSeparator,
    );

    var textLength = text.length;

    if (decimalSeparatorPosition > -1 && decimalSeparatorPosition < maxLength) {
      --textLength;
    }

    return textLength > maxLength;
  }

  bool _isNumber(
    String number, {
    String decimalSeparator = _defaultDecimalSeparator,
  }) {
    final regExp = allowDecimals
        ? RegExp('^\\d*(\\$decimalSeparator?\\d*)?\$')
        : _integerRegExp;

    return regExp.hasMatch(number);
  }

  String _sanitizeDecimalSeparatorIfNeeded(String text) {
    if (allowDecimals && text.contains(_commaDecimalSeparator)) {
      text = text.replaceFirst(_commaRegExp, _defaultDecimalSeparator);
    }

    return text;
  }

  String _formatNumberToString(num number, String raw, bool isDecimal) {
    if (transformInvalidNumber) {
      if (isDecimal && allowDecimals) {
        final numberParts = raw.split(_defaultDecimalSeparator);
        final integerPart = numberParts[0];
        final fractionalPart = numberParts[1];
        final fractionalLength = fractionalPart.length;

        if (fractionalLength > 0) {
          // [integer].[fractional]
          return _formatDecimalNumberToString(
            number.toStringAsFixed(fractionalLength),
            decimalSeparator: _defaultDecimalSeparator,
          );
        } else {
          // [integer].
          return '${int.tryParse(integerPart) ?? 0}$_defaultDecimalSeparator';
        }
      } else {
        // [interger]
        return number.toStringAsFixed(0);
      }
    }

    return raw;
  }

  String _formatDecimalNumberToString(
    String value, {
    String decimalSeparator = _defaultDecimalSeparator,
  }) {
    if (decimalSeparator != _defaultDecimalSeparator) {
      final numberParts = value.split(_defaultDecimalSeparator);
      final integerPart = numberParts[0];
      final fractionalPart = numberParts[1];

      if (numberParts.length > 1) {
        var pattern = '';

        for (var i = 0; i < integerPart.length; i++) {
          pattern += '0';
        }

        pattern += _defaultDecimalSeparator;

        for (var i = 0; i < fractionalPart.length; i++) {
          pattern += '0';
        }

        final numberFormatter = NumberFormat(pattern, defaultLocale);

        return numberFormatter.format(double.tryParse(value));
      }
    }

    return value;
  }
}
