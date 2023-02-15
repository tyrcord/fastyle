import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:fastyle_calculator_example/logic/logic.dart';

class SumCalculatorDataProvider
    extends FastCalculatorDataProvider<SumCalculatorDocument> {
  SumCalculatorDataProvider() : super(storeName: 'sum_calculator');

  @override
  Future<SumCalculatorDocument> retrieveCalculatorDocument() async {
    final raw = await store.toMap();

    if (raw.isNotEmpty) {
      return SumCalculatorDocument.fromJson(raw);
    }

    return SumCalculatorDocument();
  }
}
