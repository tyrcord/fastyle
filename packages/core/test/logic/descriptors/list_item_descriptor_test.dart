// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

void main() {
  group('FastListItemDescriptor', () {
    late FastListItemDescriptor itemDescriptor;
    late FastListItemDescriptor itemDescriptor2;
    final trailing = Text('trailing');
    final leading = Text('leading');
    final leading2 = Text('leading2');
    final trailing2 = Text('trailing2');

    setUp(() {
      itemDescriptor = FastListItemDescriptor();
      itemDescriptor2 = FastListItemDescriptor(
        leading: leading,
        trailing: trailing,
      );
    });

    group('#constructor()', () {
      test('should be an instance of FastDescriptor', () {
        expect(itemDescriptor, isA<FastDescriptor>());
      });

      test('property isDense should be equal to true by default', () {
        expect(itemDescriptor.isDense, equals(true));
      });

      test('property leading should be equal to null by default', () {
        expect(itemDescriptor.leading, equals(null));
      });

      test('property trailing should be equal to null by default', () {
        expect(itemDescriptor.trailing, equals(null));
      });
    });

    group('#copyWith()', () {
      test(
          'should return a copy of a FastListItemDescriptor object '
          'according to the given parameters', () {
        final copy = itemDescriptor2.copyWith(isDense: false);

        expect(copy.isDense, equals(false));
        expect(copy.trailing, equals(trailing));
        expect(copy.leading, equals(leading));

        final copy2 = itemDescriptor2.copyWith(leading: leading2);

        expect(copy2.isDense, equals(true));
        expect(copy2.trailing, equals(trailing));
        expect(copy2.leading, equals(leading2));

        final copy3 = itemDescriptor2.copyWith(trailing: trailing2);

        expect(copy3.isDense, equals(true));
        expect(copy3.trailing, equals(trailing2));
        expect(copy3.leading, equals(leading));
      });
    });

    group('#clone()', () {
      test('should return a copy of a FastListItemDescriptor object', () {
        final copy = itemDescriptor2.clone();

        expect(copy.isDense, equals(true));
        expect(copy.trailing, equals(trailing));
        expect(copy.leading, equals(leading));
      });
    });

    group('#merge()', () {
      test('should combine two FastListItemDescriptor objects', () {
        final copy = itemDescriptor.copyWith(
          isDense: false,
          trailing: trailing2,
        );

        final merged = itemDescriptor2.merge(copy);

        expect(merged.isDense, equals(false));
        expect(merged.trailing, equals(trailing2));
        expect(merged.leading, equals(leading));
      });
    });

    group('#operator ==', () {
      test(
          'should return true '
          'when two FastListItemDescriptor objects are equal ', () {
        itemDescriptor = FastListItemDescriptor(
          leading: leading2,
          trailing: trailing2,
        );

        itemDescriptor2 = FastListItemDescriptor(
          leading: leading2,
          trailing: trailing2,
        );

        expect(itemDescriptor == itemDescriptor2, equals(true));
      });

      test(
          'should return false '
          'when two FastListItemDescriptor objects are unequal ', () {
        itemDescriptor = FastListItemDescriptor(
          leading: leading,
          trailing: trailing2,
        );

        itemDescriptor2 = FastListItemDescriptor(
          leading: leading2,
          trailing: trailing2,
        );

        expect(itemDescriptor == itemDescriptor2, equals(false));
      });
    });
  });
}
