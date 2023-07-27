// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastAdInfoBlocState extends BlocState {
  final FastAdInfo adInfo;

  FastAdInfoBlocState({
    super.isInitializing = false,
    super.isInitialized = false,
    FastAdInfo? adInfo,
  }) : adInfo = adInfo ?? const FastAdInfo();

  @override
  FastAdInfoBlocState copyWith({
    FastAdInfo? adInfo,
    bool? isInitializing,
    bool? isInitialized,
  }) {
    return FastAdInfoBlocState(
      adInfo: adInfo != null ? this.adInfo.merge(adInfo) : this.adInfo,
      isInitializing: isInitializing ?? this.isInitializing,
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
      adInfo: model.adInfo,
    );
  }

  @override
  List<Object?> get props => [
        isInitializing,
        isInitialized,
        adInfo,
      ];
}
