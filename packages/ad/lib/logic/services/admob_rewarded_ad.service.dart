// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:uuid/uuid.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

/// Controller for a Rewarded ad.
class FastAdmobRewardedAdService {
  static const _debugLabel = 'FastAdmobRewardedAdService';
  static final _manager = TLoggerManager();
  static const uuid = Uuid();

  static FastAdmobRewardedAdService? _singleton;

  /// Information about the ad.
  final FastAdInfo? adInfo;

  final List<AdEventListener> _listeners = [];

  late final TLogger _logger;

  /// The loaded rewarded ad.
  RewardedAd? _rewardedAd;

  /// The user's country.
  final String? userCountry;

  /// Whether an ad is available to be shown.
  bool get isAdAvailable => _rewardedAd != null;

  /// The ad unit ID for the rewarded ad.
  String? get rewardedAdUnitId => adInfo?.rewardedAdUnitId;

  List<String>? get rewardedAdUnitIds {
    final units = adInfo?.rewardedAdUnits;

    if (units == null) return null;

    return [units.high, units.medium, units.low]
        .where((element) => element != null)
        .cast<String>()
        .toList();
  }

  factory FastAdmobRewardedAdService(
    FastAdInfo? adInfo, {
    String? userCountry,
  }) {
    _singleton ??= FastAdmobRewardedAdService._(
      adInfo,
      userCountry: userCountry,
    );

    return _singleton!;
  }

  /// Creates a new [FastAdmobRewardedAdService] with the given [adInfo].
  FastAdmobRewardedAdService._(
    this.adInfo, {
    this.userCountry,
  }) {
    _logger = _manager.getLogger(_debugLabel);
  }

  void dispose() {
    _manager.removeLogger(_debugLabel);
    _rewardedAd?.dispose();
  }

  /// Loads a RewardedAd.
  ///
  /// This method loads a rewarded ad with the provided ad unit ID and sets up
  /// the full screen content callbacks to handle ad display and events.
  Future<String?> loadAd({
    List<String>? adUnitIds,
    String? adUnitId,
    String? country,
  }) async {
    country ??= userCountry;
    _rewardedAd = null;

    // Prioritize single adUnitId if provided
    if (adUnitId != null) {
      _logger.debug('Loading rewarded ad from ad unit ID.');
      final requestId = await _requestAd(adUnitId, country);

      if (requestId != null) return requestId;
    }

    // Otherwise, load from adUnitIds
    if (adUnitIds != null) {
      _logger.debug('Loading rewarded ad from ad unit IDs.');
      final requestId = await _requestAds(adUnitIds, country);

      if (requestId != null) return requestId;
    }

    // Fallback to adInfo if no adUnitId or adUnitIds provided
    if (rewardedAdUnitIds != null) {
      _logger.debug('Loading rewarded ad from default ad unit IDs.');
      final requestId = await _requestAds(rewardedAdUnitIds!, country);

      if (requestId != null) return requestId;
    }

    // Fallback to adUnitId if no adUnitIds provided
    if (rewardedAdUnitId != null) {
      _logger.debug('Loading rewarded ad from default ad unit ID.');
      final requestId = await _requestAd(rewardedAdUnitId!, country);

      if (requestId != null) return requestId;
    }

    _logger.warning('No ad unit ID provided for RewardedAd.');

    return null;
  }

  Future<String?> _requestAds(
    List<String> adUnitIds,
    String? country,
  ) async {
    final canRequestAd = isAdRequestAllowedForCountry(
      country: country,
    );

    if (!canRequestAd || adUnitIds.isEmpty) return null;

    final requestId = uuid.v4();

    final adLoadFutures = adUnitIds.map((adUnitId) async {
      final completer = Completer<RewardedAd?>();

      await RewardedAd.load(
        request: const AdRequest(),
        adUnitId: adUnitId,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdFailedToLoad: (error) => completer.complete(null),
          onAdLoaded: (ad) => completer.complete(ad),
        ),
      );

      return completer.future;
    }).toList();

    // Wait for all ad load attempts to complete
    Future.wait(adLoadFutures).then((results) {
      int index = 0;

      // Find the first successfully loaded ad
      for (final ad in results) {
        if (ad != null) {
          final adPriority = FastAdUnits.getAdPriorityByIndex(index);
          _logger.debug('Loaded rewarded ad from $adPriority ad unit.');
          handleAdLoaded(requestId, ad);
          break;
        }

        index++;
      }
    });

    return requestId;
  }

  Future<String?> _requestAd(String adUnitId, String? country) async {
    final canRequestAd = isAdRequestAllowedForCountry(
      // FIXME: define white list for rewarded ads
      // whiteList: adInfo?.countries,
      country: country,
    );

    if (!canRequestAd) return null;

    final requestId = uuid.v4();

    await RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => handleAdLoaded(requestId, ad),
        onAdFailedToLoad: (error) => handleAdFailedToLoad(requestId, error),
      ),
    );

    return requestId;
  }

  /// Shows the rewarded ad if it is available.
  ///
  /// Does nothing if the ad is not available or already being shown.
  void showAdIfAvailable(String requestId) {
    if (!isAdAvailable) {
      _logger.debug('Tried to show ad before it was available.');

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
    _logger.debug('Ad loaded');

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
    _logger.warning('RewardedAd failed to load with error: $error');
    _notifyListeners((listener) => listener.onAdFailedToLoad(requestId, error));
  }

  @protected
  void handleAdShowed(String requestId, RewardedAd ad) {
    _logger.debug('Ad showed');
    _notifyListeners((listener) => listener.onAdShowed(requestId, ad));
  }

  @protected
  void handleAdImpression(String requestId, RewardedAd ad) {
    _logger.debug('Ad impression');
    _notifyListeners((listener) => listener.onAdImpression(requestId, ad));
  }

  @protected
  void handleAdClicked(String requestId, RewardedAd ad) {
    _logger.debug('Ad clicked');
    _notifyListeners((listener) => listener.onAdClicked(requestId, ad));
  }

  @protected
  void handleAdFailedToShow(String requestId, RewardedAd ad, AdError error) {
    _logger.warning('Failed to show ad with error: $error');
    _disposeAd();
    _notifyListeners((listener) => listener.onAdFailedToShow(requestId, error));
  }

  @protected
  void handleAdDismissed(String requestId, RewardedAd ad) {
    _logger.debug('Ad dismissed');
    _disposeAd();
    _notifyListeners((listener) => listener.onAdDismissed(requestId, ad));
  }

  @protected
  void handleUserEarnedReward(
    String requestId,
    AdWithoutView ad,
    RewardItem reward,
  ) {
    _logger.debug('User earned reward ${reward.amount} ${reward.type}');

    _notifyListeners(
      (listener) => listener.onUserEarnedReward(requestId, reward),
    );
  }

  /// Disposes of the current rewarded ad.
  void _disposeAd() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }

  void _notifyListeners(Function(AdEventListener listener) callback) {
    for (final listener in _listeners) {
      callback(listener);
    }
  }
}
