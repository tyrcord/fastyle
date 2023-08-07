// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastNativeAdBlocState extends BlocState {
  final AdWithView? adView;
  final bool showFallback;
  final bool isLoadingAd;
  final FastResponseAd? ad;

  FastNativeAdBlocState({
    super.isInitializing = false,
    super.isInitialized = false,
    this.showFallback = false,
    this.isLoadingAd = false,
    this.adView,
    this.ad,
  });

  @override
  FastNativeAdBlocState copyWith({
    bool? isInitializing,
    bool? isInitialized,
    AdWithView? adView,
    bool? showFallback,
    bool? isLoadingAd,
    FastResponseAd? ad,
  }) {
    return FastNativeAdBlocState(
      isInitializing: isInitializing ?? this.isInitializing,
      isInitialized: isInitialized ?? this.isInitialized,
      showFallback: showFallback ?? this.showFallback,
      isLoadingAd: isLoadingAd ?? this.isLoadingAd,
      adView: adView ?? this.adView,
      ad: ad ?? this.ad,
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
      ad: model.ad,
    );
  }

  @override
  List<Object?> get props => [
        isInitializing,
        isInitialized,
        showFallback,
        isLoadingAd,
        adView,
        ad,
      ];
}
