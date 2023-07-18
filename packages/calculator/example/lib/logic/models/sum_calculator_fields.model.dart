// Package imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

class SumCalculatorFields extends FastCalculatorFields {
  final String numberA;
  final String numberB;
  final String asyncNumber;

  const SumCalculatorFields({
    this.numberA = '',
    this.numberB = '',
    this.asyncNumber = '',
  });

  @override
  SumCalculatorFields clone() {
    return SumCalculatorFields(
      numberA: numberA,
      numberB: numberB,
      asyncNumber: asyncNumber,
    );
  }

  @override
  SumCalculatorFields copyWith({
    String? numberA,
    String? numberB,
    String? asyncNumber,
  }) {
    return SumCalculatorFields(
      numberA: numberA ?? this.numberA,
      numberB: numberB ?? this.numberB,
      asyncNumber: asyncNumber ?? this.asyncNumber,
    );
  }

  @override
  SumCalculatorFields merge(covariant SumCalculatorFields model) {
    return model.clone();
  }

  @override
  List<Object?> get props => [numberA, numberB, asyncNumber];
}
