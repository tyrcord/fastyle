// Dart imports:
import 'dart:async';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tlogger/logger.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

/// Controller for Interstitial ads.
class FastAdmobInterstitialAdService {
  static const _debugLabel = 'FastAdmobInterstitialAdService';
  static final _manager = TLoggerManager();

  /// Information about the ad.
  final FastAdInfo? adInfo;

  late final TLogger _logger;

  /// The loaded Interstitial ad.
  InterstitialAd? _interstitialAd;

  /// Whether an ad is currently being shown.
  bool _isShowingAd = false;

  FastAdmobInterstitialAdService({this.adInfo}) {
    _logger = _manager.getLogger(_debugLabel);
  }

  void dispose() {
    _manager.removeLogger(_debugLabel);
    _interstitialAd?.dispose();
  }

  /// The ad unit ID for the Interstitial ad.
  String? get _adUnitId => adInfo?.interstitialAdUnitId;

  /// Whether an ad is available to be shown.
  bool get isAdAvailable => _interstitialAd != null;

  Future<bool>? _loadAdFuture;

  /// Loads an InterstitialAd.
  ///
  /// Returns `true` if the ad was loaded successfully, `false` otherwise.
  Future<bool> loadAd({
    List<String>? whiteList,
    Duration? timeout,
    String? country,
  }) async {
    final canRequestAd = isAdRequestAllowedForCountry(
      country: country,
      whiteList: whiteList,
    );

    if (canRequestAd && _adUnitId != null) {
      return retry<bool>(
        task: () async => _requestAd(timeout: timeout),
        taskTimeout: kFastAdDefaultTimeout,
        maxAttempts: 2,
      );
    }

    return false;
  }

  Future<bool> _requestAd({Duration? timeout}) async {
    final completer = Completer<bool>();
    final stopwatch = Stopwatch()..start();

    _logger
      ..debug('Loading Interstitial Ad...')
      ..debug('Ad unit ID: $_adUnitId');

    InterstitialAd.load(
      adUnitId: _adUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          stopwatch.stop();
          _logger.debug(
            'Interstitial Ad loaded in ${stopwatch.elapsedMilliseconds}ms',
          );

          _interstitialAd = ad;
          _loadAdFuture = null;
          completer.complete(true);
        },
        onAdFailedToLoad: (error) {
          stopwatch.stop();
          final elapsedTime = stopwatch.elapsedMilliseconds;
          _logger
            ..debug('Interstitial Ad failed to load in ${elapsedTime}ms')
            ..error('Failed to load Interstitial Ad: $error');
          _loadAdFuture = null;
          completer.complete(false);
        },
      ),
    );

    timeout ??= kFastAdDefaultTimeout;

    _loadAdFuture =
        completer.future.timeout(kFastAdDefaultTimeout).catchError((error) {
      _logger.error('Failed to load Interstitial Ad: $error');
      _loadAdFuture = null;

      return false;
    });

    return _loadAdFuture!;
  }

  /// Shows the ad if it is available.
  ///
  /// Does nothing if the ad is not available or is already being shown.
  void showAdIfAvailable() async {
    if (_loadAdFuture != null) {
      _logger.debug('Waiting for ad to load...');
      await _loadAdFuture;
    }

    if (!isAdAvailable) {
      _logger.debug('Tried to show ad before it was available.');

      return;
    }

    if (_isShowingAd) {
      _logger.debug('Tried to show ad while already showing an ad.');

      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => _isShowingAd = true,
      onAdDismissedFullScreenContent: _disposeAd,
      onAdFailedToShowFullScreenContent: (ad, error) {
        _logger.debug('failed to show ad: $error');
        _disposeAd(ad);
      },
    );

    _interstitialAd!.show();
  }

  /// Disposes of the current ad.
  void _disposeAd(InterstitialAd ad) {
    _isShowingAd = false;
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
