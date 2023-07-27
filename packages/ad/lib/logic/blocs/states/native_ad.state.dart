// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tbloc/tbloc.dart';

class FastNativeAdBlocState extends BlocState {
  final AdWithView? adView;
  final bool showFallback;
  final bool isLoadingAd;

  FastNativeAdBlocState({
    super.isInitializing = false,
    super.isInitialized = false,
    this.showFallback = false,
    this.isLoadingAd = false,
    this.adView,
  });

  @override
  FastNativeAdBlocState copyWith({
    bool? isInitializing,
    bool? isInitialized,
    AdWithView? adView,
    bool? showFallback,
    bool? isLoadingAd,
  }) {
    return FastNativeAdBlocState(
      isInitializing: isInitializing ?? this.isInitializing,
      isInitialized: isInitialized ?? this.isInitialized,
      showFallback: showFallback ?? this.showFallback,
      isLoadingAd: isLoadingAd ?? this.isLoadingAd,
      adView: adView ?? this.adView,
    );
  }

  @override
  FastNativeAdBlocState clone() => copyWith();

  @override
  FastNativeAdBlocState merge(covariant FastNativeAdBlocState model) {
    return copyWith(
      isInitializing: model.isInitializing,
      isInitialized: model.isInitialized,
      showFallback: model.showFallback,
      isLoadingAd: model.isLoadingAd,
      adView: model.adView,
    );
  }

  @override
  List<Object?> get props => [
        isInitializing,
        isInitialized,
        showFallback,
        isLoadingAd,
        adView,
      ];
}
