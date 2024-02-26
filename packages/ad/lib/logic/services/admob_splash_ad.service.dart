// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tlogger/logger.dart';
import 'package:t_helpers/helpers.dart';

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

  /// The ad unit ID for the splash ad.
  String? get _adUnitId => adInfo?.splashAdUnitId;

  /// Whether an ad is available to be shown.
  bool get isAdAvailable => _splashAd != null;

  Future<bool>? _loadAdFuture;

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
    final bloc = FastDeviceOrientationBloc();
    final deviceOrientation = bloc.currentState.orientation;
    final adOrientation = deviceOrientation == Orientation.portrait
        ? AppOpenAd.orientationPortrait
        : AppOpenAd.orientationLandscapeRight;
    final stopwatch = Stopwatch()..start();

    _logger.debug(
      'Loading Splash Ad for orientation: ${deviceOrientation.name}',
    );

    AppOpenAd.load(
      adUnitId: _adUnitId!,
      orientation: adOrientation,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          stopwatch.stop();
          _logger.debug(
            'Splash Ad loaded in ${stopwatch.elapsedMilliseconds}ms',
          );

          _splashAd = ad;
          _loadAdFuture = null;
          completer.complete(true);
        },
        onAdFailedToLoad: (error) {
          stopwatch.stop();
          final milliseconds = stopwatch.elapsedMilliseconds;
          _logger
            ..debug('Splash Ad failed to load in $milliseconds ms')
            ..error('failed to load ad: $error');
          _loadAdFuture = null;
          completer.complete(false);
        },
      ),
    );

    timeout ??= const Duration(seconds: 45);

    _loadAdFuture = completer.future.timeout(timeout).catchError((error) {
      _logger.error('failed to load ad: $error');
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
