import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:t_helpers/helpers.dart';

/// Controller for a Rewarded ad.
class FastAdmobRewardedAdService {
  /// Information about the ad.
  final FastAdInfo? adInfo;

  final List<AdEventListener> _listeners = [];

  /// The loaded rewarded ad.
  RewardedAd? _rewardedAd;

  String debugLabel;

  /// The user's country.
  final String? userCountry;

  static FastAdmobRewardedAdService? _singleton;

  factory FastAdmobRewardedAdService(
    FastAdInfo? adInfo, {
    String? debugLabel,
    String? userCountry,
  }) {
    _singleton ??= FastAdmobRewardedAdService._(
      adInfo,
      debugLabel: debugLabel,
      userCountry: userCountry,
    );

    return _singleton!;
  }

  /// Creates a new [FastAdmobRewardedAdService] with the given [adInfo].
  FastAdmobRewardedAdService._(
    this.adInfo, {
    String? debugLabel,
    this.userCountry,
  }) : debugLabel = debugLabel ?? 'FastAdmobRewardedAdService';

  /// The ad unit ID for the rewarded ad.
  String? get rewardedAdUnitId => adInfo?.rewardedAdUnitId;

  /// Whether an ad is available to be shown.
  bool get isAdAvailable => _rewardedAd != null;

  /// Loads a RewardedAd.
  ///
  /// This method loads a rewarded ad with the provided ad unit ID and sets up
  /// the full screen content callbacks to handle ad display and events.
  Future<bool> loadAd({
    String? adUnitId,
    String? country,
  }) async {
    _rewardedAd = null;
    adUnitId ??= rewardedAdUnitId;
    country ??= userCountry;

    if (adUnitId == null) {
      debugLog('Ad unit ID is not provided.', debugLabel: debugLabel);

      return false;
    }

    final canRequestAd = isAdRequestAllowedForCountry(
      whiteList: adInfo?.countries,
      country: country,
    );

    if (canRequestAd) {
      await RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: handleAdLoaded,
          onAdFailedToLoad: handleAdFailedToLoad,
        ),
      );

      return true;
    }

    return false;
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

  void addListener(AdEventListener listener) {
    _listeners.add(listener);
  }

  void removeListener(AdEventListener listener) {
    _listeners.remove(listener);
  }

  @protected
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

    _notifyListeners((listener) => listener.onAdLoaded(ad));
  }

  @protected
  void handleAdFailedToLoad(LoadAdError error) {
    debugLog(
      'RewardedAd failed to load',
      value: error,
      debugLabel: debugLabel,
    );

    _notifyListeners((listener) => listener.onAdFailedToLoad(error));
  }

  @protected
  void handleAdShowed(RewardedAd ad) {
    debugLog('Ad showed', debugLabel: debugLabel);
    _notifyListeners((listener) => listener.onAdShowed());
  }

  @protected
  void handleAdImpression(RewardedAd ad) {
    debugLog('Ad impression', debugLabel: debugLabel);
    _notifyListeners((listener) => listener.onAdImpression());
  }

  @protected
  void handleAdClicked(RewardedAd ad) {
    debugLog('Ad clicked', debugLabel: debugLabel);
    _notifyListeners((listener) => listener.onAdClicked());
  }

  @protected
  void handleAdFailedToShow(RewardedAd ad, AdError error) {
    debugLog(
      'Failed to show ad',
      value: error,
      debugLabel: debugLabel,
    );
    _disposeAd();
    _notifyListeners((listener) => listener.onAdFailedToShow(error));
  }

  @protected
  void handleAdDismissed(RewardedAd ad) {
    debugLog('Ad dismissed', debugLabel: debugLabel);
    _disposeAd();
    _notifyListeners((listener) => listener.onAdDismissed());
  }

  @protected
  void handleUserEarnedReward(AdWithoutView ad, RewardItem reward) {
    debugLog(
      'User earned reward',
      value: reward,
      debugLabel: debugLabel,
    );

    _notifyListeners((listener) => listener.onUserEarnedReward(reward));
  }

  /// Disposes of the current rewarded ad.
  void _disposeAd() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }

  void _notifyListeners(Function(AdEventListener listener) callback) {
    for (var listener in _listeners) {
      callback(listener);
    }
  }
}
