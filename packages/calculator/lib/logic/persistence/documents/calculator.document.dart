// Package imports:
import 'package:tstore/tstore.dart';

// Project imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

abstract class FastCalculatorDocument extends TDocument {
  const FastCalculatorDocument();

  FastCalculatorFields toFields();

  dynamic mergeValue(dynamic valueA, dynamic valueB) {
    if (valueA is String && valueB is String) {
      if (valueA.isEmpty) {
        return valueB;
      }

      return valueA;
    }

    return valueA;
  }
}
