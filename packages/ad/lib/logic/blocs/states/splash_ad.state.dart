// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastSplashAdBlocState extends BlocState {
  final FastAdInfo adInfo;
  final String? countryCode;
  final bool isAdLoaded;

  FastSplashAdBlocState({
    super.isInitializing = false,
    super.isInitialized = false,
    this.isAdLoaded = false,
    FastAdInfo? adInfo,
    this.countryCode,
  }) : adInfo = adInfo ?? const FastAdInfo();

  @override
  FastSplashAdBlocState copyWith({
    FastAdInfo? adInfo,
    bool? isInitializing,
    bool? isInitialized,
    bool? isAdLoaded,
    String? countryCode,
  }) {
    return FastSplashAdBlocState(
      adInfo: adInfo ?? this.adInfo,
      isInitializing: isInitializing ?? this.isInitializing,
      isInitialized: isInitialized ?? this.isInitialized,
      isAdLoaded: isAdLoaded ?? this.isAdLoaded,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  @override
  List<Object?> get props => [
        isInitializing,
        isInitialized,
        isAdLoaded,
        countryCode,
        adInfo,
      ];

  @override
  FastSplashAdBlocState clone() => copyWith();

  @override
  FastSplashAdBlocState merge(
    covariant FastSplashAdBlocState model,
  ) {
    return copyWith(
      isInitializing: model.isInitializing,
      isInitialized: model.isInitialized,
      isAdLoaded: model.isAdLoaded,
      countryCode: model.countryCode,
      adInfo: model.adInfo,
    );
  }
}
