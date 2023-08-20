// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:t_cache/cache_manager.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

/// A service class to interact with the Fastyle Ad API.
class FastAdService {
  static const _adsPath = '/api/ads/';

  /// The authority of the URI to be used for API requests.
  final String uriAuthority;

  /// A cache manager instance to store and retrieve cached responses.
  final _cache = TCacheManager<String>(debugLabel: 'FastAdServiceCacheManager');

  /// The time-to-live duration for cached data.
  late final Duration ttl;

  /// A debug label to be used for debugging purposes.
  final String? debugLabel;

  /// Constructs an instance of [FastAdService] with the provided
  /// [uriAuthority].
  ///
  /// The [uriAuthority] parameter is the authority of the URI to be used for
  /// API requests.
  /// The [debugLabel] parameter is a debug label to be used for debugging
  /// purposes.
  /// The [ttl] parameter is the time-to-live duration for cached data.
  /// If the [ttl] parameter is not provided, the default value is 5 minutes
  /// in debug mode and 60 minutes in release mode.
  /// The [ttl] parameter is ignored in debug mode.
  FastAdService(
    this.uriAuthority, {
    this.debugLabel = 'FastAdService',
    Duration? ttl,
  }) {
    if (kDebugMode) {
      this.ttl = kFastAdServiceCacheTTLDebug;
    } else {
      this.ttl = ttl ?? kFastAdServiceCacheTTL;
    }
  }

  /// This method is used to release the resources used by the [FastAdService]
  /// instance. It should be called when the [FastAdService] instance is no
  /// longer needed.
  ///
  /// - Disposes of the cache manager instance.
  void dispose() {
    _cache.dispose();
  }

  /// Retrieves an advertisement by its ID from the API.
  ///
  /// Returns a [FastResponseAd] object if the ad with the given [adId] exists,
  /// otherwise returns null.
  Future<FastResponseAd?> getAdById(String adId) async {
    debugLog('Fetching ad with ID: $adId', debugLabel: debugLabel);

    final cachedAd = await _getCachedAd(adId);

    if (cachedAd != null) {
      return cachedAd;
    }

    final path = '$_adsPath$adId';
    final uri = Uri.https(uriAuthority, path);

    try {
      final response = await _requestAd(uri);

      if (response.statusCode == 200) {
        final ad = await compute(tryDecodeAd, response.body);

        if (ad != null) {
          _cache.put(adId, response.body, ttl: ttl);

          return ad;
        }
      }
    } catch (e) {
      debugLog('Failed to fetch ads: $e', debugLabel: debugLabel);
    }

    return null;
  }

  /// Retrieves a list of advertisements by language from the API.
  ///
  /// The [language] parameter specifies the language of the ads to be fetched.
  /// Optionally, you can specify the maximum number of ads to be returned with
  /// the [limit] parameter.
  /// Returns a list of [FastResponseAd] objects that match the given criteria.
  Future<List<FastResponseAd>> getAdsByLanguage(
    String language, {
    String? providerId,
    String? appId,
    int? limit,
  }) async {
    final cachedAds = await _getCachedAds(
      language,
      providerId: providerId,
      appId: appId,
      limit: limit,
    );

    if (cachedAds != null && cachedAds.isNotEmpty) {
      return cachedAds;
    }

    return _fetchAds(
      language,
      providerId: providerId,
      appId: appId,
      limit: limit,
    );
  }

  /// Retrieves an advertisement by language from the API.
  ///
  /// Returns a [FastResponseAd] object if an ad with the specified [language],
  /// [appId], and [providerId] exists, otherwise returns null.
  Future<FastResponseAd?> getAdByLanguage(
    String language, {
    String? appId,
    String? providerId,
    int? limit,
  }) async {
    final ads = await getAdsByLanguage(
      language,
      providerId: providerId,
      appId: appId,
      limit: limit,
    );

    return getRandomItem<FastResponseAd>(ads);
  }

  /// Retrieves a list of advertisements by country and language from the API.
  ///
  /// The [country] and [language] parameters specify the country and language
  /// of the ads to be fetched. Optionally, you can specify the [appId],
  /// [providerId], and [limit] parameters to filter the results.
  /// Returns a list of [FastResponseAd] objects that match the given criteria.
  Future<List<FastResponseAd>> getAdsByCountryAndLanguage(
    String country,
    String language, {
    String? appId,
    String? providerId,
    int? limit,
  }) async {
    final cachedAds = await _getCachedAds(
      language,
      providerId: providerId,
      country: country,
      appId: appId,
      limit: limit,
    );

    if (cachedAds != null && cachedAds.isNotEmpty) {
      return cachedAds;
    }

    return _fetchAds(
      language,
      providerId: providerId,
      country: country,
      appId: appId,
      limit: limit,
    );
  }

  /// Retrieves an advertisement by country and language from the API.
  ///
  /// Returns a [FastResponseAd] object if an ad with the specified [country],
  /// [language], [appId], and [providerId] exists, otherwise returns null.
  Future<FastResponseAd?> getAdByCountryAndLanguage(
    String country,
    String language, {
    String? providerId,
    String? appId,
    int? limit,
  }) async {
    final ads = await getAdsByCountryAndLanguage(
      country,
      language,
      providerId: providerId,
      appId: appId,
      limit: limit,
    );

    return getRandomItem<FastResponseAd>(ads);
  }

  /// Retrieves a list of advertisements by language from the API.
  ///
  /// The [language] parameter specifies the language of the ads to be fetched.
  /// Optionally, you can specify the [country], [appId], [providerId], and
  /// [limit] parameters to filter the results.
  /// Returns a list of [FastResponseAd] objects that match the given criteria.
  Future<List<FastResponseAd>> _fetchAds(
    String language, {
    String? country,
    String? appId,
    String? providerId,
    int? limit,
  }) async {
    debugLog(
      'Fetching ads by language and country: $language, $country',
      debugLabel: debugLabel,
    );

    final path = _buildAdsPath(language, country: country);
    final queryParameters = <String, dynamic>{
      if (appId != null) 'appId': appId,
      if (providerId != null) 'providerId': providerId,
      if (limit != null) 'limit': limit.toString(),
    };

    final uri = Uri.https(uriAuthority, path, queryParameters);

    try {
      final response = await _requestAd(uri);

      if (response.statusCode == 200) {
        final ads = await compute(tryDecodeAds, response.body);

        if (ads != null && ads.isNotEmpty) {
          final cacheId = _buildCacheIdForAds(
            language,
            providerId: providerId,
            country: country,
            appId: appId,
            limit: limit,
          );

          _cache.put(cacheId, response.body, ttl: ttl); // Cache the fetched ads

          return ads;
        }
      }
    } catch (e) {
      debugLog('Failed to fetch ads: $e', debugLabel: debugLabel);
    }

    return [];
  }

  /// Retrieves a cached advertisement by its ID if available.
  ///
  /// Returns a [FastResponseAd] object if the ad with the given [adId] is
  /// available in the cache, otherwise returns null.
  Future<FastResponseAd?> _getCachedAd(String adId) async {
    debugLog('Fetching cached ad by ID: $adId', debugLabel: debugLabel);

    final data = _cache.get(adId);

    return compute(tryDecodeAd, data);
  }

  /// Retrieves cached advertisements that match the specified criteria.
  ///
  /// Returns a list of [FastResponseAd] objects that match the given
  /// [language], [country], [appId], [providerId], and [limit]. Returns null
  /// if no cached data matches the criteria.
  Future<List<FastResponseAd>?> _getCachedAds(
    String language, {
    String? country,
    String? appId,
    String? providerId,
    int? limit,
  }) async {
    if (country != null) {
      debugLog(
        'Fetching cached ads by country: $country '
        'and language: $language',
        debugLabel: debugLabel,
      );
    } else {
      debugLog(
        'Fetching cached ads by language: $language',
        debugLabel: debugLabel,
      );
    }

    final cacheId = _buildCacheIdForAds(
      language,
      providerId: providerId,
      country: country,
      appId: appId,
      limit: limit,
    );

    final data = _cache.get(cacheId);

    return compute(tryDecodeAds, data);
  }

  /// Builds a cache ID for advertisements based on the specified criteria.
  ///
  /// Returns a cache ID string based on the [language], [country], [appId],
  /// [providerId], and [limit].
  String _buildCacheIdForAds(
    String language, {
    String? country,
    String? appId,
    String? providerId,
    int? limit,
  }) {
    final StringBuffer buffer = StringBuffer(language);

    if (country != null) buffer.write("_$country");
    if (appId != null) buffer.write("_$appId");
    if (providerId != null) buffer.write("_$providerId");
    if (limit != null) buffer.write("_$limit");

    return buffer.toString();
  }

  /// Builds the path for fetching advertisements based on language and country.
  ///
  /// Returns the constructed path string for fetching advertisements based on
  /// the specified [language] and optional [country].
  String _buildAdsPath(String language, {String? country}) {
    final StringBuffer buffer = StringBuffer(_adsPath);

    if (country != null) buffer.write('country/$country/');

    buffer.write("language/$language");

    return buffer.toString();
  }

  /// Requests an ad from the API.
  /// Returns the response of the request.
  /// Throws an exception if the request fails.
  /// Throws a [TimeoutException] if the request takes longer than the
  /// specified timeout. The default timeout is 15 seconds.
  Future<http.Response> _requestAd(Uri url) {
    return http.get(url).timeout(kFastAdDefaultTimeout);
  }
}
