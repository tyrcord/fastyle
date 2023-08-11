// Package imports:
import 'package:tbloc/tbloc.dart';

class FastRewardedAdBlocState extends BlocState {
  final bool isLoadingAd;
  final bool hasLoadedAd;
  final bool isShowingAd;
  final bool hasDismissedAd;
  final String? requestId;

  FastRewardedAdBlocState({
    super.isInitializing = false,
    super.isInitialized = false,
    super.error,
    this.hasDismissedAd = false,
    this.isLoadingAd = false,
    this.hasLoadedAd = false,
    this.isShowingAd = false,
    this.requestId,
  });

  @override
  FastRewardedAdBlocState copyWith({
    bool? isInitializing,
    bool? isInitialized,
    bool? isLoadingAd,
    dynamic error,
    bool? hasLoadedAd,
    bool? isShowingAd,
    bool? hasDismissedAd,
    String? requestId,
  }) {
    return FastRewardedAdBlocState(
      isInitializing: isInitializing ?? this.isInitializing,
      isInitialized: isInitialized ?? this.isInitialized,
      isLoadingAd: isLoadingAd ?? this.isLoadingAd,
      error: error ?? this.error,
      hasLoadedAd: hasLoadedAd ?? this.hasLoadedAd,
      isShowingAd: isShowingAd ?? this.isShowingAd,
      hasDismissedAd: hasDismissedAd ?? this.hasDismissedAd,
      requestId: requestId ?? this.requestId,
    );
  }

  @override
  FastRewardedAdBlocState clone() => copyWith();

  @override
  FastRewardedAdBlocState merge(
    covariant FastRewardedAdBlocState model,
  ) {
    return copyWith(
      isInitializing: model.isInitializing,
      isInitialized: model.isInitialized,
      isLoadingAd: model.isLoadingAd,
      error: model.error,
      hasLoadedAd: model.hasLoadedAd,
      isShowingAd: model.isShowingAd,
      hasDismissedAd: model.hasDismissedAd,
      requestId: model.requestId,
    );
  }

  @override
  List<Object?> get props => [
        isInitializing,
        isInitialized,
        isLoadingAd,
        error,
        hasLoadedAd,
        isShowingAd,
        hasDismissedAd,
        requestId,
      ];
}
