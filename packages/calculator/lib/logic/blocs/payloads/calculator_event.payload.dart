import 'package:fastyle_calculator/fastyle_calculator.dart';

class FastCalculatorBlocEventPayload<R extends FastCalculatorResults> {
  final String? key;
  final dynamic value;
  final R? results;
  final dynamic error;

  const FastCalculatorBlocEventPayload({
    this.key,
    this.value,
    this.results,
    this.error,
  });
}
