import 'dart:async';
import 'dart:io' show Platform;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:fastyle_iap/fastyle_iap.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:rxdart/subjects.dart';
import 'package:fastyle_dart/fastyle_dart.dart';

class FastInAppPurchaseService {
  //FIXME: should be a singleton
  Stream<PurchaseDetails> get onPurchase => _eventController.stream;
  Stream<dynamic> get onError => _errorController.stream;
  InAppPurchase get _iapService => InAppPurchase.instance;

  late PublishSubject<PurchaseDetails> _eventController;
  late PublishSubject<dynamic> _errorController;

  late StreamSubscription _purchasesSubscription;

  final List<PurchaseDetails> _purchases = [];
  bool _isStoreAvailable = false;

  final IFastErrorReporter? errorReporter;
  List<ProductDetails>? _products;
  late List<String> _productIds;

  FastInAppPurchaseService(
    FastAppInfoDocument appInfo, {
    this.errorReporter,
  }) {
    _eventController = PublishSubject<PurchaseDetails>();
    _errorController = PublishSubject<dynamic>();
    _productIds = appInfo.productIdentifiers ?? [];
    _purchasesSubscription = _iapService.purchaseStream.listen(
      handlePurchase,
      onError: handlePurchaseError,
    );

    _purchasesSubscription.pause();
  }

  Future<bool> connect() async {
    _isStoreAvailable = await _iapService.isAvailable();

    if (_isStoreAvailable) {
      await _finishPendingTransaction();

      if (_purchasesSubscription.isPaused) {
        _purchasesSubscription.resume();
      }
    }

    return _isStoreAvailable;
  }

  void disconnect() {
    if (!_purchasesSubscription.isPaused) {
      _purchasesSubscription.pause();
    }
  }

  Future<void> restorePurchases() async => _iapService.restorePurchases();

  List<PurchaseDetails> listPurchases() => _purchases;

  Future<List<ProductDetails>?> listAvailableProducts() async {
    if (_isStoreAvailable && _products == null && _productIds.isNotEmpty) {
      final productIds = _productIds.toSet();
      final response = await _iapService.queryProductDetails(productIds);

      if (response.error != null) {
        throw response.error!;
      }

      _products = response.productDetails;
    }

    return _products;
  }

  Future<bool> purchaseProduct(String productId) async {
    final product = _products?.firstWhereOrNull(
      (product) => product.id == productId,
    );

    if (product == null) {
      throw ('The product $productId is not available');
    }

    await _finishPendingTransaction(productIdentifier: productId);
    final purchaseParam = PurchaseParam(productDetails: product);

    return _iapService.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<bool> hasPurchasedProduct(String productID) async {
    final purchase = _purchases.firstWhereOrNull(
      (purchase) => purchase.productID == productID,
    );

    return purchase != null;
  }

  Future<ProductDetails?> queryProductDetails(String productId) async {
    if (_isStoreAvailable && _products == null) {
      final response = await _iapService.queryProductDetails({productId});

      if (response.error != null) {
        throw response.error!;
      }

      return getProductDetails(response.productDetails, productId);
    }

    return getProductDetails(_products, productId);
  }

  @protected
  void handlePurchase(List<PurchaseDetails> purchases) async {
    for (PurchaseDetails purchase in purchases) {
      if (_verifyPurchaseStatus(purchase)) {
        await _notifyPurchase(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        final productId = purchase.productID;
        final message = 'An error occured when purchasing an item: $productId';
        errorReporter?.recordError(
          purchase.error,
          StackTrace.current,
          reason: message,
        );

        _errorController.sink.add(purchase);
      } else {
        // other status: pending, cancelled
        _eventController.sink.add(purchase);
      }

      if (purchase.pendingCompletePurchase) {
        await _iapService.completePurchase(purchase);
      }
    }
  }

  void handlePurchaseError(dynamic error) {
    if (!_errorController.isClosed) {
      _errorController.add(error);
    }

    errorReporter?.recordError(
      error,
      StackTrace.current,
      reason: 'An error occured when purchasing an item',
    );
  }

  bool _verifyPurchaseStatus(PurchaseDetails purchase) {
    return purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored;
  }

  Future<void> _notifyPurchase(PurchaseDetails purchase) async {
    _purchases.add(purchase);
    _eventController.sink.add(purchase);
  }

  Future<void> _finishPendingTransaction({String? productIdentifier}) async {
    if (Platform.isIOS) {
      var paymentWrapper = SKPaymentQueueWrapper();
      var transactions = await paymentWrapper.transactions();

      for (var transaction in transactions) {
        if (productIdentifier != null) {
          if (transaction.payment.productIdentifier == productIdentifier) {
            await paymentWrapper.finishTransaction(transaction);
          }
        } else {
          await paymentWrapper.finishTransaction(transaction);
        }
      }

      if (transactions.isNotEmpty) {
        await _waitForNoPendingTransaction(paymentWrapper);
      }
    }
  }

  Future<void> _waitForNoPendingTransaction(
    SKPaymentQueueWrapper paymentWrapper, {
    String? productIdentifier,
  }) async {
    // TODO: the package is kind of buggy. We need to wait for all the pending
    // transactions are really to be really finished before purchasing the same
    // productId. let's wait for the next event-loop iteration.
    await Future.delayed(const Duration(seconds: 0));
    var transactions = await paymentWrapper.transactions();
    bool shouldWait = transactions.isNotEmpty;

    if (productIdentifier != null) {
      var transaction = transactions.firstWhereOrNull(
        (transaction) =>
            transaction.payment.productIdentifier == productIdentifier,
      );

      shouldWait = transaction != null;
    }

    return shouldWait
        ? await _waitForNoPendingTransaction(paymentWrapper)
        : null;
  }
}
