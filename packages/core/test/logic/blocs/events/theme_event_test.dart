// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

void main() {
  group('FastThemeBlocEvent', () {
    late FastThemeBlocEvent event1;

    setUp(() {
      event1 = FastThemeBlocEvent(type: FastThemeBlocEventType.light);
    });

    group('#constructor()', () {
      test('should be an instance of BlocEvent', () {
        expect(event1, isA<BlocEvent>());
      });
    });

    group('#dark()', () {
      test('should return a FastThemeBlocEvent with the type dark', () {
        var event = FastThemeBlocEvent.dark();

        expect(event.type, equals(FastThemeBlocEventType.dark));
      });
    });

    group('#light()', () {
      test('should return a FastThemeBlocEvent with the type light', () {
        var event = FastThemeBlocEvent.light();

        expect(event.type, equals(FastThemeBlocEventType.light));
      });
    });

    group('#system()', () {
      test('should return a FastThemeBlocEvent with the type system', () {
        var event = FastThemeBlocEvent.system();

        expect(event.type, equals(FastThemeBlocEventType.system));
      });
    });
  });
}
