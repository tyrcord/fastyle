import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_images/fastyle_images.dart';
import 'package:flutter/material.dart';
import 'package:t_helpers/helpers.dart';

Widget? buildFlagIconForFinancialInstrument(
  String instrument, {
  Widget Function(String)? flagIconBuilder,
  bool hasShadow = true,
  double? height,
  double? width,
}) {
  final iconKey = toCamelCase(instrument);

  final isCountry = kFastImageFlagMap.containsKey(iconKey);

  if (isCountry) {
    return buildFlagIconForCountry(
      instrument,
      flagIconBuilder: flagIconBuilder,
      hasShadow: hasShadow,
      height: height,
      width: width,
    );
  }

  final isCommodity = kFastImageCommodityMap.containsKey(iconKey);

  if (isCommodity) {
    return buildFlagIconForCommodity(
      instrument,
      flagIconBuilder: flagIconBuilder,
      hasShadow: hasShadow,
      height: height,
      width: width,
    );
  }

  final isCrypto = kFastImageCryptoMap.containsKey(iconKey);

  if (isCrypto) {
    return buildFlagIconForCrypto(
      instrument,
      flagIconBuilder: flagIconBuilder,
      hasShadow: hasShadow,
      height: height,
      width: width,
    );
  }

  debugLog('No flag icon found for instrument: $instrument');

  return null;
}

Widget? buildFlagIconForCountry(
  String key, {
  Widget Function(String)? flagIconBuilder,
  bool hasShadow = true,
  double? height,
  double? width,
}) {
  final iconKey = toCamelCase(key);
  final hasIcon = kFastImageFlagMap.containsKey(iconKey);

  if (!hasIcon) {
    debugLog('No flag icon found for country: $key');
    return null;
  }

  return buildFlagIcon(
    key,
    kFastImageFlagMap,
    flagIconBuilder: flagIconBuilder,
    hasShadow: hasShadow,
    height: height,
    width: width,
  );
}

Widget? buildFlagIconForCommodity(
  String key, {
  Widget Function(String)? flagIconBuilder,
  bool hasShadow = true,
  double? height,
  double? width,
}) {
  final iconKey = toCamelCase(key);
  final hasIcon = kFastImageCommodityMap.containsKey(iconKey);

  if (!hasIcon) {
    debugLog('No flag icon found for commodity: $key');
    return null;
  }

  return buildFlagIcon(
    key,
    kFastImageCommodityMap,
    flagIconBuilder: flagIconBuilder,
    hasShadow: hasShadow,
    height: height,
    width: width,
  );
}

Widget? buildFlagIconForCrypto(
  String key, {
  Widget Function(String)? flagIconBuilder,
  bool hasShadow = true,
  double? height,
  double? width,
}) {
  final iconKey = toCamelCase(key);
  final hasIcon = kFastImageCryptoMap.containsKey(iconKey);

  if (!hasIcon) {
    debugLog('No flag icon found for crypto: $key');
    return null;
  }

  return buildFlagIcon(
    key,
    kFastImageCryptoMap,
    flagIconBuilder: flagIconBuilder,
    hasShadow: hasShadow,
    height: height,
    width: width,
  );
}

Widget? buildFlagIcon(
  String key,
  Map<String, String> iconMap, {
  Widget Function(String)? flagIconBuilder,
  bool hasShadow = true,
  double? height,
  double? width,
}) {
  final iconKey = toCamelCase(key);
  late Widget flagIcon;

  if (flagIconBuilder != null) {
    flagIcon = flagIconBuilder(key);
  } else {
    flagIcon = FastImageAsset(
      path: iconMap[iconKey]!,
      height: height,
      width: width,
    );
  }

  if (hasShadow) {
    return FastShadowLayout(
      borderRadius: 0,
      child: flagIcon,
    );
  }

  return flagIcon;
}
