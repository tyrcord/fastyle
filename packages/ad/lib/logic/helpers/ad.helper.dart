// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

/// Determines if an ad request is allowed based on the user's country and a
/// whitelist of allowed countries.
///
/// Returns `true` if the ad request is allowed, `false` otherwise.
///
/// The [country] parameter is a two-letter country code in ISO 3166-1 alpha-2
/// format. If it is `null`, the country is considered unknown and the function
/// will return `true`.
///
/// The [whiteList] parameter is a list of two-letter country codes in ISO
/// 3166-1 alpha-2 format. If it is `null` or empty, all countries are allowed.
bool isAdRequestAllowedForCountry({
  String? country,
  List<String>? whiteList,
}) {
  // Input validation
  if (country == null || whiteList == null || whiteList.isEmpty) {
    return true;
  }

  // Normalize inputs to lowercase for consistent comparisons
  final normalizedCountry = country.toLowerCase();
  final normalizedWhiteList =
      whiteList.map((code) => code.toLowerCase()).toSet();

  return normalizedWhiteList.contains(normalizedCountry);
}

Widget getNativeAdLoadingWidget(FastAdSize adSize) {
  if (adSize == FastAdSize.medium) {
    return const FastLoadingNativeAd();
  } else if (adSize == FastAdSize.large) {
    return const FastLoadingNativeAd(adSize: FastAdSize.large);
  }

  return const FastLoadingNativeAd(adSize: FastAdSize.small);
}
