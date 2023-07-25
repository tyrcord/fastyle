import 'package:tbloc/tbloc.dart';
import 'package:fastyle_ad/fastyle_ad.dart';

class FastSplashAdBlocState extends BlocState {
  final FastAdInfo adInfo;
  final String? countryCode;

  FastSplashAdBlocState({
    super.isInitializing = false,
    super.isInitialized = false,
    FastAdInfo? adInfo,
    this.countryCode,
  }) : adInfo = adInfo ?? const FastAdInfo();

  @override
  FastSplashAdBlocState copyWith({
    FastAdInfo? adInfo,
    bool? isInitializing,
    bool? isInitialized,
    String? countryCode,
  }) {
    return FastSplashAdBlocState(
      adInfo: adInfo ?? this.adInfo,
      isInitializing: isInitializing ?? this.isInitializing,
      isInitialized: isInitialized ?? this.isInitialized,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  @override
  List<Object?> get props => [
        isInitializing,
        isInitialized,
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
      countryCode: model.countryCode,
      adInfo: model.adInfo,
    );
  }
}
