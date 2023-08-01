// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:tmodel/tmodel.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

void main() {
  group('FastNotificationCenterOptions', () {
    late FastNotificationCenterOptions options1;
    late FastNotificationCenterOptions options2;
    const leadingIcon = Text('test');
    const iconColor = Colors.red;

    setUp(() {
      options1 = const FastNotificationCenterOptions();

      options2 = const FastNotificationCenterOptions(
        iconSize: 20,
        leadingIcon: leadingIcon,
        iconColor: iconColor,
      );
    });

    group('#constructor()', () {
      test('should be an instance of TModel', () {
        expect(options1, isA<TModel>());
      });

      test('properties should be equal to null by default', () {
        expect(options1.leadingIcon, equals(null));
        expect(options1.iconColor, equals(null));
        expect(options1.iconSize, equals(null));
      });
    });

    group('#copyWith()', () {
      test(
          'should return a copy of a FastNotificationCenterOptions object '
          'according to the given parameters', () {
        var copy = options1.copyWith(iconSize: 42);

        expect(copy.iconSize, equals(42));
        expect(copy.leadingIcon, equals(null));
        expect(copy.iconColor, equals(null));

        copy = options1.copyWith(
          iconSize: 42,
          leadingIcon: leadingIcon,
        );

        expect(copy.iconSize, equals(42));
        expect(copy.leadingIcon, equals(leadingIcon));
        expect(copy.iconColor, equals(null));

        copy = options1.copyWith(
          iconSize: 42,
          leadingIcon: leadingIcon,
          iconColor: iconColor,
        );

        expect(copy.iconSize, equals(42));
        expect(copy.leadingIcon, equals(leadingIcon));
        expect(copy.iconColor, equals(iconColor));
      });
    });

    group('#clone()', () {
      test('should return a copy of a FastNotificationCenterOptions object',
          () {
        final copy = options2.clone();

        expect(copy.iconSize, equals(20));
        expect(copy.leadingIcon, equals(leadingIcon));
        expect(copy.iconColor, equals(iconColor));
      });
    });

    group('#merge()', () {
      test('should combine two FastNotificationCenterOptions objects', () {
        const options = FastNotificationCenterOptions(
          iconSize: 42,
        );

        final merged = options2.merge(options);

        expect(merged.iconSize, equals(42));
        expect(merged.leadingIcon, equals(leadingIcon));
        expect(merged.iconColor, equals(iconColor));
      });
    });

    group('#operator ==', () {
      test(
          'should return true '
          'when two FastNotificationCenterOptions objects are equal ', () {
        options1 = const FastNotificationCenterOptions(
          iconSize: 20,
          leadingIcon: leadingIcon,
          iconColor: iconColor,
        );

        options2 = const FastNotificationCenterOptions(
          iconSize: 20,
          leadingIcon: leadingIcon,
          iconColor: iconColor,
        );

        expect(options1 == options2, equals(true));
      });

      test(
          'should return false '
          'when two FastNotificationCenterOptions objects are unequal ', () {
        options1 = const FastNotificationCenterOptions(
          iconSize: 20,
          leadingIcon: leadingIcon,
          iconColor: iconColor,
        );

        options2 = const FastNotificationCenterOptions(
          iconSize: 42,
          leadingIcon: leadingIcon,
          iconColor: iconColor,
        );

        expect(options1 == options2, equals(false));
      });
    });
  });
}
