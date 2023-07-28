import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:fastyle_iap/fastyle_iap.dart';

import 'package:tbloc/tbloc.dart';

class FastStoreBlocEvent
    extends BlocEvent<FastStoreBlocEventType, FastStoreBlocPayload> {
  const FastStoreBlocEvent({required super.type, super.payload});

  FastStoreBlocEvent.init(
    FastAppInfoDocument appInfo, {
    IFastErrorReporter? errorReporter,
  }) : super(
          type: FastStoreBlocEventType.init,
          payload: FastStoreBlocPayload(
            errorReporter: errorReporter,
            appInfo: appInfo,
          ),
        );

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

  FastStoreBlocEvent.purchaseProduct(String productId)
      : super(
          type: FastStoreBlocEventType.purchaseProduct,
          payload: FastStoreBlocPayload(productId: productId),
        );

  FastStoreBlocEvent.productPurchased(PurchaseDetails purchaseDetails)
      : super(
          type: FastStoreBlocEventType.productPurchased,
          payload: FastStoreBlocPayload(
            productId: purchaseDetails.productID,
            purchaseDetails: purchaseDetails,
          ),
        );

  FastStoreBlocEvent.purchaseProductFailed(
    dynamic error,
    String productId,
  ) : super(
          type: FastStoreBlocEventType.purchaseProductFailed,
          payload: FastStoreBlocPayload(productId: productId),
          error: error,
        );

  const FastStoreBlocEvent.restorePurchases()
      : super(type: FastStoreBlocEventType.restorePurchases);

  FastStoreBlocEvent.purchaseRestored(PurchaseDetails purchase)
      : super(
          type: FastStoreBlocEventType.purchaseRestored,
          payload: FastStoreBlocPayload(purchase: purchase),
        );

  const FastStoreBlocEvent.restorePurchasesFailed(dynamic error)
      : super(
          type: FastStoreBlocEventType.restorePurchasesFailed,
          error: error,
        );

  FastStoreBlocEvent.purchaseProductCanceled(String productId)
      : super(
          type: FastStoreBlocEventType.purchaseProductCanceled,
          payload: FastStoreBlocPayload(productId: productId),
        );
}
