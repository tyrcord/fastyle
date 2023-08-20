// Package imports:
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_iap/fastyle_iap.dart';

class FastStoreBlocState extends BlocState {
  final List<FastInAppPurchase> purchases;
  final List<ProductDetails>? products;
  final bool isRestoringPurchases;
  final bool isPurchasePending;
  final bool isLoadingProducts;
  final bool isStoreAvailable;

  bool get hasLoadedProducts => products != null;

  FastStoreBlocState({
    super.isInitialized,
    super.isInitializing,
    super.error,
    this.isRestoringPurchases = false,
    this.isPurchasePending = false,
    this.isLoadingProducts = false,
    this.isStoreAvailable = false,
    this.purchases = const [],
    this.products,
  });

  bool hasPurchasedProduct(String productId) {
    return purchases
        .where((element) => element.enabled)
        .any((purchase) => purchase.productId == productId);
  }

  @override
  FastStoreBlocState copyWith({
    String? priceText,
    String? descriptionText,
    bool? isInitialized,
    bool? isInitializing,
    bool? isPurchasePending,
    bool? isRestoringPurchases,
    bool? isLoadingProducts,
    bool? isStoreAvailable,
    List<FastInAppPurchase>? purchases,
    List<ProductDetails>? products,
    dynamic error,
  }) {
    return FastStoreBlocState(
      isRestoringPurchases: isRestoringPurchases ?? this.isRestoringPurchases,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      isPurchasePending: isPurchasePending ?? this.isPurchasePending,
      isStoreAvailable: isStoreAvailable ?? this.isStoreAvailable,
      isInitializing: isInitializing ?? this.isInitializing,
      isInitialized: isInitialized ?? this.isInitialized,
      purchases: purchases ?? this.purchases,
      products: products ?? this.products,
      error: error,
    );
  }

  @override
  FastStoreBlocState clone() => copyWith();

  @override
  FastStoreBlocState merge(covariant FastStoreBlocState model) {
    return FastStoreBlocState(
      isRestoringPurchases: model.isRestoringPurchases,
      isPurchasePending: model.isPurchasePending,
      isLoadingProducts: model.isLoadingProducts,
      isStoreAvailable: model.isStoreAvailable,
      isInitializing: model.isInitializing,
      isInitialized: model.isInitialized,
      purchases: model.purchases,
      products: model.products,
      error: model.error,
    );
  }

  @override
  List<Object?> get props => [
        isRestoringPurchases,
        isLoadingProducts,
        isPurchasePending,
        isStoreAvailable,
        hasLoadedProducts,
        isInitializing,
        isInitialized,
        purchases,
        products,
        error,
      ];
}
