import 'dart:convert';

import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:http/http.dart' as http;

/// A service class to interact with the Fastyle Ad API.
class AdService {
  static const _defaultAdsPath = '/api/ads/default/';
  static const _adsPath = '/api/ads/';

  final String baseUrl;

  /// Constructs an instance of [AdService] with the provided [baseUrl].
  AdService(this.baseUrl);

  /// Retrieves an advertisement by its ID from the API.
  ///
  /// Returns a [FastResponseAd] object if the ad with the given [adId] exists,
  /// otherwise returns null.
  Future<FastResponseAd?> getAdById(String adId) async {
    final path = '$_adsPath$adId';
    final uri = Uri.https(baseUrl, path);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      // Check if the response contains valid data as a Map.
      if (jsonData is Map<String, dynamic>) {
        return FastResponseAd.fromJson(jsonData);
      }
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
    int? limit,
  }) async {
    final path = '${_adsPath}language/$language';
    final queryParameters = <String, dynamic>{
      if (limit != null) 'limit': limit.toString(),
    };
    final uri = Uri.https(baseUrl, path, queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      return (jsonData as List)
          .whereType<Map<String, dynamic>>()
          .map((data) => FastResponseAd.fromJson(data))
          .toList();
    }

    return [];
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
    final path = '${_adsPath}country/$country/language/$language';
    final queryParameters = <String, dynamic>{
      if (appId != null) 'appId': appId,
      if (providerId != null) 'providerId': providerId,
      if (limit != null) 'limit': limit.toString(),
    };

    final uri = Uri.https(baseUrl, path, queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      return (jsonData as List)
          .whereType<Map<String, dynamic>>()
          .map((data) => FastResponseAd.fromJson(data))
          .toList();
    }

    return [];
  }

  /// Retrieves a list of default advertisements by language from the API.
  ///
  /// The [language] parameter specifies the language of the default ads to be
  /// fetched. Optionally, you can specify the [appId], [providerId],
  /// and [limit] parameters to filter the results.
  /// Returns a list of [FastResponseAd] objects that match the given criteria.
  Future<List<FastResponseAd>> getDefaultAdsByLanguage({
    String language = 'en',
    String? appId,
    String? providerId,
    int? limit,
  }) async {
    final path = '$_defaultAdsPath/language/$language';
    final queryParameters = <String, dynamic>{
      if (appId != null) 'appId': appId,
      if (providerId != null) 'providerId': providerId,
      if (limit != null) 'limit': limit.toString(),
    };

    final uri = Uri.https(baseUrl, path, queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      return (jsonData as List)
          .whereType<Map<String, dynamic>>()
          .map((data) => FastResponseAd.fromJson(data))
          .toList();
    }

    return [];
  }
}
