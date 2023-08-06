import 'package:t_helpers/helpers.dart';
import 'package:tmodel/tmodel.dart';

class FastResponseAdMerchant extends TModel {
  final String name;
  final String? logo;
  final String? url;

  const FastResponseAdMerchant({
    required this.name,
    this.logo,
    this.url,
  });

  factory FastResponseAdMerchant.fromJson(Map<String, dynamic> json) {
    var logo = json['logo'] as String?;
    var url = json['url'] as String?;

    if (logo == null || !isValidUrl(logo)) {
      logo = null;
    }

    if (url == null || !isValidUrl(url)) {
      url = null;
    }

    return FastResponseAdMerchant(
      name: json['name'] as String,
      logo: logo,
      url: url,
    );
  }

  const FastResponseAdMerchant.empty()
      : name = '',
        logo = '',
        url = '';

  @override
  FastResponseAdMerchant clone() => copyWith();

  @override
  FastResponseAdMerchant copyWith({
    String? name,
    String? logo,
    String? url,
  }) {
    return FastResponseAdMerchant(
      name: name ?? this.name,
      logo: logo ?? this.logo,
      url: url ?? this.url,
    );
  }

  @override
  FastResponseAdMerchant merge(covariant FastResponseAdMerchant model) {
    return copyWith(
      name: model.name,
      logo: model.logo,
      url: model.url,
    );
  }

  @override
  List<Object?> get props => [name, logo, url];
}
