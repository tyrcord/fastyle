// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

void main() {
  group('FastThemeBloc', () {
    late FastThemeBloc bloc1;
    late FastThemeBloc bloc2;

    setUp(() {
      WidgetsFlutterBinding.ensureInitialized();

      bloc1 = FastThemeBloc();
      bloc2 = FastThemeBloc(
        initialState: FastThemeBlocState(
          brightness: Brightness.dark,
        ),
      );
    });

    group('#constructor()', () {
      test('should be an instance of BidirectionalBloc', () {
        expect(bloc1, isA<BidirectionalBloc>());
      });

      test('should have a default state', () {
        expect(bloc1.currentState, isA<FastThemeBlocState>());
      });

      test('should allow to set an initial state', () {
        expect(bloc2.currentState.brightness, equals(Brightness.dark));
        expect(bloc2.currentState.themeMode, equals(ThemeMode.system));
      });
    });

    group('#mapEventToState()', () {
      test('should listen to events', () async {
        bloc1.addEvent(FastThemeBlocEvent.light());

        var state = await bloc1.onData.skip(1).first;
        expect(state.brightness, equals(Brightness.light));
        expect(state.themeMode, equals(ThemeMode.light));

        bloc1.addEvent(FastThemeBlocEvent.dark());

        state = await bloc1.onData.skip(1).first;
        expect(state.brightness, equals(Brightness.dark));
        expect(state.themeMode, equals(ThemeMode.dark));

        bloc1.addEvent(FastThemeBlocEvent.system());

        state = await bloc1.onData.skip(1).first;
        expect(state.themeMode, equals(ThemeMode.system));
        expect(
          state.brightness,
          equals(WidgetsBinding.instance.window.platformBrightness),
        );
      });
    });
  });
}
