import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:t_helpers/helpers.dart';

/// Controller for a Rewarded ad.
class FastAdmobRewardedAdService {
  /// Information about the ad.
  final FastAdInfo? adInfo;

  /// The loaded rewarded ad.
  RewardedAd? _rewardedAd;

  String debugLabel;

  static FastAdmobRewardedAdService? _singleton;

  factory FastAdmobRewardedAdService(FastAdInfo? adInfo, {String? debugLabel}) {
    _singleton ??= FastAdmobRewardedAdService._(
      adInfo,
      debugLabel: debugLabel,
    );

    return _singleton!;
  }

  /// Creates a new [FastAdmobRewardedAdService] with the given [adInfo].
  FastAdmobRewardedAdService._(
    this.adInfo, {
    String? debugLabel,
  }) : debugLabel = debugLabel ?? 'FastAdmobRewardedAdService';

  /// The ad unit ID for the rewarded ad.
  String? get rewardedAdUnitId => adInfo?.rewardedAdUnitId;

  /// Whether an ad is available to be shown.
  bool get isAdAvailable => _rewardedAd != null;

  /// Loads a RewardedAd.
  ///
  /// This method loads a rewarded ad with the provided ad unit ID and sets up
  /// the full screen content callbacks to handle ad display and events.
  Future<void> loadAd({
    String? adUnitId,
    String? country,
  }) async {
    if (adUnitId == null && rewardedAdUnitId == null) {
      debugLog('Ad unit ID is not provided.', debugLabel: debugLabel);

      return;
    }

    final canRequestAd = isAdRequestAllowedForCountry(
      country: country,
      whiteList: adInfo?.countries,
    );

    if (canRequestAd) {
      return RewardedAd.load(
        adUnitId: adUnitId!,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: handleAdLoaded,
          onAdFailedToLoad: handleAdFailedToLoad,
        ),
      );
    }
  }

  /// Shows the rewarded ad if it is available.
  ///
  /// Does nothing if the ad is not available or already being shown.
  void showAdIfAvailable() {
    if (!isAdAvailable) {
      debugLog(
        'Tried to show ad before it was available.',
        debugLabel: debugLabel,
      );

      return;
    }

    _rewardedAd!.show(onUserEarnedReward: handleUserEarnedReward);
  }

  void handleAdLoaded(RewardedAd ad) {
    debugLog('Ad loaded', debugLabel: debugLabel);

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdFailedToShowFullScreenContent: handleAdFailedToShow,
      onAdDismissedFullScreenContent: handleAdDismissed,
      onAdShowedFullScreenContent: handleAdShowed,
      onAdImpression: handleAdImpression,
      onAdClicked: handleAdClicked,
    );

    _rewardedAd = ad;
  }

  void handleAdFailedToLoad(LoadAdError error) {
    debugLog(
      'RewardedAd failed to load',
      value: error,
      debugLabel: debugLabel,
    );
  }

  void handleAdShowed(RewardedAd ad) {
    debugLog('Ad showed', debugLabel: debugLabel);
  }

  void handleAdImpression(RewardedAd ad) {
    debugLog('Ad impression', debugLabel: debugLabel);
  }

  void handleAdClicked(RewardedAd ad) {
    debugLog('Ad clicked', debugLabel: debugLabel);
  }

  void handleAdFailedToShow(RewardedAd ad, AdError error) {
    debugLog(
      'Failed to show ad',
      value: error,
      debugLabel: debugLabel,
    );
    _dispose();
  }

  void handleAdDismissed(RewardedAd ad) {
    debugLog('Ad dismissed', debugLabel: debugLabel);
    _dispose();
  }

  void handleUserEarnedReward(AdWithoutView ad, RewardItem reward) {
    debugLog(
      'User earned reward',
      value: reward,
      debugLabel: debugLabel,
    );

    //TODO:
  }

  /// Disposes of the current rewarded ad.
  void _dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }
}
