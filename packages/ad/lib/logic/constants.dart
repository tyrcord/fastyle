// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

/// The default timeout for loading ads.
/// Default is 15 seconds.
const kFastAdDefaultTimeout = Duration(seconds: 15);

/// The default refresh interval for ads.
/// Default is 300 seconds.
const kFastAdRefreshInterval = 300;

/// The threshold for showing a splash ad.
/// Default is 3 app launches.
const kFastSplashAdThreshold = 3;

/// The default time to keep in cache the ad service response.
const kFastAdServiceCacheTTL = Duration(minutes: 60);

/// The default time to keep in cache the ad service response in debug mode.
const kFastAdServiceCacheTTLDebug = Duration(minutes: 5);

const kFastAdAutoRefresh = false;

const kFastAdShowRemoveAdLink = false;

const kFastNativeAdmobEnabled = true;

const kFastAdRewardedBlockDuration = Duration(seconds: 5);

const kFastNativeAdAssetSizes = {
  FastAdSize.small: 60.0,
  FastAdSize.medium: 120.0,
  FastAdSize.large: 192.0,
};

const kFastNativeAdContainerHeights = {
  FastAdSize.small: 60.0,
  FastAdSize.medium: 120.0,
  FastAdSize.large: 340.0,
};
