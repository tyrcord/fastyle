import 'package:fastyle_core/fastyle_core.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:fastyle_dart/fastyle_dart.dart';

class FastStoreBlocPayload {
  final IFastErrorReporter? errorReporter;
  final PurchaseDetails? purchaseDetails;
  final List<PurchaseDetails>? purchases;
  final List<ProductDetails>? products;
  final FastAppInfoDocument? appInfo;
  final PurchaseDetails? purchase;
  final String? productId;

  FastStoreBlocPayload({
    this.purchaseDetails,
    this.errorReporter,
    this.productId,
    this.products,
    this.purchases,
    this.purchase,
    this.appInfo,
  });
}
