// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:tmodel/tmodel.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

void main() {
  group('FastCategory', () {
    late FastCategory category1;
    late FastCategory category2;
    const category1Text = 'category1';
    const category2Text = 'category2';

    setUp(() {
      category1 = FastCategory(
        weight: 1,
        labelText: category1Text,
        valueText: category1Text,
      );

      category2 = FastCategory(
        weight: 2,
        labelText: category2Text,
        valueText: category2Text,
      );
    });

    group('#constructor()', () {
      test('should be an instance of TModel', () {
        expect(category1, isA<TModel>());
      });

      test('property weight should be equal to 0.0 by default', () {
        final category = FastCategory(
          labelText: category2Text,
          valueText: category2Text,
        );

        expect(category.weight, equals(0.0));
      });
    });

    group('#copyWith()', () {
      test(
          'should return a copy of a FastCategory object '
          'according to the given parameters', () {
        final copy = category1.copyWith(weight: 42);

        expect(copy.weight, equals(42));
        expect(copy.labelText, equals(category1Text));
        expect(copy.valueText, equals(category1Text));

        final copy2 = category1.copyWith(labelText: category2Text);

        expect(copy2.weight, equals(1));
        expect(copy2.labelText, equals(category2Text));
        expect(copy2.valueText, equals(category1Text));

        final copy3 = category1.copyWith(valueText: category2Text);

        expect(copy3.weight, equals(1));
        expect(copy3.labelText, equals(category1Text));
        expect(copy3.valueText, equals(category2Text));
      });
    });

    group('#clone()', () {
      test('should return a copy of a FastCategory object', () {
        final copy = category1.clone();

        expect(copy.weight, equals(1));
        expect(copy.labelText, equals(category1Text));
        expect(copy.valueText, equals(category1Text));
      });
    });

    group('#merge()', () {
      test('should combine two FastCategory objects', () {
        final copy = FastCategory(
          labelText: 'foo',
          valueText: category2Text,
        );

        final merged = category2.merge(copy);

        expect(merged.weight, equals(0));
        expect(merged.labelText, equals('foo'));
        expect(merged.valueText, equals(category2Text));
      });
    });

    group('#operator ==', () {
      test(
          'should return true '
          'when two FastCategory objects are equal ', () {
        category1 = FastCategory(
          weight: 1,
          labelText: category2Text,
          valueText: category2Text,
        );

        category2 = FastCategory(
          weight: 1,
          labelText: category2Text,
          valueText: category2Text,
        );

        expect(category1 == category2, equals(true));
      });

      test(
          'should return false '
          'when two FastCategory objects are unequal ', () {
        category1 = FastCategory(
          weight: 1,
          labelText: category2Text,
          valueText: category2Text,
        );

        category2 = FastCategory(
          weight: 2,
          labelText: category2Text,
          valueText: category2Text,
        );

        expect(category1 == category2, equals(false));
      });
    });
  });
}
