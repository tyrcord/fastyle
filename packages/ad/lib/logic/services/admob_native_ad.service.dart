// Dart imports:
import 'dart:async';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

/// This class provides functionality to request native ads from AdMob.
class FastAdmobNativeAdService {
  /// The minimum number of impressions required before starting to watch
  /// clicks.
  static const int startWatchingClickThreshold = 2;

  /// A list of countries that are allowed for ad requests.
  static final List<String> countryWhiteList = [];

  /// The singleton instance of [FastAdmobNativeAdService].
  static FastAdmobNativeAdService? _singleton;

  /// The hard limit (in milliseconds) after which a new ad request is allowed.
  /// default: 30 minutes.
  static const int hardRequestLimit = 30 * 60 * 1000;

  /// The soft limit (in milliseconds) after which a new ad request is allowed.
  /// default: 300 milliseconds.
  static const int softRequestLimit = 300;

  /// The maximum click-through rate (CTR) ratio allowed (0.1 = 10% of clicks).
  /// default: 10%.
  static const double maxCtrRatio = 0.1;

  /// Journal to keep track of ad actions and their counters.
  final _journal = <FastAdAction, int>{};

  /// Private constructor for singleton implementation.
  FastAdmobNativeAdService._();

  /// Get the singleton instance of [FastAdmobNativeAdService].
  factory FastAdmobNativeAdService() {
    _singleton ??= FastAdmobNativeAdService._();

    return _singleton!;
  }

  /// Requests a native ad with the specified parameters.
  ///
  /// Returns the loaded ad view if the ad request is successful within the
  /// timeout, otherwise returns `null`.
  ///
  /// [adUnitID]: The ad unit ID for the requested ad.
  /// [keywords]: List of keywords to be used in the ad request.
  /// [country]: The user's country for ad targeting.
  /// [countryWhiteList]: A list of allowed countries for ad requests.
  Future<AdWithView?> requestAd(
    String adUnitID, {
    List<String>? keywords,
    String? country,
    List<String>? countryWhiteList,
  }) async {
    if (_canRequestAd(country: country, whiteList: countryWhiteList)) {
      final adView = await retry<NativeAd?>(
        task: () async => _requestAd(adUnitID, keywords: keywords),
        taskTimeout: kFastAdDefaultTimeout,
        maxAttempts: 2,
      );

      if (adView != null) {
        _setLimitOnAdRequest();

        return adView;
      }
    }

    return null;
  }

  Future<NativeAd?> _requestAd(
    String adUnitID, {
    Duration? timeout,
    List<String>? keywords,
  }) async {
    final completer = Completer<bool>();
    final adView = NativeAd(
      request: AdRequest(keywords: keywords),
      factoryId: 'mediumBanner',
      adUnitId: adUnitID,
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) => completer.complete(true),
        onAdImpression: handleAdImpression,
        onAdClicked: handleAdClicked,
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          completer.complete(false);
        },
      ),
    )..load();

    final isAdLoaded = await completer.future.timeout(
      timeout ?? kFastAdDefaultTimeout,
      onTimeout: _handleTimeoutEnd,
    );

    return isAdLoaded ? adView : null;
  }

  /// Handles the ad click action.
  void handleAdClicked(Ad ad) {
    _logAction(
      FastAdAction.nativeClicked,
      increment: true,
    );
    _setHardRequestLimitIfNeeded();
  }

  /// Handles the ad impression action.
  void handleAdImpression(ad) {
    _logAction(
      FastAdAction.nativePrinted,
      increment: true,
    );
  }

  /// Checks if an ad request is allowed for the given country.
  ///
  /// [country]: The user's country for ad targeting.
  /// [whiteList]: A list of allowed countries for ad requests.
  bool _canRequestAd({String? country, List<String>? whiteList}) {
    const nativeLoaded = FastAdAction.nativeLimit;
    final waitForNewRequest = _journal[nativeLoaded];
    final canRequestAd = isAdRequestAllowedForCountry(
      country: country,
      whiteList: whiteList,
    );

    if (canRequestAd) {
      if (waitForNewRequest != null) {
        final now = DateTime.now().toUtc().millisecondsSinceEpoch;

        return now > waitForNewRequest;
      }

      return true;
    }

    return false;
  }

  /// Sets a new ad request limit based on the type of request (soft or hard).
  ///
  /// [hard]: If true, a hard limit will be set; otherwise, a soft limit
  /// will be set.
  void _setLimitOnAdRequest({bool hard = false}) {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    final waitFor = hard ? hardRequestLimit : softRequestLimit;
    final limit = now + waitFor;

    _logAction(FastAdAction.nativeLimit, value: limit);
  }

  /// Sets a hard ad request limit if the click-through rate (CTR) ratio
  /// exceeds the maximum allowed.
  void _setHardRequestLimitIfNeeded() {
    final ctrRatio = _getCtrRatio();

    if (ctrRatio > maxCtrRatio) {
      _setLimitOnAdRequest(hard: true);

      _logAction(
        FastAdAction.nativeClicked,
        value: 0,
      );

      _logAction(
        FastAdAction.nativePrinted,
        value: 0,
      );
    }
  }

  /// Logs an ad action and its associated counter.
  ///
  /// [action]: The name of the ad action.
  /// [increment]: If true, increments the counter for the given action;
  /// otherwise, a specific [value] can be provided.
  /// [value]: The specific value to set the counter for the given action.
  int _logAction(FastAdAction action, {bool? increment, int? value}) {
    late int entry;

    if (value != null) {
      entry = value;
    } else {
      final counter = _journal[action] ?? 0;
      entry = counter + 1;
    }

    return _journal.update(action, (_) => entry, ifAbsent: () => entry);
  }

  /// Calculates the click-through rate (CTR) ratio.
  ///
  /// Returns the CTR ratio, or 0 if there are insufficient impression and
  /// click data.
  double _getCtrRatio() {
    const nativeClicked = FastAdAction.nativeClicked;
    const nativePrinted = FastAdAction.nativePrinted;
    final impressionCounter = _journal[nativePrinted];
    final clickCounter = _journal[nativeClicked];

    if (clickCounter != null &&
        impressionCounter != null &&
        impressionCounter > startWatchingClickThreshold &&
        clickCounter > startWatchingClickThreshold) {
      return clickCounter / impressionCounter;
    }

    return 0;
  }

  /// Handles the timeout when waiting for the ad request to complete.
  ///
  /// Returns `false` to indicate that the ad request timed out.
  Future<bool> _handleTimeoutEnd() async => false;
}
