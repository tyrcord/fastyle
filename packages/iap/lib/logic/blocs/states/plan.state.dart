// Package imports:
import 'package:tbloc/tbloc.dart';

class FastPlanBlocState extends BlocState {
  final bool isPlanPurchasePending;
  final bool hasPurchasedPlan;
  final bool isRestoringPlan;
  final String? planId;

  FastPlanBlocState({
    super.error,
    this.isPlanPurchasePending = false,
    this.hasPurchasedPlan = false,
    this.isRestoringPlan = false,
    this.planId,
  }) : super(isInitialized: true);

  @override
  FastPlanBlocState copyWith({
    bool? isPlanPurchasePending,
    bool? hasPurchasedPlan,
    bool? isRestoringPlan,
    String? planId,
    dynamic error,
  }) {
    return FastPlanBlocState(
      hasPurchasedPlan: hasPurchasedPlan ?? this.hasPurchasedPlan,
      isRestoringPlan: isRestoringPlan ?? this.isRestoringPlan,
      planId: planId ?? this.planId,
      error: error,
      isPlanPurchasePending:
          isPlanPurchasePending ?? this.isPlanPurchasePending,
    );
  }

  @override
  FastPlanBlocState clone() => copyWith();

  @override
  FastPlanBlocState merge(covariant FastPlanBlocState model) {
    return FastPlanBlocState(
      isPlanPurchasePending: model.isPlanPurchasePending,
      hasPurchasedPlan: model.hasPurchasedPlan,
      isRestoringPlan: model.isRestoringPlan,
      planId: model.planId,
      error: model.error,
    );
  }

  @override
  List<Object?> get props => [
        isPlanPurchasePending,
        hasPurchasedPlan,
        isRestoringPlan,
        planId,
        error,
      ];
}
