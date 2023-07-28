import 'dart:async';

import 'package:tbloc/tbloc.dart';
import 'package:fastyle_iap/fastyle_iap.dart';

/// The [FastPlanBloc] extends [Bloc], which provides the
/// necessary functionality to handle events and state changes.
class FastPlanBloc
    extends BidirectionalBloc<FastPlanBlocEvent, FastPlanBlocState> {
  final FastStoreBloc _fastStoreBloc = FastStoreBloc();
  late StreamSubscription _fastStoreBlocSubscription;
  final List<String> productIds;

  // Store-related flags
  bool _isRestoringPlan = false;
  bool _isPurchasePending = false;
  String? _pendingPlanRestoring;

  FastPlanBloc({
    this.productIds = const <String>[],
    FastPlanBlocState? initialState,
  }) : super(initialState: initialState ?? FastPlanBlocState()) {
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
        yield* handleRestorePlanFailedEvent(productId);
      }
    }
  }

  Stream<FastPlanBlocState> handlePurchasePlanEvent(String productId) async* {
    if (!_isPurchasePending) {
      _isPurchasePending = true;
      yield currentState.copyWith(isPlanPurcharsePending: true);

      _fastStoreBloc.addEvent(FastStoreBlocEvent.purchaseProduct(productId));
    }
  }

  Stream<FastPlanBlocState> handlePlanPurchasedEvent(String productId) async* {
    if (_isPurchasePending) {
      _isPurchasePending = false;
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
      _isPurchasePending = false;
      yield currentState.copyWith(isPlanPurcharsePending: false, error: error);
    }
  }

  Stream<FastPlanBlocState> handlePurchasePlanCanceledEvent(
    String productId,
  ) async* {
    if (_isPurchasePending) {
      _isPurchasePending = false;
      yield currentState.copyWith(isPlanPurcharsePending: false);
    }
  }

  Stream<FastPlanBlocState> handleRestorePlanEvent(String productId) async* {
    if (!_isRestoringPlan) {
      _isRestoringPlan = true;
      _pendingPlanRestoring = productId;
      yield currentState.copyWith(isRestoringPlan: true);

      _fastStoreBloc.addEvent(const FastStoreBlocEvent.restorePurchases());
    }
  }

  Stream<FastPlanBlocState> handlePlanRestoredEvent(String productId) async* {
    if (_isRestoringPlan) {
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
  ) async* {
    if (_isRestoringPlan) {
      _isRestoringPlan = false;
      _pendingPlanRestoring = null;
      yield currentState.copyWith(isRestoringPlan: false);
    }
  }

  void handleStoreEvents(FastStoreBlocEvent event) {
    final payload = event.payload;
    final productId = payload?.productId ?? _pendingPlanRestoring!;
    final type = event.type;
    final error = event.error;

    if (type == FastStoreBlocEventType.productPurchased) {
      addEvent(FastPlanBlocEvent.planPurchased(productId));
    } else if (event.type == FastStoreBlocEventType.purchaseProductFailed) {
      addEvent(FastPlanBlocEvent.purchasePlanFailed(productId, error));
    } else if (type == FastStoreBlocEventType.purchaseProductCanceled) {
      addEvent(FastPlanBlocEvent.purchasePlanCanceled(productId));
    } else if (type == FastStoreBlocEventType.purchaseRestored) {
      addEvent(FastPlanBlocEvent.planRestored(productId));
    } else if (type == FastStoreBlocEventType.restorePurchasesFailed) {
      addEvent(FastPlanBlocEvent.restorePlanFailed(productId));
    }
  }

  bool _filterStoreBlocEvents(event) {
    final type = event.type;

    if (type == FastStoreBlocEventType.restorePurchasesFailed) {
      return _pendingPlanRestoring != null;
    } else if (event.payload?.productId != null) {
      return productIds.contains(event.payload!.productId);
    }

    return false;
  }
}
