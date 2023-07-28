import 'package:fastyle_core/fastyle_core.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:fastyle_dart/fastyle_dart.dart';

class FastStoreBlocPayload {
  final PurchaseDetails? purchaseDetails;
  final List<PurchaseDetails>? purchases;
  final ProductDetails? productDetails;
  final List<ProductDetails>? products;
  final PurchaseDetails? purchase;
  final FastAppInfoDocument? appInfo;
  final IFastErrorReporter? errorReporter;

  FastStoreBlocPayload({
    this.purchaseDetails,
    this.productDetails,
    this.products,
    this.purchases,
    this.purchase,
    this.appInfo,
    this.errorReporter,
  });
}
