// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

void main() {
  group('NumberInputFormatter', () {
    late NumberInputFormatter numberInputFormatter;

    const zeroAndDecimalSeparator = TextEditingValue(text: '0.');
    const hundred = TextEditingValue(text: '100');
    const foo = TextEditingValue(text: 'foo');
    const zero = TextEditingValue(text: '0');
    const empty = TextEditingValue(text: '');
    const bigNumberLength16 = TextEditingValue(text: '1234567890123456');
    const bigNumberLength17 = TextEditingValue(text: '12345678901234567');
    const bigNumber = TextEditingValue(text: '9007199254740992');
    const tooBigNumber = TextEditingValue(text: '9007199254740993');

    setUp(() {
      numberInputFormatter = NumberInputFormatter();
    });

    group('#constructor()', () {
      test('should be an instance of TextInputFormatter', () {
        expect(numberInputFormatter, isA<TextInputFormatter>());
      });
    });

    group('#formatEditUpdate', () {
      test('should return an empty string when the new value is empty', () {
        expect(
          numberInputFormatter.formatEditUpdate(hundred, empty).text,
          equals(''),
        );
      });

      test('should replace commas to periods', () {
        expect(
          numberInputFormatter
              .formatEditUpdate(
                const TextEditingValue(text: '0'),
                const TextEditingValue(text: '0,'),
              )
              .text,
          equals('0.'),
        );
      });

      test('should prefix a decimal separator with 0', () {
        expect(
          numberInputFormatter
              .formatEditUpdate(
                empty,
                const TextEditingValue(text: '.'),
              )
              .text,
          equals(zeroAndDecimalSeparator.text),
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(
                empty,
                const TextEditingValue(text: ','),
              )
              .text,
          equals(zeroAndDecimalSeparator.text),
        );
      });

      test('should not format a decimal number when not allowed', () {
        numberInputFormatter = NumberInputFormatter(
          allowDecimals: false,
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(zero, zeroAndDecimalSeparator)
              .text,
          equals(zero.text),
        );
      });

      test('should only format valid numbers', () {
        expect(
          numberInputFormatter.formatEditUpdate(hundred, foo).text,
          equals(hundred.text),
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(zero, zeroAndDecimalSeparator)
              .text,
          equals(zeroAndDecimalSeparator.text),
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(zero, const TextEditingValue(text: '0.0'))
              .text,
          equals('0.0'),
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(zero, const TextEditingValue(text: '0. 0'))
              .text,
          equals(zero.text),
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(
                zeroAndDecimalSeparator,
                const TextEditingValue(text: '0..'),
              )
              .text,
          equals(zeroAndDecimalSeparator.text),
        );
      });

      test('should not format too long numbers', () {
        expect(
          numberInputFormatter
              .formatEditUpdate(
                bigNumberLength16,
                bigNumberLength17,
              )
              .text,
          equals(bigNumberLength16.text),
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(
                bigNumberLength16,
                const TextEditingValue(text: '1234567890123456.'),
              )
              .text,
          equals(bigNumberLength16.text),
        );

        numberInputFormatter = NumberInputFormatter(maxLength: 5);

        expect(
          numberInputFormatter
              .formatEditUpdate(
                const TextEditingValue(text: '1234'),
                const TextEditingValue(text: '12345'),
              )
              .text,
          equals('12345'),
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(
                const TextEditingValue(text: '12345'),
                const TextEditingValue(text: '123456'),
              )
              .text,
          equals('12345'),
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(
                const TextEditingValue(text: '1234.'),
                const TextEditingValue(text: '1234.5'),
              )
              .text,
          equals('1234.5'),
        );
      });

      test('should not format too big numbers', () {
        expect(
          numberInputFormatter.formatEditUpdate(bigNumber, tooBigNumber).text,
          equals(bigNumber.text),
        );

        numberInputFormatter = NumberInputFormatter(maxValue: 100);

        expect(
          numberInputFormatter
              .formatEditUpdate(
                const TextEditingValue(text: '98'),
                const TextEditingValue(text: '99'),
              )
              .text,
          equals('99'),
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(
                const TextEditingValue(text: '99'),
                hundred,
              )
              .text,
          equals(hundred.text),
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(hundred, const TextEditingValue(text: '101'))
              .text,
          equals(hundred.text),
        );
      });

      test(
          'should  transfrom invalid numbers '
          'if transformInvalidNumber is set to true', () {
        expect(
          numberInputFormatter
              .formatEditUpdate(zero, const TextEditingValue(text: '00'))
              .text,
          equals(zero.text),
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(zero, const TextEditingValue(text: '010'))
              .text,
          equals('10'),
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(zero, const TextEditingValue(text: '00.'))
              .text,
          equals('0.'),
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(zero, const TextEditingValue(text: '010.'))
              .text,
          equals('10.'),
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(zero, const TextEditingValue(text: '00.01'))
              .text,
          equals('0.01'),
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(zero, const TextEditingValue(text: '010.01'))
              .text,
          equals('10.01'),
        );
      });

      test(
          'should not transfrom invalid numbers '
          'if transformInvalidNumber is set to false', () {
        numberInputFormatter = NumberInputFormatter(
          transformInvalidNumber: false,
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(
                zero,
                const TextEditingValue(text: '00'),
              )
              .text,
          equals('00'),
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(
                zero,
                const TextEditingValue(text: '010'),
              )
              .text,
          equals('010'),
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(
                zero,
                const TextEditingValue(text: '00.'),
              )
              .text,
          equals('00.'),
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(
                zero,
                const TextEditingValue(text: '010.'),
              )
              .text,
          equals('010.'),
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(zero, const TextEditingValue(text: '00.01'))
              .text,
          equals('00.01'),
        );

        expect(
          numberInputFormatter
              .formatEditUpdate(zero, const TextEditingValue(text: '010.01'))
              .text,
          equals('010.01'),
        );
      });
    });
  });
}
