import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:fastyle_iap/fastyle_iap.dart';

import 'package:tbloc/tbloc.dart';

class FastStoreBlocEvent
    extends BlocEvent<FastStoreBlocEventType, FastStoreBlocPayload> {
  const FastStoreBlocEvent({
    required FastStoreBlocEventType type,
    FastStoreBlocPayload? payload,
  }) : super(type: type, payload: payload);

  const FastStoreBlocEvent.init() : super(type: FastStoreBlocEventType.init);

  const FastStoreBlocEvent.initialized()
      : super(type: FastStoreBlocEventType.initialized);

  const FastStoreBlocEvent.loadProducts()
      : super(type: FastStoreBlocEventType.loadProducts);

  const FastStoreBlocEvent.loadProductsFailed(dynamic error)
      : super(
          type: FastStoreBlocEventType.loadProductsFailed,
          error: error,
        );

  FastStoreBlocEvent.productsLoaded(List<ProductDetails>? products)
      : super(
          type: FastStoreBlocEventType.productsLoaded,
          payload: FastStoreBlocPayload(products: products),
        );

  FastStoreBlocEvent.purchaseProduct(ProductDetails? productDetails)
      : super(
          type: FastStoreBlocEventType.purchaseProduct,
          payload: FastStoreBlocPayload(productDetails: productDetails),
        );

  FastStoreBlocEvent.productPurchased(PurchaseDetails purchaseDetails)
      : super(
          type: FastStoreBlocEventType.productPurchased,
          payload: FastStoreBlocPayload(purchaseDetails: purchaseDetails),
        );

  const FastStoreBlocEvent.purchaseProductFailed(dynamic error)
      : super(
          type: FastStoreBlocEventType.purchaseProductFailed,
          error: error,
        );

  const FastStoreBlocEvent.restorePurchases()
      : super(type: FastStoreBlocEventType.restorePurchases);

  FastStoreBlocEvent.purchaseRestored(PurchaseDetails purchase)
      : super(
          type: FastStoreBlocEventType.purchaseRestored,
          payload: FastStoreBlocPayload(purchase: purchase),
        );

  const FastStoreBlocEvent.purchasesRestored()
      : super(type: FastStoreBlocEventType.purchasesRestored);

  const FastStoreBlocEvent.restorePurchasesFailed(dynamic error)
      : super(
          type: FastStoreBlocEventType.restorePurchasesFailed,
          error: error,
        );

  const FastStoreBlocEvent.purchaseProducCanceled()
      : super(type: FastStoreBlocEventType.purchaseProducCanceled);
}
