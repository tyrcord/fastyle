// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastAdInfoBlocState extends BlocState {
  final FastAdInfo adInfo;
  final ConsentStatus? consentStatus;

  FastAdInfoBlocState({
    super.isInitializing = false,
    super.isInitialized = false,
    FastAdInfo? adInfo,
    this.consentStatus,
  }) : adInfo = adInfo ?? const FastAdInfo();

  @override
  FastAdInfoBlocState copyWith({
    FastAdInfo? adInfo,
    bool? isInitializing,
    bool? isInitialized,
    ConsentStatus? consentStatus,
  }) {
    return FastAdInfoBlocState(
      adInfo: adInfo != null ? this.adInfo.merge(adInfo) : this.adInfo,
      isInitializing: isInitializing ?? this.isInitializing,
      consentStatus: consentStatus ?? this.consentStatus,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  FastAdInfoBlocState clone() => copyWith();

  @override
  FastAdInfoBlocState merge(covariant FastAdInfoBlocState model) {
    return copyWith(
      isInitializing: model.isInitializing,
      isInitialized: model.isInitialized,
      consentStatus: model.consentStatus,
      adInfo: model.adInfo,
    );
  }

  @override
  List<Object?> get props => [
        isInitializing,
        isInitialized,
        consentStatus,
        adInfo,
      ];
}
