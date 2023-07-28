import 'package:tbloc/tbloc.dart';

class FastPlanBlocState extends BlocState {
  final bool isPlanPurcharsePending;
  final bool hasPurchasedPlan;
  final bool isRestoringPlan;
  final String? planId;

  FastPlanBlocState({
    super.error,
    this.isPlanPurcharsePending = false,
    this.hasPurchasedPlan = false,
    this.isRestoringPlan = false,
    this.planId,
  }) : super(isInitialized: true);

  @override
  FastPlanBlocState copyWith({
    bool? isPlanPurcharsePending,
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
      isPlanPurcharsePending:
          isPlanPurcharsePending ?? this.isPlanPurcharsePending,
    );
  }

  @override
  FastPlanBlocState clone() => copyWith();

  @override
  FastPlanBlocState merge(covariant FastPlanBlocState model) {
    return FastPlanBlocState(
      isPlanPurcharsePending: model.isPlanPurcharsePending,
      hasPurchasedPlan: model.hasPurchasedPlan,
      isRestoringPlan: model.isRestoringPlan,
      planId: model.planId,
      error: model.error,
    );
  }

  @override
  List<Object?> get props => [
        isPlanPurcharsePending,
        hasPurchasedPlan,
        isRestoringPlan,
        planId,
        error,
      ];
}
