// Dart imports:
import 'dart:async';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

/// Controller for a App Open ad.
class FastAdmobSplashAdService {
  static const _debugLabel = 'FastAdmobSplashAdService';
  static final _manager = TLoggerManager();

  /// Information about the ad.
  final FastAdInfo? adInfo;

  late final TLogger _logger;

  /// The loaded splash ad.
  AppOpenAd? _splashAd;

  /// Whether an ad is currently being shown.
  bool _isShowingAd = false;

  final _adImpressionController = PublishSubject<DateTime>();

  Stream<DateTime> get onAdImpression => _adImpressionController.stream;

  /// Creates a new [FastAdmobSplashAdService] with the given [adInfo].
  FastAdmobSplashAdService({this.adInfo}) {
    _logger = _manager.getLogger(_debugLabel);
  }

  void dispose() {
    _manager.removeLogger(_debugLabel);
    _splashAd?.dispose();
  }

  /// The ad unit IDs for the splash ad.
  List<String>? get _adUnitIds {
    if (adInfo == null) return null;

    final metadata = adInfo!.splashAdUnitMetadata;

    if (metadata == null) return null;

    return [
      metadata.high,
      metadata.medium,
      metadata.low,
    ].where((element) => element != null).cast<String>().toList();
  }

  String? get _adUnitId => adInfo?.splashAdUnitId;

  /// Whether an ad is available to be shown.
  bool get isAdAvailable => _splashAd != null;

  Future<AppOpenAd?>? _loadAdFuture;

  /// Loads an AppOpenAd.
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

    if (!canRequestAd) return false;

    List<Future<AppOpenAd?>> adLoadFutures = [];

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

    // Find the first successfully loaded ad
    for (final ad in results) {
      if (ad != null) {
        _splashAd = ad;
        return true;
      }
    }

    _logger.error('Failed to load any splash ad.');

    return false;
  }

  Future<AppOpenAd?> _requestAd(
    String adUnitId, {
    Duration? timeout,
  }) async {
    final completer = Completer<AppOpenAd?>();

    AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _loadAdFuture = null;
          completer.complete(ad);
        },
        onAdFailedToLoad: (error) {
          _logger.error('failed to load ad: $error');
          _loadAdFuture = null;
          completer.complete(null);
        },
      ),
    );

    timeout ??= const Duration(seconds: 30);

    _loadAdFuture = completer.future.timeout(timeout).catchError((error) {
      _logger.error('failed to load ad: $error');
      _loadAdFuture = null;

      return null;
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

    _splashAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => _isShowingAd = true,
      onAdDismissedFullScreenContent: _disposeAd,
      onAdFailedToShowFullScreenContent: (ad, error) {
        _logger.debug('failed to show splash ad: $error');
        _disposeAd(ad);
      },
      onAdImpression: (ad) {
        _logger.debug('Splash ad impression');
        final nowUtc = DateTime.now().toUtc();
        _adImpressionController.add(nowUtc);
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
