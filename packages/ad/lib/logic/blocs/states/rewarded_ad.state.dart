// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tbloc/tbloc.dart';

class FastRewardedAdBlocState extends BlocState {
  final bool showFallback;
  final bool isLoadingAd;
  final bool hasLoadedAd;
  final bool isShowingAd;
  final RewardItem? reward;
  final bool hasDismissedAd;
  final String? requestId;

  bool get isRewarded => reward != null;

  FastRewardedAdBlocState({
    super.isInitializing = false,
    super.isInitialized = false,
    super.error,
    this.hasDismissedAd = false,
    this.showFallback = false,
    this.isLoadingAd = false,
    this.hasLoadedAd = false,
    this.isShowingAd = false,
    this.reward,
    this.requestId,
  });

  @override
  FastRewardedAdBlocState copyWith({
    bool? isInitializing,
    bool? isInitialized,
    AdWithView? adView,
    bool? showFallback,
    bool? isLoadingAd,
    bool? hasError,
    dynamic error,
    bool? hasLoadedAd,
    bool? isShowingAd,
    RewardItem? reward,
    bool? hasDismissedAd,
    String? requestId,
  }) {
    return FastRewardedAdBlocState(
      isInitializing: isInitializing ?? this.isInitializing,
      isInitialized: isInitialized ?? this.isInitialized,
      showFallback: showFallback ?? this.showFallback,
      isLoadingAd: isLoadingAd ?? this.isLoadingAd,
      error: error ?? this.error,
      hasLoadedAd: hasLoadedAd ?? this.hasLoadedAd,
      isShowingAd: isShowingAd ?? this.isShowingAd,
      reward: reward ?? this.reward,
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
      showFallback: model.showFallback,
      isLoadingAd: model.isLoadingAd,
      hasError: model.hasError,
      error: model.error,
      hasLoadedAd: model.hasLoadedAd,
      isShowingAd: model.isShowingAd,
      reward: model.reward,
      hasDismissedAd: model.hasDismissedAd,
      requestId: model.requestId,
    );
  }

  @override
  List<Object?> get props => [
        isInitializing,
        isInitialized,
        showFallback,
        isLoadingAd,
        error,
        hasLoadedAd,
        isShowingAd,
        reward,
        hasDismissedAd,
        requestId,
      ];
}
