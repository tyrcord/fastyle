import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:tstore_dart/tstore_dart.dart';

abstract class FastCalculatorDataProvider<D extends FastCalculatorDocument>
    extends TDocumentDataProvider {
  FastCalculatorDataProvider({
    required String storeName,
  }) : super(storeName: storeName);

  Future<D> retrieveCalculatorDocument();

  Future<void> persistCalculatorDocument(D document) async {
    return persistDocument(document);
  }

  Future<void> clearCalculatorDocument() async => clearDocument();
}
