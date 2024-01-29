// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastInterstitialAdBlocState extends BlocState {
  final bool isAdDisplayable;
  final String? countryCode;
  final FastAdInfo adInfo;
  final bool isAdLoading;
  final bool isAdLoaded;

  FastInterstitialAdBlocState({
    super.isInitializing = false,
    super.isInitialized = false,
    this.isAdDisplayable = false,
    this.isAdLoading = false,
    this.isAdLoaded = false,
    FastAdInfo? adInfo,
    this.countryCode,
  }) : adInfo = adInfo ?? const FastAdInfo();

  @override
  FastInterstitialAdBlocState copyWith({
    bool? isAdDisplayable,
    bool? isInitializing,
    bool? isInitialized,
    String? countryCode,
    FastAdInfo? adInfo,
    bool? isAdLoading,
    bool? isAdLoaded,
  }) {
    return FastInterstitialAdBlocState(
      isAdDisplayable: isAdDisplayable ?? this.isAdDisplayable,
      isInitializing: isInitializing ?? this.isInitializing,
      isInitialized: isInitialized ?? this.isInitialized,
      isAdLoading: isAdLoading ?? this.isAdLoading,
      countryCode: countryCode ?? this.countryCode,
      isAdLoaded: isAdLoaded ?? this.isAdLoaded,
      adInfo: adInfo ?? this.adInfo,
    );
  }

  @override
  List<Object?> get props => [
        isInitializing,
        isInitialized,
        isAdDisplayable,
        countryCode,
        isAdLoading,
        isAdLoaded,
        adInfo,
      ];

  @override
  FastInterstitialAdBlocState clone() => copyWith();

  @override
  FastInterstitialAdBlocState merge(
    covariant FastInterstitialAdBlocState model,
  ) {
    return copyWith(
      isInitializing: model.isInitializing,
      isInitialized: model.isInitialized,
      isAdDisplayable: model.isAdDisplayable,
      countryCode: model.countryCode,
      isAdLoading: model.isAdLoading,
      isAdLoaded: model.isAdLoaded,
      adInfo: model.adInfo,
    );
  }
}
