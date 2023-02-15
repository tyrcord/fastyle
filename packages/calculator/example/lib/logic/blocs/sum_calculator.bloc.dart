import 'package:decimal/decimal.dart';

import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:fastyle_calculator_example/logic/logic.dart';
import 'package:flutter/material.dart';

class SumCalculatorBloc extends HydratedFastCalculatorBloc<
    FastCalculatorBlocEvent<SumCalculatorResults>,
    SumCalculatorBloState,
    SumCalculatorDocument,
    SumCalculatorResults> {
  SumCalculatorBloc({
    SumCalculatorBloState initialState = const FastCalculatorBlocState<
        SumCalculatorFields, SumCalculatorResults>(
      fields: SumCalculatorFields(),
      results: SumCalculatorResults(),
      extras: SumCalculatorBlocStateExtras(),
    ),
  }) : super(
          initialState: initialState,
          dataProvider: SumCalculatorDataProvider(),
        );

  @override
  Future<SumCalculatorDocument> retrieveDefaultCalculatorDocument() async {
    return const SumCalculatorDocument();
  }

  @override
  Future<SumCalculatorResults> compute() async {
    if (await isCalculatorStateValid()) {
      final fields = currentState.fields;
      final dNumberA = Decimal.tryParse(fields.numberA);
      final dNumberB = Decimal.tryParse(fields.numberB);

      // demo purpose
      await Future.delayed(const Duration(seconds: 2));

      if (dNumberA != null &&
          dNumberB != null &&
          dNumberA > Decimal.zero &&
          dNumberB > Decimal.zero) {
        return SumCalculatorResults(
          sum: (dNumberA + dNumberB).toStringAsFixed(2),
        );
      }
    }

    return const SumCalculatorResults();
  }

  @override
  Future<SumCalculatorBloState?> patchCalculatorState(
    String key,
    dynamic value,
  ) async {
    await patchCalculatorDocument(key, value);

    if (key == 'numberA') {
      final fields = currentState.fields.copyWith(
        numberA: value as String,
      );

      return currentState.copyWith(fields: fields);
    } else if (key == 'numberB') {
      final fields = currentState.fields.copyWith(
        numberB: value as String,
      );

      return currentState.copyWith(fields: fields);
    } else if (key == 'asyncValue') {
      // demo purpose
      return currentState;
    }

    return currentState;
  }

  @override
  Future<SumCalculatorDocument?> patchCalculatorDocument(
    String key,
    dynamic value,
  ) async {
    if (key == 'numberA') {
      return document.copyWith(numberA: value as String);
    } else if (key == 'numberB') {
      return document.copyWith(numberB: value as String);
    }

    return document;
  }

  @override
  Future<bool> isCalculatorStateValid() async {
    final fields = currentState.fields;
    final numberA = fields.numberA;
    final numberB = fields.numberB;

    return isDecimal(numberA) && isDecimal(numberB);
  }

  @override
  Future<void> shareCalculatorState() async {
    debugPrint('Number A: ${currentState.fields.numberA}');
    debugPrint('Number B: ${currentState.fields.numberB}');
    debugPrint('Sum: ${currentState.results.sum}');
  }

  @override
  Future<SumCalculatorResults> retrieveDefaultResult() async {
    return const SumCalculatorResults();
  }

  @override
  Stream<SumCalculatorBloState> mapEventToState(
    FastCalculatorBlocEvent event,
  ) async* {
    final eventType = event.type;

    if (eventType == FastCalculatorBlocEventType.custom) {
      final payload = event.payload!;

      if (payload.key == 'async') {
        yield currentState.copyWith(
          extras: currentState.extras!.merge(
            const SumCalculatorBlocStateExtras(isFetchingAsyncValue: true),
          ),
        );

        // no cancellable operations will go through
        // demo purpose
        await Future.delayed(const Duration(seconds: 3));

        addEvent(FastCalculatorBlocEvent.custom<SumCalculatorResults>(
          'asyncDone',
          value: '42',
        ));
      } else if (payload.key == 'asyncDone') {
        yield currentState.copyWith(
          extras: currentState.extras!.merge(
            SumCalculatorBlocStateExtras(
              asyncValue: payload.value as String,
              isFetchingAsyncValue: false,
            ),
          ),
        );

        addEvent(FastCalculatorBlocEvent.patchValue<SumCalculatorResults>(
          key: 'asyncValue',
          value: payload.value,
        ));
      }
    } else {
      yield* super.mapEventToState(event);
    }
  }

  @override
  Future<void> handleComputeError(error) {
    // TODO: implement handleComputeError
    throw UnimplementedError();
  }
}
