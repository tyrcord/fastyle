// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tbloc/tbloc.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_iap/fastyle_iap.dart';

/// The [FastStoreBloc] extends [BidirectionalBloc], which provides the
/// necessary functionality to handle events and state changes in the store.
class FastStoreBloc
    extends BidirectionalBloc<FastStoreBlocEvent, FastStoreBlocState> {
  /// Keeps track if a singleton instance has been created.
  static bool get hasBeenInstantiated => _hasBeenInstantiated;
  static bool _hasBeenInstantiated = false;

  static final _logger = TLoggerManager.instance.getLogger(debugLabel);
  static const debugLabel = 'FastStoreBloc';

  static late FastStoreBloc _instance;

  static FastStoreBloc get instance {
    if (!_hasBeenInstantiated) return FastStoreBloc();

    return _instance;
  }

  static final _iapDataProvider = FastInAppPurchaseDataProvider();

  // Method to reset the singleton instance
  static void reset() => instance.resetBloc();

  FastInAppPurchaseService? _iapService;
  StreamSubscription? _purchasesSubscription;

  // Store-related flags
  bool _isLoadingProducts = false;
  bool _isPurchasePending = false;
  bool _isRestoringPurchases = false;
  bool _isStoreAvailable = false;
  String? _pendingPurchaseProductId;

  FastStoreBloc._() : super(initialState: FastStoreBlocState());

  /// A factory constructor that returns an instance of [FastStoreBloc].
  /// It ensures that only one instance is created.
  factory FastStoreBloc() {
    if (!_hasBeenInstantiated) {
      _instance = FastStoreBloc._();
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  @override
  bool canClose() => false;

  Future<ProductDetails?> getProductDetails(String productId) async {
    if (_isStoreAvailable && isInitialized) {
      try {
        return retry<ProductDetails?>(
          task: () async => _iapService!.queryProductDetails(productId),
          taskTimeout: kFastAsyncTimeout,
          maxAttempts: 2,
        );
      } catch (error, stackTrace) {
        _logger.error(
          'Error fetching product details for product ID: $productId - $error',
          stackTrace,
        );

        return null;
      }
    } else {
      _logger.warning('Store is not available or not yet initialized.');

      return null;
    }
  }

  /// Maps incoming [FastStoreBlocEvent]s to the appropriate state changes
  /// based on the event type.
  @override
  Stream<FastStoreBlocState> mapEventToState(
    FastStoreBlocEvent event,
  ) async* {
    final payload = event.payload;
    final type = event.type;
    final error = event.error;

    if (type == FastStoreBlocEventType.init) {
      if (payload is FastStoreBlocPayload) {
        yield* handleInitEvent(payload);
      }
    } else if (type == FastStoreBlocEventType.initialized) {
      yield* handleInitializedEvent();
    } else if (isInitialized) {
      if (_isStoreAvailable) {
        switch (type) {
          // Restore purchases
          case FastStoreBlocEventType.restorePurchases:
            yield* handleRestorePurchasesEvent();
          case FastStoreBlocEventType.purchaseRestored:
            if (payload is FastStoreBlocPayload) {
              yield* handlePurchasesRestoredEvent(payload);
            }
          case FastStoreBlocEventType.restorePurchasesFailed:
            yield* handleRestorePurchasesFailedEvent(error);

          // Load products
          case FastStoreBlocEventType.loadProducts:
            yield* handleLoadProductsEvent();
          case FastStoreBlocEventType.productsLoaded:
            if (payload is FastStoreBlocPayload) {
              yield* handleProductsLoadedEvent(payload);
            }
          case FastStoreBlocEventType.loadProductsFailed:
            yield* handleLoadProductsFailedEvent(error);

          // Purchase product
          case FastStoreBlocEventType.purchaseProduct:
            if (payload is FastStoreBlocPayload) {
              yield* handlePurchaseProductEvent(payload);
            }
          case FastStoreBlocEventType.purchaseProductFailed:
            yield* handlePurchaseProductFailedEvent(error);
          case FastStoreBlocEventType.productPurchased:
            if (payload is FastStoreBlocPayload) {
              yield* handleProductPurchasedEvent(payload);
            }
          case FastStoreBlocEventType.purchaseProductCanceled:
            yield* handlePurchaseProductCanceledEvent();
          default:
            assert(false, 'FastStoreBloc is not initialized yet.');
        }
      }
    } else {
      assert(false, 'FastAppInfoBloc is not initialized yet.');
    }
  }

  /// Handles the [FastStoreBlocEventType.init] event to initialize the store.
  Stream<FastStoreBlocState> handleInitEvent(
    FastStoreBlocPayload payload,
  ) async* {
    if (canInitialize) {
      assert(payload.appInfo != null, 'appInfo cannot be null');

      isInitializing = true;

      yield currentState.copyWith(isInitializing: true);

      _iapService = FastInAppPurchaseService(
        appInfo: payload.appInfo!,
        errorReporter: payload.errorReporter,
      );

      _listenToPurchases();
      _listenToErrors();

      await _iapDataProvider.connect();

      _isStoreAvailable = await retry<bool>(
        task: () async => _iapService!.connect(),
        taskTimeout: kFastAsyncTimeout,
        maxAttempts: 2,
      );

      addEvent(const FastStoreBlocEvent.initialized());
    }
  }

  /// Handles the [FastStoreBlocEventType.initialized] event when the store
  /// has been successfully initialized.
  Stream<FastStoreBlocState> handleInitializedEvent() async* {
    if (isInitializing) {
      isInitialized = true;

      yield currentState.copyWith(
        purchases: await _iapDataProvider.listAllPurchases(),
        isStoreAvailable: _isStoreAvailable,
        isInitializing: false,
        isInitialized: true,
      );
    }
  }

  /// Handles the [FastStoreBlocEventType.restorePurchases] event to restore
  /// purchases from the store.
  Stream<FastStoreBlocState> handleRestorePurchasesEvent() async* {
    if (!_isRestoringPurchases && !_isPurchasePending) {
      _logger.debug('Restoring purchases...');
      _isRestoringPurchases = true;

      yield currentState.copyWith(isRestoringPurchases: true);

      // Purchase status handled by _listenToPurchases
      await retry<void>(
        task: () async => _iapService!.restorePurchases(),
        taskTimeout: kFastAsyncTimeout,
        maxAttempts: 2,
      );
    }
  }

  /// Handles the [FastStoreBlocEventType.restorePurchasesFailed] event when
  /// restoring purchases has failed.
  Stream<FastStoreBlocState> handleRestorePurchasesFailedEvent(
    dynamic error,
  ) async* {
    if (_isRestoringPurchases) {
      _logger.error('Restoring purchases failed: $error');
      _isRestoringPurchases = false;

      yield currentState.copyWith(isRestoringPurchases: false, error: error);
    }
  }

  /// Handles the [FastStoreBlocEventType.purchaseRestored] event when a
  /// purchase has been successfully restored.
  Stream<FastStoreBlocState> handlePurchasesRestoredEvent(
    FastStoreBlocPayload payload,
  ) async* {
    if (_isRestoringPurchases) {
      _logger.debug('Purchase restored');
      _isRestoringPurchases = false;

      if (payload.purchaseDetails != null) {
        final purchase = FastInAppPurchase.fromPurchaseDetails(
          payload.purchaseDetails!,
        );

        await _iapDataProvider.enablePurchaseWithProductId(purchase.productId);

        yield currentState.copyWith(
          purchases: [...currentState.purchases, purchase],
          isRestoringPurchases: false,
        );
      } else {
        yield currentState.copyWith(isRestoringPurchases: false);
      }
    }
  }

  /// Handles the [FastStoreBlocEventType.loadProducts] event to load products
  /// available for purchase in the store.
  Stream<FastStoreBlocState> handleLoadProductsEvent() async* {
    if (!_isLoadingProducts) {
      _isLoadingProducts = true;
      yield currentState.copyWith(isLoadingProducts: true);
      _logger.debug('Loading products...');

      try {
        final products = await retry<List<ProductDetails>?>(
          task: () async => _iapService!.listAvailableProducts(),
          taskTimeout: kFastAsyncTimeout,
          maxAttempts: 2,
        );

        _logger.debug('Products found: ${products?.length}');

        if (products != null && kDebugMode) {
          for (final product in products) {
            _logger.debug('Product ID: ${product.id}');
          }
        }

        addEvent(FastStoreBlocEvent.productsLoaded(products));
      } catch (error) {
        addEvent(FastStoreBlocEvent.loadProductsFailed(
          _formartError(error),
        ));
      }
    } else {
      addEvent(
        const FastStoreBlocEvent.loadProductsFailed('store not available'),
      );
    }
  }

  /// Handles the [FastStoreBlocEventType.productsLoaded] event when products
  /// have been successfully loaded from the store.
  Stream<FastStoreBlocState> handleProductsLoadedEvent(
    FastStoreBlocPayload payload,
  ) async* {
    if (_isLoadingProducts) {
      _logger.debug('Products loaded');
      _isLoadingProducts = false;

      yield currentState.copyWith(
        products: payload.products,
        isLoadingProducts: false,
      );
    }
  }

  /// Handles the [FastStoreBlocEventType.loadProductsFailed] event when loading
  /// products from the store has failed.
  Stream<FastStoreBlocState> handleLoadProductsFailedEvent(
    dynamic error,
  ) async* {
    if (_isLoadingProducts) {
      _logger.error('Loading products failed: $error');
      _isLoadingProducts = false;

      yield currentState.copyWith(isLoadingProducts: false, error: error);
    }
  }

  /// Handles the [FastStoreBlocEventType.purchaseProduct] event to initiate a
  /// purchase of a specific product.
  Stream<FastStoreBlocState> handlePurchaseProductEvent(
    FastStoreBlocPayload payload,
  ) async* {
    if (!_isPurchasePending &&
        payload.productId != null &&
        !_isRestoringPurchases) {
      final productId = payload.productId!;
      _logger.debug('Purchasing product: $productId');
      _pendingPurchaseProductId = productId;
      _isPurchasePending = true;

      yield currentState.copyWith(isPurchasePending: true);

      try {
        // Purchase status handled by _listenToPurchases
        await _iapService!.purchaseProduct(productId);
      } catch (error) {
        addEvent(FastStoreBlocEvent.purchaseProductFailed(
          _formartError(error),
          productId,
        ));
      }
    }
  }

  /// Handles the [FastStoreBlocEventType.purchaseProductFailed] event when
  /// purchasing a product has failed.
  Stream<FastStoreBlocState> handlePurchaseProductFailedEvent(
    dynamic error,
  ) async* {
    if (_isPurchasePending) {
      _logger.error('Restoring purchases failed: $error');
      _isPurchasePending = false;
      _pendingPurchaseProductId = null;

      yield currentState.copyWith(error: error, isPurchasePending: false);
    }
  }

  /// Handles the [FastStoreBlocEventType.productPurchased] event when a product
  /// has been successfully purchased.
  Stream<FastStoreBlocState> handleProductPurchasedEvent(
    FastStoreBlocPayload payload,
  ) async* {
    if (_isPurchasePending) {
      _logger.debug('Product purchased');
      _isPurchasePending = false;
      _pendingPurchaseProductId = null;

      if (payload.purchaseDetails != null) {
        final purchase = FastInAppPurchase.fromPurchaseDetails(
          payload.purchaseDetails!,
        );

        await _iapDataProvider.enablePurchaseWithProductId(purchase.productId);

        yield currentState.copyWith(
          purchases: [...currentState.purchases, purchase],
          isPurchasePending: false,
        );
      } else {
        yield currentState.copyWith(isPurchasePending: false);
      }
    }
  }

  /// Handles the [FastStoreBlocEventType.purchaseProductCanceled] event when a
  /// product purchase has been canceled.
  Stream<FastStoreBlocState> handlePurchaseProductCanceledEvent() async* {
    if (_isPurchasePending) {
      _logger.warning('Product purchase canceled');
      _isPurchasePending = false;

      yield currentState.copyWith(isPurchasePending: false);
    }
  }

  /// Sets up the subscriptions to listen for purchase events.
  void _listenToPurchases() {
    if (_purchasesSubscription != null) {
      _purchasesSubscription!.cancel();
    }

    _purchasesSubscription = _iapService!.onPurchase.listen(
      (PurchaseDetails purchaseDetails) {
        if (purchaseDetails.status == PurchaseStatus.purchased) {
          addEvent(FastStoreBlocEvent.productPurchased(purchaseDetails));
        } else if (purchaseDetails.status == PurchaseStatus.restored) {
          addEvent(FastStoreBlocEvent.purchaseRestored(purchaseDetails));
        } else if (purchaseDetails.status == PurchaseStatus.error) {
          final payload = FastStoreBlocEvent.purchaseProductFailed(
            _formartError(purchaseDetails.error),
            purchaseDetails.productID,
          );

          addEvent(payload);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          addEvent(FastStoreBlocEvent.purchaseProductCanceled(
            purchaseDetails.productID,
          ));
        }
      },
      onError: (dynamic error) {
        if (!errorController.isClosed) {
          errorController.sink.add(error as BlocError);
        }
      },
    );
  }

  String _formartError(dynamic error) {
    if (error is SKError) {
      return sKErrorToReadableMessage(error.code);
    } else if (error is FastIapError) {
      return error.toString();
    }

    return CoreLocaleKeys.core_error_error_occurred_exclamation.tr();
  }

  /// Sets up the subscriptions to listen for error events.
  void _listenToErrors() {
    subxList.addAll([
      _iapService!.onError.listen(handleError),
      onError.listen(handleError),
    ]);
  }

  void handleError(dynamic error) {
    error = _formartError(error);

    if (_isPurchasePending) {
      addEvent(FastStoreBlocEvent.purchaseProductFailed(
        error,
        _pendingPurchaseProductId!,
      ));
    } else if (_isRestoringPurchases) {
      addEvent(FastStoreBlocEvent.restorePurchasesFailed(error));
    } else if (_isLoadingProducts) {
      addEvent(FastStoreBlocEvent.loadProductsFailed(error));
    }
  }
}
