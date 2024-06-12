// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart' show kDebugMode;

// Package imports:
import 'package:tlogger/logger.dart';
import 'package:tstore/tstore.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_ad/test_units.dart';

/// A class representing information about FastAd.
class FastAdInfo extends TDocument {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static const _debugLabel = 'FastAdInfo';
  static final _manager = TLoggerManager();

  /// The Ad Unit ID for native ads on Android.
  final String? androidNativeAdUnitId;

  /// The Ad Unit ID for native ads on iOS.
  final String? iosNativeAdUnitId;

  /// The Ad Unit ID for banner ads on Android.
  final String? androidBannerAdUnitId;

  /// The Ad Unit ID for banner ads on iOS.
  final String? iosBannerAdUnitId;

  /// The Ad Unit ID for interstitial ads on Android.
  final String? androidInterstitialAdUnitId;

  /// The Ad Unit ID for interstitial ads on iOS.
  final String? iosInterstitialAdUnitId;

  /// The Ad Unit ID for rewarded ads on Android.
  final String? androidRewardedAdUnitId;

  /// The Ad Unit ID for rewarded ads on iOS.
  final String? iosRewardedAdUnitId;

  /// The Ad Unit ID for splash ads on Android.
  final String? androidSplashAdUnitId;

  /// The Ad Unit ID for splash ads on iOS.
  final String? iosSplashAdUnitId;

  /// The Ad Unit ID for rewarded interstitial ads on Android.
  final String? androidRewardedInterstitialAdUnitId;

  /// The Ad Unit ID for rewarded interstitial ads on iOS.
  final String? iosRewardedInterstitialAdUnitId;

  final FastAdUnits? iosSplashAdUnits;

  final FastAdUnits? androidSplashAdUnits;

  final FastAdUnits? iosInterstitialAdUnits;

  final FastAdUnits? androidInterstitialAdUnits;

  final FastAdUnits? iosRewardedAdUnits;

  final FastAdUnits? androidRewardedAdUnits;

  final FastAdUnits? iosNativeAdUnits;

  final FastAdUnits? androidNativeAdUnits;

  /// The list of keywords associated with the ads.
  final List<String>? keywords;

  /// The list of countries targeted for the ads.
  final List<String>? countries;

  /// The threshold value for splash ads.
  final int splashAdThreshold;

  /// The threshold value for interstitial ads.
  final int interstitialAdThreshold;

  /// The authority of the ad service URI.
  final String? adServiceUriAuthority;

  /// The refresh interval for ads. The default value is 90 seconds.
  final int refreshInterval;

  /// Whether the ads should be refreshed automatically.
  final bool autoRefresh;

  /// Whether the ads should show a link to remove ads.
  final bool showRemoveAdLink;

  final bool androidNativeAdmobEnabled;

  final bool iosNativeAdmobEnabled;

  final int splashAdTimeThreshold;

  /// Get the Ad Unit ID based on the platform and ad type.
  String? getAdUnitId(
    String adType,
    String? iosUnitId,
    String? androidUnitId,
  ) {
    if (Platform.isIOS || Platform.isAndroid) {
      if (Platform.isIOS) {
        return kDebugMode ? kFastAdmobTestUnitsIOS[adType] : iosUnitId;
      }

      return kDebugMode ? kFastAdmobTestUnitsAndroid[adType] : androidUnitId;
    }

    return null;
  }

  FastAdUnits? getAdUnits(
    String adType,
    FastAdUnits? iosUnits,
    FastAdUnits? androidUnits,
  ) {
    if (Platform.isIOS || Platform.isAndroid) {
      if (Platform.isIOS) {
        return kDebugMode ? kFastAdmobTestAdUnitsIOS[adType] : iosUnits;
      }

      return kDebugMode ? kFastAdmobTestAdUnitsAndroid[adType] : androidUnits;
    }

    return null;
  }

  /// Get the Ad Unit ID for native ads.
  String? get nativeAdUnitId =>
      getAdUnitId('Native', iosNativeAdUnitId, androidNativeAdUnitId);

  /// Get the Ad Unit ID for banner ads.
  String? get bannerAdUnitId =>
      getAdUnitId('Banner', iosBannerAdUnitId, androidBannerAdUnitId);

  /// Get the Ad Unit ID for interstitial ads.
  String? get interstitialAdUnitId => getAdUnitId(
      'Interstitial', iosInterstitialAdUnitId, androidInterstitialAdUnitId);

  /// Get the Ad Unit ID for rewarded ads.
  String? get rewardedAdUnitId =>
      getAdUnitId('Rewarded', iosRewardedAdUnitId, androidRewardedAdUnitId);

  /// Get the Ad Unit ID for splash ads.
  String? get splashAdUnitId =>
      getAdUnitId('Splash', iosSplashAdUnitId, androidSplashAdUnitId);

  /// Get the Ad Unit ID for rewarded interstitial ads.
  String? get rewardedInterstitialAdUnitId => getAdUnitId(
      'RewardedInterstitial',
      iosRewardedInterstitialAdUnitId,
      androidRewardedInterstitialAdUnitId);

  FastAdUnits? get splashAdUnits => getAdUnits(
        'Splash',
        iosSplashAdUnits,
        androidSplashAdUnits,
      );

  FastAdUnits? get interstitialAdUnits => getAdUnits(
        'Interstitial',
        iosInterstitialAdUnits,
        androidInterstitialAdUnits,
      );

  FastAdUnits? get rewardedAdUnits => getAdUnits(
        'Rewarded',
        iosRewardedAdUnits,
        androidRewardedAdUnits,
      );

  FastAdUnits? get nativeAdUnits => getAdUnits(
        'Native',
        iosNativeAdUnits,
        androidNativeAdUnits,
      );

  bool get nativeAdmobEnabled {
    if (Platform.isAndroid) return androidNativeAdmobEnabled;
    if (Platform.isIOS) return iosNativeAdmobEnabled;

    return false;
  }

  /// Create a new [FastAdInfo] instance.
  const FastAdInfo({
    this.androidNativeAdUnitId,
    this.iosNativeAdUnitId,
    this.androidBannerAdUnitId,
    this.iosBannerAdUnitId,
    this.androidInterstitialAdUnitId,
    this.iosInterstitialAdUnitId,
    this.androidRewardedAdUnitId,
    this.iosRewardedAdUnitId,
    this.androidSplashAdUnitId,
    this.iosSplashAdUnitId,
    this.androidRewardedInterstitialAdUnitId,
    this.iosRewardedInterstitialAdUnitId,
    this.keywords,
    this.countries,
    this.adServiceUriAuthority,
    this.splashAdThreshold = kFastSplashAdThreshold,
    this.refreshInterval = kFastAdRefreshInterval,
    this.autoRefresh = kFastAdAutoRefresh,
    this.showRemoveAdLink = kFastAdShowRemoveAdLink,
    this.androidNativeAdmobEnabled = kFastNativeAdmobEnabled,
    this.iosNativeAdmobEnabled = kFastNativeAdmobEnabled,
    this.interstitialAdThreshold = kFastInterstitialAdThreshold,
    this.splashAdTimeThreshold = kFastAdSplashAdTimeThreshold,
    this.androidSplashAdUnits,
    this.iosSplashAdUnits,
    this.androidInterstitialAdUnits,
    this.iosInterstitialAdUnits,
    this.androidRewardedAdUnits,
    this.iosRewardedAdUnits,
    this.androidNativeAdUnits,
    this.iosNativeAdUnits,
  });

  /// Create a new [FastAdInfo] instance from a JSON map.
  factory FastAdInfo.fromJson(Map<String, dynamic> json) {
    return FastAdInfo(
      androidNativeAdUnitId: json['androidNativeAdUnitId'] as String?,
      iosNativeAdUnitId: json['iosNativeAdUnitId'] as String?,
      androidBannerAdUnitId: json['androidBannerAdUnitId'] as String?,
      iosBannerAdUnitId: json['iosBannerAdUnitId'] as String?,
      androidInterstitialAdUnitId:
          json['androidInterstitialAdUnitId'] as String?,
      iosInterstitialAdUnitId: json['iosInterstitialAdUnitId'] as String?,
      androidRewardedAdUnitId: json['androidRewardedAdUnitId'] as String?,
      iosRewardedAdUnitId: json['iosRewardedAdUnitId'] as String?,
      androidSplashAdUnitId: json['androidSplashAdUnitId'] as String?,
      iosSplashAdUnitId: json['iosSplashAdUnitId'] as String?,
      androidRewardedInterstitialAdUnitId:
          json['androidRewardedInterstitialAdUnitId'] as String?,
      iosRewardedInterstitialAdUnitId:
          json['iosRewardedInterstitialAdUnitId'] as String?,
      countries: json['countries'] as List<String>?,
      keywords: json['keywords'] as List<String>?,
      splashAdThreshold:
          json['splashAdThreshold'] as int? ?? kFastSplashAdThreshold,
      adServiceUriAuthority: json['adServiceUriAuthority'] as String?,
      refreshInterval:
          json['refreshInterval'] as int? ?? kFastAdRefreshInterval,
      showRemoveAdLink:
          json['showRemoveAdLink'] as bool? ?? kFastAdShowRemoveAdLink,
      autoRefresh: json['autoRefresh'] as bool? ?? kFastAdAutoRefresh,
      androidNativeAdmobEnabled:
          json['nativeAdmobEnabled'] as bool? ?? kFastNativeAdmobEnabled,
      iosNativeAdmobEnabled:
          json['nativeAdmobEnabled'] as bool? ?? kFastNativeAdmobEnabled,
      interstitialAdThreshold: json['interstitialAdThreshold'] as int? ??
          kFastInterstitialAdThreshold,
      splashAdTimeThreshold:
          json['splashAdTimeThreshold'] as int? ?? kFastAdSplashAdTimeThreshold,
      iosSplashAdUnits: FastAdUnits.fromJson(
        json['iosSplashAdUnits'] as Map<String, dynamic>?,
      ),
      androidSplashAdUnits: FastAdUnits.fromJson(
        json['androidSplashAdUnits'] as Map<String, dynamic>?,
      ),
      iosInterstitialAdUnits: FastAdUnits.fromJson(
        json['iosInterstitialAdUnits'] as Map<String, dynamic>?,
      ),
      androidInterstitialAdUnits: FastAdUnits.fromJson(
        json['androidInterstitialAdUnits'] as Map<String, dynamic>?,
      ),
      iosRewardedAdUnits: FastAdUnits.fromJson(
        json['iosRewardedAdUnits'] as Map<String, dynamic>?,
      ),
      androidRewardedAdUnits: FastAdUnits.fromJson(
        json['androidRewardedAdUnits'] as Map<String, dynamic>?,
      ),
      iosNativeAdUnits: FastAdUnits.fromJson(
        json['iosNativeAdUnits'] as Map<String, dynamic>?,
      ),
      androidNativeAdUnits: FastAdUnits.fromJson(
        json['androidNativeAdUnits'] as Map<String, dynamic>?,
      ),
    );
  }

  /// Creates a new [FastAdInfo] instance as a copy of the current instance.
  @override
  FastAdInfo clone() => copyWith();

  /// Creates a new [FastAdInfo] instance with the provided properties.
  @override
  FastAdInfo copyWith({
    String? androidNativeAdUnitId,
    String? iosNativeAdUnitId,
    String? androidBannerAdUnitId,
    String? iosBannerAdUnitId,
    String? androidInterstitialAdUnitId,
    String? iosInterstitialAdUnitId,
    String? androidRewardedAdUnitId,
    String? iosRewardedAdUnitId,
    String? androidSplashAdUnitId,
    String? iosSplashAdUnitId,
    String? androidRewardedInterstitialAdUnitId,
    String? iosRewardedInterstitialAdUnitId,
    List<String>? keywords,
    List<String>? countries,
    int? splashAdThreshold,
    String? adServiceUriAuthority,
    int? refreshInterval,
    bool? autoRefresh,
    bool? showRemoveAdLink,
    bool? androidNativeAdmobEnabled,
    bool? iosNativeAdmobEnabled,
    int? interstitialAdThreshold,
    int? splashAdTimeThreshold,
    FastAdUnits? androidSplashAdUnits,
    FastAdUnits? iosSplashAdUnits,
    FastAdUnits? androidInterstitialAdUnits,
    FastAdUnits? iosInterstitialAdUnits,
    FastAdUnits? androidRewardedAdUnits,
    FastAdUnits? iosRewardedAdUnits,
    FastAdUnits? androidNativeAdUnits,
    FastAdUnits? iosNativeAdUnits,
  }) =>
      FastAdInfo(
        iosNativeAdUnitId: iosNativeAdUnitId ?? this.iosNativeAdUnitId,
        keywords: keywords ?? this.keywords,
        androidNativeAdUnitId:
            androidNativeAdUnitId ?? this.androidNativeAdUnitId,
        countries: countries ?? this.countries,
        iosBannerAdUnitId: iosBannerAdUnitId ?? this.iosBannerAdUnitId,
        androidBannerAdUnitId:
            androidBannerAdUnitId ?? this.androidBannerAdUnitId,
        iosInterstitialAdUnitId:
            iosInterstitialAdUnitId ?? this.iosInterstitialAdUnitId,
        androidInterstitialAdUnitId:
            androidInterstitialAdUnitId ?? this.androidInterstitialAdUnitId,
        iosRewardedAdUnitId: iosRewardedAdUnitId ?? this.iosRewardedAdUnitId,
        androidRewardedAdUnitId:
            androidRewardedAdUnitId ?? this.androidRewardedAdUnitId,
        iosSplashAdUnitId: iosSplashAdUnitId ?? this.iosSplashAdUnitId,
        androidSplashAdUnitId:
            androidSplashAdUnitId ?? this.androidSplashAdUnitId,
        iosRewardedInterstitialAdUnitId: iosRewardedInterstitialAdUnitId ??
            this.iosRewardedInterstitialAdUnitId,
        androidRewardedInterstitialAdUnitId:
            androidRewardedInterstitialAdUnitId ??
                this.androidRewardedInterstitialAdUnitId,
        splashAdThreshold: splashAdThreshold ?? this.splashAdThreshold,
        adServiceUriAuthority:
            adServiceUriAuthority ?? this.adServiceUriAuthority,
        refreshInterval: refreshInterval ?? this.refreshInterval,
        autoRefresh: autoRefresh ?? this.autoRefresh,
        showRemoveAdLink: showRemoveAdLink ?? this.showRemoveAdLink,
        androidNativeAdmobEnabled:
            androidNativeAdmobEnabled ?? this.androidNativeAdmobEnabled,
        iosNativeAdmobEnabled:
            iosNativeAdmobEnabled ?? this.iosNativeAdmobEnabled,
        interstitialAdThreshold:
            interstitialAdThreshold ?? this.interstitialAdThreshold,
        splashAdTimeThreshold:
            splashAdTimeThreshold ?? this.splashAdTimeThreshold,
        androidSplashAdUnits: iosSplashAdUnits ?? this.androidSplashAdUnits,
        iosSplashAdUnits: iosSplashAdUnits ?? this.iosSplashAdUnits,
        androidInterstitialAdUnits:
            androidInterstitialAdUnits ?? this.androidInterstitialAdUnits,
        iosInterstitialAdUnits:
            iosInterstitialAdUnits ?? this.iosInterstitialAdUnits,
        androidRewardedAdUnits:
            androidRewardedAdUnits ?? this.androidRewardedAdUnits,
        iosRewardedAdUnits: iosRewardedAdUnits ?? this.iosRewardedAdUnits,
        androidNativeAdUnits: androidNativeAdUnits ?? this.androidNativeAdUnits,
        iosNativeAdUnits: iosNativeAdUnits ?? this.iosNativeAdUnits,
      );

  /// Merges the properties of another [FastAdInfo] instance into this one.
  @override
  FastAdInfo merge(covariant FastAdInfo model) {
    return copyWith(
      androidNativeAdUnitId: model.androidNativeAdUnitId,
      iosNativeAdUnitId: model.iosNativeAdUnitId,
      keywords: model.keywords,
      countries: model.countries,
      iosBannerAdUnitId: model.iosBannerAdUnitId,
      androidBannerAdUnitId: model.androidBannerAdUnitId,
      iosInterstitialAdUnitId: model.iosInterstitialAdUnitId,
      androidInterstitialAdUnitId: model.androidInterstitialAdUnitId,
      iosRewardedAdUnitId: model.iosRewardedAdUnitId,
      androidRewardedAdUnitId: model.androidRewardedAdUnitId,
      iosSplashAdUnitId: model.iosSplashAdUnitId,
      androidSplashAdUnitId: model.androidSplashAdUnitId,
      iosRewardedInterstitialAdUnitId: model.iosRewardedInterstitialAdUnitId,
      androidRewardedInterstitialAdUnitId:
          model.androidRewardedInterstitialAdUnitId,
      splashAdThreshold: model.splashAdThreshold,
      adServiceUriAuthority: model.adServiceUriAuthority,
      refreshInterval: model.refreshInterval,
      autoRefresh: model.autoRefresh,
      showRemoveAdLink: model.showRemoveAdLink,
      androidNativeAdmobEnabled: model.androidNativeAdmobEnabled,
      iosNativeAdmobEnabled: model.iosNativeAdmobEnabled,
      interstitialAdThreshold: model.interstitialAdThreshold,
      splashAdTimeThreshold: model.splashAdTimeThreshold,
      androidSplashAdUnits: model.androidSplashAdUnits,
      iosSplashAdUnits: model.iosSplashAdUnits,
      androidInterstitialAdUnits: model.androidInterstitialAdUnits,
      iosInterstitialAdUnits: model.iosInterstitialAdUnits,
      androidRewardedAdUnits: model.androidRewardedAdUnits,
      iosRewardedAdUnits: model.iosRewardedAdUnits,
      androidNativeAdUnits: model.androidNativeAdUnits,
      iosNativeAdUnits: model.iosNativeAdUnits,
    );
  }

  /// Convert the [FastAdInfo] instance to a JSON map.
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'androidNativeAdUnitId': androidNativeAdUnitId,
        'iosNativeAdUnitId': iosNativeAdUnitId,
        'androidBannerAdUnitId': androidBannerAdUnitId,
        'iosBannerAdUnitId': iosBannerAdUnitId,
        'androidInterstitialAdUnitId': androidInterstitialAdUnitId,
        'iosInterstitialAdUnitId': iosInterstitialAdUnitId,
        'androidRewardedAdUnitId': androidRewardedAdUnitId,
        'iosRewardedAdUnitId': iosRewardedAdUnitId,
        'androidSplashAdUnitId': androidSplashAdUnitId,
        'iosSplashAdUnitId': iosSplashAdUnitId,
        'androidRewardedInterstitialAdUnitId':
            androidRewardedInterstitialAdUnitId,
        'iosRewardedInterstitialAdUnitId': iosRewardedInterstitialAdUnitId,
        'countries': countries,
        'keywords': keywords,
        'splashAdThreshold': splashAdThreshold,
        'adServiceUriAuthority': adServiceUriAuthority,
        'refreshInterval': refreshInterval,
        'autoRefresh': autoRefresh,
        'showRemoveAdLink': showRemoveAdLink,
        'androidNativeAdmobEnabled': androidNativeAdmobEnabled,
        'iosNativeAdmobEnabled': iosNativeAdmobEnabled,
        'interstitialAdThreshold': interstitialAdThreshold,
        'splashAdTimeThreshold': splashAdTimeThreshold,
        'androidSplashAdUnits': androidSplashAdUnits?.toJson(),
        'iosSplashAdUnits': iosSplashAdUnits?.toJson(),
        'androidInterstitialAdUnits': androidInterstitialAdUnits?.toJson(),
        'iosInterstitialAdUnits': iosInterstitialAdUnits?.toJson(),
        'androidRewardedAdUnits': androidRewardedAdUnits?.toJson(),
        'iosRewardedAdUnits': iosRewardedAdUnits?.toJson(),
        'androidNativeAdUnits': androidNativeAdUnits?.toJson(),
        'iosNativeAdUnits': iosNativeAdUnits?.toJson(),
        ...super.toJson(),
      };

  /// Returns a list of properties used to determine if two [FastAdInfo]
  /// instances are equal.
  @override
  List<Object?> get props => [
        androidNativeAdUnitId,
        iosNativeAdUnitId,
        androidBannerAdUnitId,
        iosBannerAdUnitId,
        androidInterstitialAdUnitId,
        iosInterstitialAdUnitId,
        androidRewardedAdUnitId,
        iosRewardedAdUnitId,
        androidSplashAdUnitId,
        iosSplashAdUnitId,
        androidRewardedInterstitialAdUnitId,
        iosRewardedInterstitialAdUnitId,
        keywords,
        countries,
        splashAdThreshold,
        adServiceUriAuthority,
        refreshInterval,
        autoRefresh,
        showRemoveAdLink,
        androidNativeAdmobEnabled,
        iosNativeAdmobEnabled,
        interstitialAdThreshold,
        splashAdTimeThreshold,
        androidSplashAdUnits,
        iosSplashAdUnits,
        androidInterstitialAdUnits,
        iosInterstitialAdUnits,
        androidRewardedAdUnits,
        iosRewardedAdUnits,
        androidNativeAdUnits,
        iosNativeAdUnits,
      ];

  /// Print the values of properties in debug mode.
  void debug({String? debugLabel}) {
    if (kDebugMode) {
      _logger
        ..info('androidNativeAdUnitId', androidNativeAdUnitId)
        ..info('iosNativeAdUnitId', iosNativeAdUnitId)
        ..info('androidBannerAdUnitId', androidBannerAdUnitId)
        ..info('iosBannerAdUnitId', iosBannerAdUnitId)
        ..info('androidInterstitialAdUnitId', androidInterstitialAdUnitId)
        ..info('iosInterstitialAdUnitId', iosInterstitialAdUnitId)
        ..info('androidRewardedAdUnitId', androidRewardedAdUnitId)
        ..info('iosRewardedAdUnitId', iosRewardedAdUnitId)
        ..info('androidSplashAdUnitId', androidSplashAdUnitId)
        ..info('iosSplashAdUnitId', iosSplashAdUnitId)
        ..info(
          'androidRewardedInterstitialAdUnitId',
          androidRewardedInterstitialAdUnitId,
        )
        ..info(
          'iosRewardedInterstitialAdUnitId',
          iosRewardedInterstitialAdUnitId,
        )
        ..info('keywords', keywords)
        ..info('countries', countries)
        ..info('splashAdThreshold', splashAdThreshold)
        ..info('adServiceUriAuthority', adServiceUriAuthority)
        ..info('interstitialAdThreshold', interstitialAdThreshold)
        ..info('refreshInterval', refreshInterval)
        ..info('autoRefresh', autoRefresh)
        ..info('showRemoveAdLink', showRemoveAdLink)
        ..info('androidNativeAdmobEnabled', androidNativeAdmobEnabled)
        ..info('iosNativeAdmobEnabled', iosNativeAdmobEnabled)
        ..info('splashAdTimeThreshold', splashAdTimeThreshold)
        ..info('androidSplashAdUnits', androidSplashAdUnits)
        ..info('iosSplashAdUnits', iosSplashAdUnits)
        ..info('interstitialAdThreshold', interstitialAdThreshold)
        ..info('androidInterstitialAdUnits', androidInterstitialAdUnits)
        ..info('iosInterstitialAdUnits', iosInterstitialAdUnits)
        ..info('androidRewardedAdUnits', androidRewardedAdUnits)
        ..info('iosRewardedAdUnits', iosRewardedAdUnits)
        ..info('androidNativeAdUnits', androidNativeAdUnits)
        ..info('iosNativeAdUnits', iosNativeAdUnits);
    }
  }
}
