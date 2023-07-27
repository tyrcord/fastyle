import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FastRewardedAdBlocEventPayload {
  final FastAdInfo? adInfo;
  final String? country;
  final dynamic error;
  final RewardItem? reward;

  FastRewardedAdBlocEventPayload({
    this.adInfo,
    this.country,
    this.error,
    this.reward,
  });

  FastRewardedAdBlocEventPayload copyWith({
    FastAdInfo? adInfo,
    String? country,
    dynamic error,
    bool? isAdLoaded,
    RewardItem? reward,
  }) {
    return FastRewardedAdBlocEventPayload(
      adInfo: adInfo ?? this.adInfo,
      country: country ?? this.country,
      error: error ?? this.error,
      reward: reward ?? this.reward,
    );
  }
}
