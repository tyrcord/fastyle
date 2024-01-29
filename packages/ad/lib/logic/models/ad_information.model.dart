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

  /// The list of keywords associated with the ads.
  final List<String>? keywords;

  /// The list of countries targeted for the ads.
  final List<String>? countries;

  /// The threshold value for splash ads.
  final int splashAdThreshold;

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

  /// Get the Ad Unit ID for native ads.
  String? get nativeAdUnitId {
    if (Platform.isIOS || Platform.isAndroid) {
      if (Platform.isIOS) {
        return kDebugMode
            ? kFastAdmobTestUnitsIOS['Native']
            : iosNativeAdUnitId;
      }

      return kDebugMode
          ? kFastAdmobTestUnitsAndroid['Native']
          : androidNativeAdUnitId;
    }

    return null;
  }

  /// Get the Ad Unit ID for banner ads.
  String? get bannerAdUnitId {
    if (Platform.isIOS || Platform.isAndroid) {
      if (Platform.isIOS) {
        return kDebugMode
            ? kFastAdmobTestUnitsIOS['Banner']
            : iosBannerAdUnitId;
      }

      return kDebugMode
          ? kFastAdmobTestUnitsAndroid['Banner']
          : androidBannerAdUnitId;
    }

    return null;
  }

  /// Get the Ad Unit ID for interstitial ads.
  String? get interstitialAdUnitId {
    if (Platform.isIOS || Platform.isAndroid) {
      if (Platform.isIOS) {
        return kDebugMode
            ? kFastAdmobTestUnitsIOS['Interstitial']
            : iosInterstitialAdUnitId;
      }

      return kDebugMode
          ? kFastAdmobTestUnitsAndroid['Interstitial']
          : androidInterstitialAdUnitId;
    }

    return null;
  }

  /// Get the Ad Unit ID for rewarded ads.
  String? get rewardedAdUnitId {
    if (Platform.isIOS || Platform.isAndroid) {
      if (Platform.isIOS) {
        return kDebugMode
            ? kFastAdmobTestUnitsIOS['Rewarded']
            : iosRewardedAdUnitId;
      }

      return kDebugMode
          ? kFastAdmobTestUnitsAndroid['Rewarded']
          : androidRewardedAdUnitId;
    }

    return null;
  }

  /// Get the Ad Unit ID for splash ads.
  String? get splashAdUnitId {
    if (Platform.isIOS || Platform.isAndroid) {
      if (Platform.isIOS) {
        return kDebugMode
            ? kFastAdmobTestUnitsIOS['Splash']
            : iosSplashAdUnitId;
      }

      return kDebugMode
          ? kFastAdmobTestUnitsAndroid['Splash']
          : androidSplashAdUnitId;
    }

    return null;
  }

  /// Get the Ad Unit ID for rewarded interstitial ads.
  String? get rewardedInterstitialAdUnitId {
    if (Platform.isIOS || Platform.isAndroid) {
      if (Platform.isIOS) {
        return kDebugMode
            ? kFastAdmobTestUnitsIOS['RewardedInterstitial']
            : iosRewardedInterstitialAdUnitId;
      }

      return kDebugMode
          ? kFastAdmobTestUnitsAndroid['RewardedInterstitial']
          : androidRewardedInterstitialAdUnitId;
    }

    return null;
  }

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
        ..info('interstitialAdThreshold', interstitialAdThreshold);
    }
  }
}
