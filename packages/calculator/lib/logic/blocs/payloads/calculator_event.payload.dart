import 'package:fastyle_calculator/fastyle_calculator.dart';

class FastCalculatorBlocEventPayload<R extends FastCalculatorResults> {
  // An optional string key used to update the calculator's state.
  final String? key;
  // A dynamic value used to update the calculator's state.
  final dynamic value;
  // The results of a computation.
  final R? results;
  // An error that occurred during initialization or computation.
  final dynamic error;

  const FastCalculatorBlocEventPayload({
    this.key,
    this.value,
    this.results,
    this.error,
  });
}
