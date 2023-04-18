import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:tstore/tstore.dart';

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
