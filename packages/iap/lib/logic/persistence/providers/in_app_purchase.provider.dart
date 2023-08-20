// Package imports:
import 'package:tstore/tstore.dart';

// Project imports:
import 'package:fastyle_iap/fastyle_iap.dart';

class FastInAppPurchaseDataProvider extends TDataProvider {
  FastInAppPurchaseDataProvider({
    String? storeName,
  }) : super(storeName: storeName ?? kFastInAppPurchasesStoreName);

  Future<List<FastInAppPurchase>> listAllPurchases() async {
    final rawList = await store.list<Map<dynamic, dynamic>>();

    return rawList.map((Map<dynamic, dynamic> raw) {
      final json = Map<String, dynamic>.from(raw);

      return FastInAppPurchase.fromJson(json);
    }).toList();
  }

  Future<Map<String, FastInAppPurchase>> listAllPurchasesAsMap() async {
    return store.toMap<FastInAppPurchase>();
  }

  Future<void> persistPurchase(FastInAppPurchase purchase) async {
    return store.persist(purchase.productId, purchase.toJson());
  }

  Future<bool> hasPurchasedProduct(String productId) async {
    final purchases = await listAllPurchasesAsMap();
    final purchase = purchases[productId];

    return purchase?.enabled ?? false;
  }

  Future<void> enablePurchaseWithProductId(String productId) async {
    final model = FastInAppPurchase(productId: productId, enabled: true);

    return persistPurchase(model);
  }
}
