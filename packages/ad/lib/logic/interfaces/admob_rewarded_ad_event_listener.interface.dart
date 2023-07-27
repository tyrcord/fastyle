import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract interface class AdEventListener {
  void onAdLoaded(RewardedAd ad);
  void onAdFailedToLoad(LoadAdError error);
  void onAdShowed();
  void onAdImpression();
  void onAdClicked();
  void onAdFailedToShow(AdError error);
  void onAdDismissed();
  void onUserEarnedReward(RewardItem reward);
}
