import 'package:fastyle_ad/logic/models/ad_units.util.dart';

const kFastAdmobTestUnitsIOS = {
  'Interstitial': 'ca-app-pub-3940256099942544/5135589807',
  'Rewarded': 'ca-app-pub-3940256099942544/1712485313',
  'Native': 'ca-app-pub-3940256099942544/2521693316',
  'Banner': 'ca-app-pub-3940256099942544/2934735716',
  'Splash': 'ca-app-pub-3940256099942544/9257395921',
  'RewardedInterstitial': 'ca-app-pub-3940256099942544/6978759866',
};

const kFastAdmobTestUnitsAndroid = {
  'Interstitial': 'ca-app-pub-3940256099942544/8691691433',
  'Rewarded': 'ca-app-pub-3940256099942544/5224354917',
  'Native': 'ca-app-pub-3940256099942544/1044960115',
  'Banner': 'ca-app-pub-3940256099942544/6300978111',
  'Splash': 'ca-app-pub-3940256099942544/9257395921',
  'RewardedInterstitial': 'ca-app-pub-3940256099942544/5354046379',
};

const kFastAdmobTestInterstitialAdUnitsIOS = FastAdUnits(
  high: 'ca-app-pub-3940256099942544/5135589807',
  medium: 'ca-app-pub-3940256099942544/5135589807',
  low: 'ca-app-pub-3940256099942544/5135589807',
);

const kFastAdmobTestInterstitialAdUnitsAndroid = FastAdUnits(
  high: 'ca-app-pub-3940256099942544/8691691433',
  medium: 'ca-app-pub-3940256099942544/8691691433',
  low: 'ca-app-pub-3940256099942544/8691691433',
);

const kFastAdmobTestRewardedAdUnitsIOS = FastAdUnits(
  high: 'ca-app-pub-3940256099942544/1712485313',
  medium: 'ca-app-pub-3940256099942544/1712485313',
  low: 'ca-app-pub-3940256099942544/1712485313',
);

const kFastAdmobTestRewardedAdUnitsAndroid = FastAdUnits(
  high: 'ca-app-pub-3940256099942544/5224354917',
  medium: 'ca-app-pub-3940256099942544/5224354917',
  low: 'ca-app-pub-3940256099942544/5224354917',
);

const kFastAdmobTestNativeAdUnitsIOS = FastAdUnits(
  high: 'ca-app-pub-3940256099942544/2521693316',
  medium: 'ca-app-pub-3940256099942544/2521693316',
  low: 'ca-app-pub-3940256099942544/2521693316',
);

const kFastAdmobTestNativeAdUnitsAndroid = FastAdUnits(
  high: 'ca-app-pub-3940256099942544/1044960115',
  medium: 'ca-app-pub-3940256099942544/1044960115',
  low: 'ca-app-pub-3940256099942544/1044960115',
);

const kFastAdmobTestSplashAdUnitsIOS = FastAdUnits(
  high: 'ca-app-pub-3940256099942544/9257395921',
  medium: 'ca-app-pub-3940256099942544/9257395921',
  low: 'ca-app-pub-3940256099942544/9257395921',
);

const kFastAdmobTestSplashAdUnitsAndroid = FastAdUnits(
  high: 'ca-app-pub-3940256099942544/9257395921',
  medium: 'ca-app-pub-3940256099942544/9257395921',
  low: 'ca-app-pub-3940256099942544/9257395921',
);

const kFastAdmobTestAdUnitsAndroid = {
  'Interstitial': kFastAdmobTestInterstitialAdUnitsAndroid,
  'Rewarded': kFastAdmobTestRewardedAdUnitsAndroid,
  'Native': kFastAdmobTestNativeAdUnitsAndroid,
  'Splash': kFastAdmobTestSplashAdUnitsAndroid,
};

const kFastAdmobTestAdUnitsIOS = {
  'Interstitial': kFastAdmobTestInterstitialAdUnitsIOS,
  'Rewarded': kFastAdmobTestRewardedAdUnitsIOS,
  'Native': kFastAdmobTestNativeAdUnitsIOS,
  'Splash': kFastAdmobTestSplashAdUnitsIOS,
};
