// Dart imports:
import 'dart:async';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tlogger/logger.dart';
import 'package:rxdart/rxdart.dart';

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

  final _adImpressionController = PublishSubject<DateTime>();

  Stream<DateTime> get onAdImpression => _adImpressionController.stream;

  FastAdmobInterstitialAdService({this.adInfo}) {
    _logger = _manager.getLogger(_debugLabel);
  }

  void dispose() {
    _manager.removeLogger(_debugLabel);
    _interstitialAd?.dispose();
  }

  /// The ad unit ID for the Interstitial ad.
  String? get _adUnitId => adInfo?.interstitialAdUnitId;

  /// The ad unit IDs for the splash ad.
  List<String>? get _adUnitIds {
    final units = adInfo?.interstitialAdUnits;

    if (units == null) return null;

    return [units.high, units.medium, units.low]
        .where((element) => element != null)
        .cast<String>()
        .toList();
  }

  /// Whether an ad is available to be shown.
  bool get isAdAvailable => _interstitialAd != null;

  Future<bool>? _loadAdFuture;

  /// Loads an InterstitialAd.
  /// Returns `true` if the ad was loaded successfully, `false` otherwise.
  /// [whiteList]: A list of allowed countries for ad requests.
  /// [timeout]: The duration after which the ad request will time out.
  /// [country]: The user's country for ad targeting.
  Future<bool> loadAd({
    List<String>? whiteList,
    Duration? timeout,
    String? country,
  }) async {
    if (_loadAdFuture != null) return _loadAdFuture!;

    _loadAdFuture = _loadAd(
      whiteList: whiteList,
      timeout: timeout,
      country: country,
    );

    return _loadAdFuture!;
  }

  Future<bool> _loadAd({
    List<String>? whiteList,
    Duration? timeout,
    String? country,
  }) async {
    final canRequestAd = isAdRequestAllowedForCountry(
      country: country,
      whiteList: whiteList,
    );

    if (!canRequestAd) return false;

    List<Future<InterstitialAd?>> adLoadFutures = [];

    if (_adUnitIds != null && _adUnitIds!.isNotEmpty) {
      // Map each ad unit ID to a _requestAd call and collect futures
      adLoadFutures = _adUnitIds!.map((adUnitId) {
        return _requestAd(adUnitId, timeout: timeout);
      }).toList();
    } else if (_adUnitId != null) {
      // Single ad unit ID case
      adLoadFutures.add(_requestAd(_adUnitId!, timeout: timeout));
    }

    // Wait for all ad load attempts to complete
    final results = await Future.wait(adLoadFutures);
    int index = 0;

    // Find the first successfully loaded ad
    for (final ad in results) {
      if (ad != null) {
        final adPriority = FastAdUnits.getAdPriorityByIndex(index);
        _logger.debug('Loaded interstitial ad from $adPriority ad unit.');
        _interstitialAd = ad;

        return true;
      }

      index++;
    }

    _logger.error('Failed to load any interstitial ad.');

    return false;
  }

  /// Requests an InterstitialAd.
  Future<InterstitialAd?> _requestAd(
    String adUnitId, {
    Duration? timeout,
  }) async {
    final completer = Completer<InterstitialAd?>();
    timeout ??= kFastAdDefaultTimeout;

    _logger
      ..debug('Loading Interstitial Ad...')
      ..debug('Ad unit ID: $adUnitId');

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => completer.complete(ad),
        onAdFailedToLoad: (error) {
          _logger.error('Failed to load Interstitial Ad: $error');
          completer.complete(null);
        },
      ),
    );

    return completer.future.timeout(kFastAdDefaultTimeout, onTimeout: () {
      _logger.error('Interstitial Ad load timed out');
      return null;
    }).catchError((error) {
      _logger.error('Failed to load Interstitial Ad: $error');
      return null;
    });
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
        _logger.debug('Failed to show Interstitial Ad: $error');
        _disposeAd(ad);
      },
      onAdImpression: (ad) {
        _logger.debug('Interstitial Ad impression');
        final nowUtc = DateTime.now().toUtc();
        _adImpressionController.add(nowUtc);
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
