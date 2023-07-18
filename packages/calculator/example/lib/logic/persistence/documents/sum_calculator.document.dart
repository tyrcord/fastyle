// Package imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

// Project imports:
import 'package:fastyle_calculator_example/logic/logic.dart';

class SumCalculatorDocument extends FastCalculatorDocument {
  final String? numberA;
  final String? numberB;

  const SumCalculatorDocument({this.numberA, this.numberB});

  @override
  SumCalculatorDocument clone() {
    return SumCalculatorDocument(numberA: numberA, numberB: numberB);
  }

  @override
  SumCalculatorDocument copyWith({
    String? numberA,
    String? numberB,
  }) {
    return SumCalculatorDocument(
      numberA: numberA ?? this.numberA,
      numberB: numberB ?? this.numberB,
    );
  }

  @override
  SumCalculatorDocument merge(covariant SumCalculatorDocument model) {
    return model.clone();
  }

  @override
  List<Object?> get props => [numberA, numberB];

  @override
  Map<String, dynamic> toJson() {
    return {
      'numberA': numberA,
      'numberB': numberB,
    };
  }

  @override
  SumCalculatorFields toFields() {
    return SumCalculatorFields(
      numberA: numberA ?? '',
      numberB: numberB ?? '',
    );
  }

  static SumCalculatorDocument fromJson(Map<String, dynamic> json) {
    return SumCalculatorDocument(
      numberA: json['numberA'] as String? ?? '',
      numberB: json['numberB'] as String? ?? '',
    );
  }
}
