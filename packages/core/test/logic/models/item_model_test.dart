// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:tmodel/tmodel.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

void main() {
  group('FastItem', () {
    late FastItem item;
    late FastItem item2;
    const label1 = 'label1';
    const label2 = 'label2';
    const category1Text = 'category1';
    const descriptor = FastListItemDescriptor();

    const category = FastCategory(
      labelText: category1Text,
      valueText: category1Text,
    );

    setUp(() {
      item = FastItem(labelText: label1);
      item2 = FastItem(labelText: label2);
    });

    group('#constructor()', () {
      test('should be an instance of TModel', () {
        expect(item, isA<TModel>());
      });

      test('property isEnabled should be equal to true by default', () {
        expect(item.isEnabled, equals(true));
      });

      test('other properties should be equal to null by default', () {
        expect(item.normalizedLabelText, equals(null));
        expect(item.descriptionText, equals(null));
        expect(item.categories, equals(null));
        expect(item.descriptor, equals(null));
        expect(item.value, equals(null));
      });
    });

    group('#copyWith()', () {
      test(
          'should return a copy of a FastItem object '
          'according to the given parameters', () {
        var copy = item.copyWith(labelText: 'foo');

        expect(copy.labelText, equals('foo'));
        expect(copy.isEnabled, equals(true));
        expect(copy.normalizedLabelText, equals(null));
        expect(copy.descriptionText, equals(null));
        expect(copy.categories, equals(null));
        expect(copy.descriptor, equals(null));
        expect(copy.value, equals(null));

        copy = item.copyWith(labelText: 'foo', isEnabled: false);

        expect(copy.labelText, equals('foo'));
        expect(copy.isEnabled, equals(false));
        expect(copy.normalizedLabelText, equals(null));
        expect(copy.descriptionText, equals(null));
        expect(copy.categories, equals(null));
        expect(copy.descriptor, equals(null));
        expect(copy.value, equals(null));

        copy = item.copyWith(
          labelText: 'foo',
          isEnabled: false,
          normalizedLabelText: 'bar',
        );

        expect(copy.labelText, equals('foo'));
        expect(copy.isEnabled, equals(false));
        expect(copy.normalizedLabelText, equals('bar'));
        expect(copy.descriptionText, equals(null));
        expect(copy.categories, equals(null));
        expect(copy.descriptor, equals(null));
        expect(copy.value, equals(null));

        copy = item.copyWith(
          labelText: 'foo',
          isEnabled: false,
          normalizedLabelText: 'bar',
          descriptionText: 'qux',
        );

        expect(copy.labelText, equals('foo'));
        expect(copy.isEnabled, equals(false));
        expect(copy.normalizedLabelText, equals('bar'));
        expect(copy.descriptionText, equals('qux'));
        expect(copy.categories, equals(null));
        expect(copy.descriptor, equals(null));
        expect(copy.value, equals(null));

        copy = item.copyWith(
          labelText: 'foo',
          isEnabled: false,
          normalizedLabelText: 'bar',
          descriptionText: 'qux',
          categories: [category],
        );

        expect(copy.labelText, equals('foo'));
        expect(copy.isEnabled, equals(false));
        expect(copy.normalizedLabelText, equals('bar'));
        expect(copy.descriptionText, equals('qux'));
        expect(copy.categories, equals([category]));
        expect(copy.descriptor, equals(null));
        expect(copy.value, equals(null));

        copy = item.copyWith(
          labelText: 'foo',
          isEnabled: false,
          normalizedLabelText: 'bar',
          descriptionText: 'qux',
          categories: [category],
          descriptor: descriptor,
        );

        expect(copy.labelText, equals('foo'));
        expect(copy.isEnabled, equals(false));
        expect(copy.normalizedLabelText, equals('bar'));
        expect(copy.descriptionText, equals('qux'));
        expect(copy.categories, equals([category]));
        expect(copy.descriptor, equals(descriptor));
        expect(copy.value, equals(null));

        copy = item.copyWith(
          labelText: 'foo',
          isEnabled: false,
          normalizedLabelText: 'bar',
          descriptionText: 'qux',
          categories: [category],
          descriptor: descriptor,
          value: 42,
        );

        expect(copy.labelText, equals('foo'));
        expect(copy.isEnabled, equals(false));
        expect(copy.normalizedLabelText, equals('bar'));
        expect(copy.descriptionText, equals('qux'));
        expect(copy.categories, equals([category]));
        expect(copy.descriptor, equals(descriptor));
        expect(copy.value, equals(42));
      });
    });

    group('#clone()', () {
      test('should return a copy of a FastItem object', () {
        final copy = item.clone();

        expect(copy.labelText, equals(label1));
        expect(copy.isEnabled, equals(true));
        expect(copy.normalizedLabelText, equals(null));
        expect(copy.descriptionText, equals(null));
        expect(copy.categories, equals(null));
        expect(copy.descriptor, equals(null));
        expect(copy.value, equals(null));
      });
    });

    group('#merge()', () {
      test('should combine two FastItem objects', () {
        final copy = FastItem(
          labelText: label2,
          value: 42,
          categories: [category],
        );

        final merged = item2.merge(copy);

        expect(merged.labelText, equals(label2));
        expect(merged.isEnabled, equals(true));
        expect(merged.normalizedLabelText, equals(null));
        expect(merged.descriptionText, equals(null));
        expect(merged.categories, equals([category]));
        expect(merged.descriptor, equals(null));
        expect(merged.value, equals(42));
      });
    });

    group('#operator ==', () {
      test(
          'should return true '
          'when two FastListItemDescriptor objects are equal ', () {
        item = FastItem(
          labelText: 'foo',
          isEnabled: false,
          normalizedLabelText: 'bar',
          descriptionText: 'qux',
          categories: [category],
          descriptor: descriptor,
          value: 42,
        );

        item2 = FastItem(
          labelText: 'foo',
          isEnabled: false,
          normalizedLabelText: 'bar',
          descriptionText: 'qux',
          categories: [category],
          descriptor: descriptor,
          value: 42,
        );

        expect(item == item2, equals(true));
      });

      test(
          'should return false '
          'when two FastListItemDescriptor objects are unequal ', () {
        item = FastItem(
          labelText: 'foo',
          isEnabled: false,
          normalizedLabelText: 'bar',
          descriptionText: 'qux',
          categories: [category],
          descriptor: descriptor,
          value: 42,
        );

        item2 = FastItem(
          labelText: 'foo',
          isEnabled: false,
          normalizedLabelText: 'bar',
          descriptionText: 'qux',
          categories: [],
          descriptor: descriptor,
          value: 0,
        );

        expect(item == item2, equals(false));
      });
    });
  });
}
