// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_iap/fastyle_iap.dart';

class FastPlanBlocEvent
    extends BlocEvent<FastPlanBlocEventType, FastPlanBlocEventPayload> {
  const FastPlanBlocEvent({required super.type, super.payload});

  // Named Constructor for 'purchasePlan' event
  FastPlanBlocEvent.purchasePlan(String productId)
      : super(
          type: FastPlanBlocEventType.purchasePlan,
          payload: FastPlanBlocEventPayload(productId: productId),
        );

  // Named Constructor for 'planPurchased' event
  FastPlanBlocEvent.planPurchased(String productId)
      : super(
          type: FastPlanBlocEventType.planPurchased,
          payload: FastPlanBlocEventPayload(productId: productId),
        );

  // Named Constructor for 'purchasePlanFailed' event
  FastPlanBlocEvent.purchasePlanFailed(
    String productId,
    dynamic error,
  ) : super(
          type: FastPlanBlocEventType.purchasePlanFailed,
          payload: FastPlanBlocEventPayload(productId: productId, error: error),
        );

  // Named Constructor for 'purchasePlanCanceled' event
  FastPlanBlocEvent.purchasePlanCanceled(String productId)
      : super(
          type: FastPlanBlocEventType.purchasePlanCanceled,
          payload: FastPlanBlocEventPayload(productId: productId),
        );

  // Named Constructor for 'restorePlan' event
  FastPlanBlocEvent.restorePlan(String productId)
      : super(
          type: FastPlanBlocEventType.restorePlan,
          payload: FastPlanBlocEventPayload(productId: productId),
        );

  // Named Constructor for 'planRestored' event
  FastPlanBlocEvent.planRestored(String productId)
      : super(
          type: FastPlanBlocEventType.planRestored,
          payload: FastPlanBlocEventPayload(productId: productId),
        );

  // Named Constructor for 'restorePlanFailed' event
  FastPlanBlocEvent.restorePlanFailed(String productId)
      : super(
          type: FastPlanBlocEventType.restorePlanFailed,
          payload: FastPlanBlocEventPayload(productId: productId),
        );
}
