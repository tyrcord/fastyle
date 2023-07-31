import 'package:collection/collection.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

ProductDetails? getProductDetails(
  List<ProductDetails>? products,
  String productId,
) {
  return products?.firstWhereOrNull((product) => product.id == productId);
}
