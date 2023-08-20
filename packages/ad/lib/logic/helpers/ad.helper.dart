// Dart imports:
import 'dart:convert';

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

/// Returns a loading widget for native ads based on the provided ad size.
///
/// If [adSize] is [FastAdSize.medium], returns a loading widget for medium ads.
/// If [adSize] is [FastAdSize.large], returns a loading widget for large ads.
/// For any other [adSize], returns a loading widget for small ads.
Widget getNativeAdLoadingWidget(FastAdSize adSize) {
  if (adSize == FastAdSize.medium) {
    return const FastLoadingNativeAd();
  } else if (adSize == FastAdSize.large) {
    return const FastLoadingNativeAd(adSize: FastAdSize.large);
  }

  return const FastLoadingNativeAd(adSize: FastAdSize.small);
}

/// Tries to decode ad data from the provided JSON [data].
///
/// If [data] is not null, attempts to decode it as JSON.
/// If decoding is successful and the resulting JSON object is a valid map,
/// returns a [FastResponseAd] instance created from the JSON data.
/// If any error occurs during decoding or conversion, prints the error
/// and returns null.
FastResponseAd? tryDecodeAd(String? data) {
  if (data != null) {
    try {
      final jsonData = json.decode(data);

      // Check if the response contains valid data as a Map.
      if (jsonData is Map<String, dynamic>) {
        return FastResponseAd.fromJson(jsonData);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  return null;
}

/// Tries to decode a list of advertisements from JSON data.
///
/// Returns a list of [FastResponseAd] objects if the JSON [data] is
/// successfully decoded, otherwise returns null.
List<FastResponseAd>? tryDecodeAds(String? data) {
  if (data != null) {
    try {
      final jsonData = json.decode(data);

      if (jsonData is List) {
        return jsonData
            .whereType<Map<String, dynamic>>()
            .map((data) => FastResponseAd.fromJson(data))
            .toList();
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  return null;
}
