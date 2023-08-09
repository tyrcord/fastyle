// Dart imports:
import 'dart:async';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_iap/fastyle_iap.dart';

typedef PlanPurchasedCallback = FastAppFeatures Function(String planId);

/// The [FastPlanBloc] extends [Bloc], which provides the
/// necessary functionality to handle events and state changes.
class FastPlanBloc
    extends BidirectionalBloc<FastPlanBlocEvent, FastPlanBlocState> {
  final FastAppFeaturesBloc _fastAppFeaturesBloc = FastAppFeaturesBloc();
  final FastStoreBloc _fastStoreBloc = FastStoreBloc();
  final FastAppInfoBloc _fastAppInfoBloc = FastAppInfoBloc();
  late StreamSubscription _fastStoreBlocSubscription;
  final PlanPurchasedCallback getFeatureForPlan;
  late List<String> productIds;

  // Store-related flags
  bool _isRestoringPlan = false;
  bool _isPurchasePending = false;
  String? _pendingPlanRestoring;

  FastPlanBloc({
    required this.getFeatureForPlan,
    List<String>? productIds,
    FastPlanBlocState? initialState,
  }) : super(initialState: initialState ?? FastPlanBlocState()) {
    final appInfo = _fastAppInfoBloc.currentState;
    this.productIds = productIds ?? appInfo.productIdentifiers ?? [];

    _fastStoreBlocSubscription = _fastStoreBloc.onEvent
        .where(_filterStoreBlocEvents)
        .listen(handleStoreEvents);
  }

  @override
  void close() {
    super.close();
    _fastStoreBlocSubscription.cancel();
  }

  @override
  Stream<FastPlanBlocState> mapEventToState(FastPlanBlocEvent event) async* {
    final payload = event.payload;

    if (payload is FastPlanBlocEventPayload && payload.productId != null) {
      final productId = payload.productId!;
      final type = event.type;
      final error = event.error;

      if (type == FastPlanBlocEventType.purchasePlan) {
        yield* handlePurchasePlanEvent(productId);
      } else if (type == FastPlanBlocEventType.planPurchased) {
        yield* handlePlanPurchasedEvent(productId);
      } else if (type == FastPlanBlocEventType.purchasePlanFailed) {
        yield* handlePurchasePlanFailedEvent(productId, error);
      } else if (type == FastPlanBlocEventType.purchasePlanCanceled) {
        yield* handlePurchasePlanCanceledEvent(productId);
      } else if (type == FastPlanBlocEventType.restorePlan) {
        yield* handleRestorePlanEvent(productId);
      } else if (type == FastPlanBlocEventType.planRestored) {
        yield* handlePlanRestoredEvent(productId);
      } else if (type == FastPlanBlocEventType.restorePlanFailed) {
        yield* handleRestorePlanFailedEvent(productId, error);
      } else if (type == FastPlanBlocEventType.resetError) {
        yield* handleResetErrorEvent();
      }
    }
  }

  Stream<FastPlanBlocState> handlePurchasePlanEvent(String productId) async* {
    if (!_isRestoringPlan && !_isPurchasePending) {
      debugLog('Purchase plan: $productId');

      _isPurchasePending = true;
      yield currentState.copyWith(isPlanPurcharsePending: true);

      _fastStoreBloc.addEvent(FastStoreBlocEvent.purchaseProduct(productId));
    }
  }

  Stream<FastPlanBlocState> handlePlanPurchasedEvent(String productId) async* {
    if (_isPurchasePending) {
      debugLog('Plan purchased: $productId');

      _isPurchasePending = false;

      await _enablePlan(productId);

      yield currentState.copyWith(
        isPlanPurcharsePending: false,
        hasPurchasedPlan: true,
        planId: productId,
      );
    }
  }

  Stream<FastPlanBlocState> handlePurchasePlanFailedEvent(
    String productId,
    dynamic error,
  ) async* {
    if (_isPurchasePending) {
      debugLog('Purchase plan failed: $productId - $error');

      _isPurchasePending = false;

      yield currentState.copyWith(isPlanPurcharsePending: false, error: error);
    }
  }

  Stream<FastPlanBlocState> handlePurchasePlanCanceledEvent(
    String productId,
  ) async* {
    if (_isPurchasePending) {
      debugLog('Purchase plan canceled: $productId');

      _isPurchasePending = false;

      yield currentState.copyWith(isPlanPurcharsePending: false);
    }
  }

  Stream<FastPlanBlocState> handleRestorePlanEvent(String productId) async* {
    if (!_isRestoringPlan && !_isPurchasePending) {
      debugLog('Restore plan: $productId');

      _isRestoringPlan = true;
      _pendingPlanRestoring = productId;

      yield currentState.copyWith(isRestoringPlan: true);

      _fastStoreBloc.addEvent(const FastStoreBlocEvent.restorePurchases());
    }
  }

  Stream<FastPlanBlocState> handlePlanRestoredEvent(String productId) async* {
    if (_isRestoringPlan) {
      debugLog('Plan restored: $productId');

      await _enablePlan(productId);

      _isRestoringPlan = false;
      _pendingPlanRestoring = null;

      yield currentState.copyWith(
        isRestoringPlan: false,
        hasPurchasedPlan: true,
        planId: productId,
      );
    }
  }

  Stream<FastPlanBlocState> handleRestorePlanFailedEvent(
    String productId,
    dynamic error,
  ) async* {
    if (_isRestoringPlan) {
      debugLog('Restore plan failed: $productId - $error');

      _isRestoringPlan = false;
      _pendingPlanRestoring = null;

      yield currentState.copyWith(isRestoringPlan: false, error: error);
    }
  }

  Stream<FastPlanBlocState> handleResetErrorEvent() async* {
    yield currentState.copyWith(error: null);
  }

  void handleStoreEvents(FastStoreBlocEvent event) {
    final payload = event.payload;
    final productId = payload?.productId ?? _pendingPlanRestoring!;
    final type = event.type;
    final error = event.error;

    debugLog('Store event: $type - $productId - $error');

    if (type == FastStoreBlocEventType.productPurchased) {
      addEvent(FastPlanBlocEvent.planPurchased(productId));
    } else if (event.type == FastStoreBlocEventType.purchaseProductFailed) {
      addEvent(FastPlanBlocEvent.purchasePlanFailed(productId, error));
    } else if (type == FastStoreBlocEventType.purchaseProductCanceled) {
      addEvent(FastPlanBlocEvent.purchasePlanCanceled(productId));
    } else if (type == FastStoreBlocEventType.purchaseRestored) {
      addEvent(FastPlanBlocEvent.planRestored(productId));
    } else if (type == FastStoreBlocEventType.restorePurchasesFailed) {
      addEvent(FastPlanBlocEvent.restorePlanFailed(productId, error));
    }
  }

  bool _filterStoreBlocEvents(event) {
    final type = event.type;
    bool willHandle = false;

    if (type == FastStoreBlocEventType.restorePurchasesFailed ||
        type == FastStoreBlocEventType.purchaseRestored) {
      willHandle = _pendingPlanRestoring != null;
    } else if (event.payload?.productId != null) {
      willHandle = productIds.contains(event.payload!.productId);
    }

    debugLog('Filter store event: $type - $willHandle');

    return willHandle;
  }

  Future<void> _enablePlan(String planId) async {
    final feature = getFeatureForPlan(planId);

    _fastAppFeaturesBloc.addEvent(
      FastAppFeaturesBlocEvent.enableFeature(feature),
    );
  }
}
