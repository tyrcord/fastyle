// Package imports:
import 'package:tmodel/tmodel.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

/// The [FastResponseAd] class represents a fast response advertisement,
/// extending the [TModel] base class. It contains properties that describe
/// the ad's language, title, description, image, URL, ranking, video,
/// discount, button, and price.
class FastResponseAd extends TModel {
  /// The language of the ad.
  final String language;

  /// The title of the ad.
  final String title;

  /// The description of the ad.
  final String description;

  /// The image asset associated with the ad.
  final FastResponseAdAsset image;

  /// The URL linked to the ad.
  final String url;

  /// The ranking associated with the ad.
  final FastResponseAdRanking? ranking;

  /// The video asset associated with the ad.
  final FastResponseAdAsset? video;

  /// The discount text associated with the ad.
  final String? discount;

  /// The text displayed on the button associated with the ad.
  final String? button;

  /// The price text associated with the ad.
  final String? price;

  final FastResponseAdMerchant? merchant;

  /// Creates a [FastResponseAd] object with the given properties.
  const FastResponseAd({
    required this.language,
    required this.title,
    required this.description,
    required this.image,
    required this.url,
    this.ranking,
    this.video,
    this.discount,
    this.merchant,
    this.button,
    this.price,
  });

  /// Creates a [FastResponseAd] object from a JSON map.
  factory FastResponseAd.fromJson(Map<String, dynamic> json) {
    late FastResponseAdAsset image;
    FastResponseAdRanking? ranking;
    FastResponseAdAsset? video;
    FastResponseAdMerchant? merchant;

    if (json['image'] is Map<String, dynamic>) {
      image = FastResponseAdAsset.fromJson(
        json['image'] as Map<String, dynamic>,
      );
    } else {
      // it should never happen
      image = FastResponseAdAsset.empty();
    }

    if (json['ranking'] is Map<String, dynamic>) {
      ranking = FastResponseAdRanking.fromJson(
        json['ranking'] as Map<String, dynamic>,
      );
    }

    if (json['video'] is Map<String, dynamic>) {
      video = FastResponseAdAsset.fromJson(
        json['video'] as Map<String, dynamic>,
      );
    }

    if (json['merchant'] is Map<String, dynamic>) {
      merchant = FastResponseAdMerchant.fromJson(
        json['merchant'] as Map<String, dynamic>,
      );
    }

    return FastResponseAd(
      language: json['language'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      discount: json['discount'] as String?,
      button: json['button'] as String?,
      price: json['price'] as String?,
      merchant: merchant,
      ranking: ranking,
      video: video,
      image: image,
    );
  }

  /// Creates a new [FastResponseAd] object with the same properties.
  @override
  FastResponseAd clone() {
    return FastResponseAd(
      merchant: merchant?.clone(),
      ranking: ranking?.clone(),
      description: description,
      video: video?.clone(),
      image: image.clone(),
      language: language,
      discount: discount,
      button: button,
      price: price,
      title: title,
      url: url,
    );
  }

  /// Creates a new [FastResponseAd] object with the specified properties
  /// replaced by the provided values.
  @override
  FastResponseAd copyWith({
    String? language,
    String? title,
    String? description,
    FastResponseAdAsset? image,
    String? url,
    FastResponseAdMerchant? merchant,
    FastResponseAdRanking? ranking,
    FastResponseAdAsset? video,
    String? discount,
    String? button,
    String? price,
  }) {
    return FastResponseAd(
      language: language ?? this.language,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      url: url ?? this.url,
      ranking: ranking ?? this.ranking,
      video: video ?? this.video,
      discount: discount ?? this.discount,
      merchant: merchant ?? this.merchant,
      button: button ?? this.button,
      price: price ?? this.price,
    );
  }

  /// Merges the properties of the provided [model] into a new [FastResponseAd]
  /// object.
  @override
  FastResponseAd merge(covariant FastResponseAd model) {
    return copyWith(
      language: model.language,
      title: model.title,
      description: model.description,
      image: model.image,
      url: model.url,
      ranking: model.ranking,
      video: model.video,
      merchant: model.merchant,
      discount: model.discount,
      button: model.button,
      price: model.price,
    );
  }

  /// Returns a list of properties used for comparing [FastResponseAd] objects.
  @override
  List<Object?> get props => [
        language,
        title,
        description,
        image,
        merchant,
        url,
        ranking,
        video,
        discount,
        button,
        price,
      ];
}
