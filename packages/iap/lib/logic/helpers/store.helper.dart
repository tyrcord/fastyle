// Package imports:
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_iap/fastyle_iap.dart';

ProductDetails? getProductDetails(
  List<ProductDetails>? products,
  String productId,
) {
  return products?.firstWhereOrNull((product) => product.id == productId);
}

String sKErrorToReadableMessage(int errorCode) {
  switch (errorCode) {
    case FastSKError.clientInvalid:
      return PurchasesLocaleKeys.purchases_error_client_invalid.tr();

    case FastSKError.paymentCancelled:
      return PurchasesLocaleKeys.purchases_error_payment_cancelled.tr();

    case FastSKError.paymentInvalid:
      return PurchasesLocaleKeys.purchases_error_payment_invalid.tr();

    case FastSKError.paymentNotAllowed:
      return PurchasesLocaleKeys.purchases_error_payment_not_allowed.tr();

    case FastSKError.storeProductNotAvailable:
      return PurchasesLocaleKeys.purchases_error_store_product_not_available
          .tr();

    case FastSKError.cloudServicePermissionDenied:
      return PurchasesLocaleKeys.purchases_error_cloud_service_permission_denied
          .tr();

    case FastSKError.cloudServiceNetworkConnectionFailed:
      return PurchasesLocaleKeys
          .purchases_error_cloud_service_network_connection_failed
          .tr();

    case FastSKError.cloudServiceRevoked:
      return PurchasesLocaleKeys.purchases_error_cloud_service_revoked.tr();

    case FastSKError.privacyAcknowledgementRequired:
      return PurchasesLocaleKeys
          .purchases_error_privacy_acknowledgement_required
          .tr();

    case FastSKError.unauthorizedRequestData:
      return PurchasesLocaleKeys.purchases_error_unauthorized_request_data.tr();

    case FastSKError.invalidOfferIdentifier:
      return PurchasesLocaleKeys.purchases_error_invalid_offer_identifier.tr();

    case FastSKError.invalidSignature:
      return PurchasesLocaleKeys.purchases_error_invalid_signature.tr();

    case FastSKError.missingOfferParams:
      return PurchasesLocaleKeys.purchases_error_missing_offer_params.tr();

    case FastSKError.invalidOfferPrice:
      return PurchasesLocaleKeys.purchases_error_invalid_offer_price.tr();

    case FastSKError.overlayCancelled:
      return PurchasesLocaleKeys.purchases_error_overlay_cancelled.tr();

    case FastSKError.overlayInvalidConfiguration:
      return PurchasesLocaleKeys.purchases_error_overlay_invalid_configuration
          .tr();

    case FastSKError.overlayTimeout:
      return PurchasesLocaleKeys.purchases_error_overlay_timeout.tr();

    case FastSKError.ineligibleForOffer:
      return PurchasesLocaleKeys.purchases_error_ineligible_for_offer.tr();

    case FastSKError.unsupportedPlatform:
      return PurchasesLocaleKeys.purchases_error_unsupported_platform.tr();

    case FastSKError.overlayPresentedInBackgroundScene:
      return PurchasesLocaleKeys
          .purchases_error_overlay_presented_in_background_scene
          .tr();

    default:
      return PurchasesLocaleKeys.purchases_error_unknown.tr();
  }
}

bool isUserPremium() {
  final storeBloc = FastStoreBloc();
  final premiumProductId = getPremiumProductId();

  if (premiumProductId != null) {
    return storeBloc.currentState.hasPurchasedProduct(premiumProductId);
  }

  return false;
}
