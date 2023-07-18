// Package imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

class SumCalculatorResults extends FastCalculatorResults {
  final String sum;

  const SumCalculatorResults({
    this.sum = '0',
  });

  @override
  SumCalculatorResults clone() {
    return SumCalculatorResults(sum: sum);
  }

  @override
  SumCalculatorResults copyWith({
    String? sum,
  }) {
    return SumCalculatorResults(
      sum: sum ?? this.sum,
    );
  }

  @override
  SumCalculatorResults merge(covariant SumCalculatorResults model) {
    return model.clone();
  }

  @override
  List<Object> get props => [sum];
}
