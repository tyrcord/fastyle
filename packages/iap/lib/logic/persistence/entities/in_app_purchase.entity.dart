// Package imports:
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tstore/tstore.dart';

class FastInAppPurchase extends TEntity {
  final String productId;
  final bool enabled;

  const FastInAppPurchase({
    required this.productId,
    this.enabled = false,
  });

  factory FastInAppPurchase.fromJson(Map<String, dynamic> json) {
    return FastInAppPurchase(
      enabled: json['enabled'] as bool,
      productId: json['id'] as String,
    );
  }

  factory FastInAppPurchase.fromPurchaseDetails(PurchaseDetails details) {
    return FastInAppPurchase(
      enabled: details.status == PurchaseStatus.purchased ||
          details.status == PurchaseStatus.restored,
      productId: details.productID,
    );
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'enabled': enabled,
        'id': productId,
      };

  @override
  FastInAppPurchase copyWith({
    String? productId,
    bool? enabled,
  }) =>
      FastInAppPurchase(
        productId: productId ?? this.productId,
        enabled: enabled ?? this.enabled,
      );

  @override
  FastInAppPurchase merge(covariant FastInAppPurchase model) {
    return copyWith(productId: model.productId, enabled: model.enabled);
  }

  @override
  FastInAppPurchase clone() {
    return FastInAppPurchase(productId: productId, enabled: enabled);
  }

  @override
  List<Object> get props => [productId, enabled];
}
