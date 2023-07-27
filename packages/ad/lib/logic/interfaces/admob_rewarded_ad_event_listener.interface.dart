// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract interface class AdEventListener {
  void onAdLoaded(String requestId, RewardedAd ad);
  void onAdFailedToLoad(String requestId, LoadAdError error);
  void onAdShowed(String requestId, RewardedAd ad);
  void onAdImpression(String requestId, RewardedAd ad);
  void onAdClicked(String requestId, RewardedAd ad);
  void onAdFailedToShow(String requestId, AdError error);
  void onAdDismissed(String requestId, RewardedAd ad);
  void onUserEarnedReward(String requestId, RewardItem reward);
}
