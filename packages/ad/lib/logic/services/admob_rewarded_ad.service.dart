// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:t_helpers/helpers.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

/// Controller for a Rewarded ad.
class FastAdmobRewardedAdService {
  static const uuid = Uuid();

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
  Future<String?> loadAd({
    String? adUnitId,
    String? country,
  }) async {
    _rewardedAd = null;
    adUnitId ??= rewardedAdUnitId;
    country ??= userCountry;

    if (adUnitId == null) {
      debugLog('Ad unit ID is not provided.', debugLabel: debugLabel);

      return null;
    }

    final requestId = uuid.v4();

    final canRequestAd = isAdRequestAllowedForCountry(
      whiteList: adInfo?.countries,
      country: country,
    );

    if (canRequestAd) {
      await RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) => handleAdLoaded(requestId, ad),
          onAdFailedToLoad: (ad) => handleAdFailedToLoad(requestId, ad),
        ),
      );

      return requestId;
    }

    return null;
  }

  /// Shows the rewarded ad if it is available.
  ///
  /// Does nothing if the ad is not available or already being shown.
  void showAdIfAvailable(String requestId) {
    if (!isAdAvailable) {
      debugLog(
        'Tried to show ad before it was available.',
        debugLabel: debugLabel,
      );

      return;
    }

    _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      handleUserEarnedReward(requestId, ad, reward);
    });
  }

  void addListener(AdEventListener listener) {
    _listeners.add(listener);
  }

  void removeListener(AdEventListener listener) {
    _listeners.remove(listener);
  }

  @protected
  void handleAdLoaded(String requestId, RewardedAd ad) {
    debugLog('Ad loaded', debugLabel: debugLabel);

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) => handleAdDismissed(requestId, ad),
      onAdShowedFullScreenContent: (ad) => handleAdShowed(requestId, ad),
      onAdImpression: (ad) => handleAdImpression(requestId, ad),
      onAdClicked: (ad) => handleAdClicked(requestId, ad),
      onAdFailedToShowFullScreenContent: (ad, error) {
        handleAdFailedToShow(requestId, ad, error);
      },
    );

    _rewardedAd = ad;

    _notifyListeners((listener) => listener.onAdLoaded(requestId, ad));
  }

  @protected
  void handleAdFailedToLoad(String requestId, LoadAdError error) {
    debugLog('RewardedAd failed to load', value: error, debugLabel: debugLabel);

    _notifyListeners((listener) => listener.onAdFailedToLoad(requestId, error));
  }

  @protected
  void handleAdShowed(String requestId, RewardedAd ad) {
    debugLog('Ad showed', debugLabel: debugLabel);
    _notifyListeners((listener) => listener.onAdShowed(requestId, ad));
  }

  @protected
  void handleAdImpression(String requestId, RewardedAd ad) {
    debugLog('Ad impression', debugLabel: debugLabel);
    _notifyListeners((listener) => listener.onAdImpression(requestId, ad));
  }

  @protected
  void handleAdClicked(String requestId, RewardedAd ad) {
    debugLog('Ad clicked', debugLabel: debugLabel);
    _notifyListeners((listener) => listener.onAdClicked(requestId, ad));
  }

  @protected
  void handleAdFailedToShow(String requestId, RewardedAd ad, AdError error) {
    debugLog('Failed to show ad', value: error, debugLabel: debugLabel);
    _disposeAd();
    _notifyListeners((listener) => listener.onAdFailedToShow(requestId, error));
  }

  @protected
  void handleAdDismissed(String requestId, RewardedAd ad) {
    debugLog('Ad dismissed', debugLabel: debugLabel);
    _disposeAd();
    _notifyListeners((listener) => listener.onAdDismissed(requestId, ad));
  }

  @protected
  void handleUserEarnedReward(
    String requestId,
    AdWithoutView ad,
    RewardItem reward,
  ) {
    debugLog('User earned reward', value: reward, debugLabel: debugLabel);

    _notifyListeners(
        (listener) => listener.onUserEarnedReward(requestId, reward));
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
