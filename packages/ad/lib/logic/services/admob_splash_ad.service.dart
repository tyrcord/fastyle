import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:fastyle_ad/fastyle_ad.dart';

/// Controller for a App Open ad.
class FastAdmobSplashAdService {
  /// Information about the ad.
  final FastAdInfo? adInfo;

  /// The loaded splash ad.
  AppOpenAd? _splashAd;

  /// Whether an ad is currently being shown.
  bool _isShowingAd = false;

  /// Creates a new [FastAdmobSplashAdService] with the given [adInfo].
  FastAdmobSplashAdService({this.adInfo});

  /// The ad unit ID for the splash ad.
  String? get _adUnitId => adInfo?.splashAdUnitId;

  /// Whether an ad is available to be shown.
  bool get isAdAvailable => _splashAd != null;

  Future<bool>? _loadAdFuture;

  /// Loads an AppOpenAd.
  ///
  /// Returns `true` if the ad was loaded successfully, `false` otherwise.
  Future<bool> loadAd({String? country}) async {
    final canRequestAd = isAdRequestAllowedForCountry(
      country: country,
      whiteList: adInfo?.countries,
    );

    if (canRequestAd && _adUnitId != null) {
      final completer = Completer<bool>();

      AppOpenAd.load(
        adUnitId: _adUnitId!,
        orientation: AppOpenAd.orientationPortrait,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _splashAd = ad;
            completer.complete(true);
            _loadAdFuture = null;
          },
          onAdFailedToLoad: (error) {
            //TODO: Handle the error.
            debugPrint(
              '[FastAdmobSplashAdService] failed to load ad: $error',
            );

            completer.complete(false);
            _loadAdFuture = null;
          },
        ),
      );

      _loadAdFuture = completer.future;

      return _loadAdFuture!;
    }

    return false;
  }

  /// Shows the ad if it is available.
  ///
  /// Does nothing if the ad is not available or is already being shown.
  void showAdIfAvailable() async {
    if (_loadAdFuture != null) {
      debugPrint('[FastAdmobSplashAdService] Waiting for ad to load...');
      await _loadAdFuture;
    }

    if (!isAdAvailable) {
      debugPrint(
        '[FastAdmobSplashAdService] Tried to show ad before it was available.',
      );

      return;
    }

    if (_isShowingAd) {
      debugPrint(
        '[FastAdmobSplashAdService] Tried to show ad while already showing '
        'an ad.',
      );

      return;
    }

    _splashAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => _isShowingAd = true,
      onAdDismissedFullScreenContent: _disposeAd,
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('[FastAdmobSplashAdService] failed to show ad: $error');
        _disposeAd(ad);
      },
    );

    return _splashAd!.show();
  }

  /// Disposes of the current ad.
  void _disposeAd(AppOpenAd ad) {
    _isShowingAd = false;
    _splashAd?.dispose();
    _splashAd = null;
  }
}
