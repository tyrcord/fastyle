import 'package:t_helpers/helpers.dart';
import 'package:tmodel/tmodel.dart';

/// A class representing a fast response ad asset with different sizes.
/// This class extends the `TModel` class.
class FastResponseAdAsset extends TModel {
  /// The URL of the small-sized ad asset.
  final String? small;

  /// The URL of the medium-sized ad asset.
  final String? medium;

  /// The URL of the large-sized ad asset.
  final String? large;

  /// Constructor for creating a [FastResponseAdAsset] object.
  const FastResponseAdAsset({
    this.small,
    this.medium,
    this.large,
  });

  /// Factory constructor to create a [FastResponseAdAsset] object from a
  /// JSON map.
  factory FastResponseAdAsset.fromJson(Map<String, dynamic> json) {
    var small = json['small'] as String?;
    var medium = json['medium'] as String?;
    var large = json['large'] as String?;

    if (small == null || !isValidUrl(small)) {
      small = null;
    }

    if (medium == null || !isValidUrl(medium)) {
      medium = null;
    }

    if (large == null || !isValidUrl(large)) {
      large = null;
    }

    return FastResponseAdAsset(small: small, medium: medium, large: large);
  }

  /// Factory constructor to create an empty [FastResponseAdAsset] object.
  factory FastResponseAdAsset.empty() {
    return const FastResponseAdAsset(small: '', medium: '', large: '');
  }

  /// Creates a copy of the [FastResponseAdAsset] object.
  @override
  FastResponseAdAsset clone() => copyWith();

  /// Creates a new [FastResponseAdAsset] object by copying the existing object
  /// and optionally updating some of its properties.
  ///
  /// [small], [medium], and [large] parameters can be used to override the
  /// corresponding properties, otherwise, the current values are used.
  @override
  FastResponseAdAsset copyWith({
    String? small,
    String? medium,
    String? large,
  }) {
    return FastResponseAdAsset(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
    );
  }

  /// Merges the properties of another [FastResponseAdAsset] model with this
  /// one.
  ///
  /// This method creates a new [FastResponseAdAsset] object with properties
  /// from the given model, overriding the properties specified in the [model].
  @override
  FastResponseAdAsset merge(covariant FastResponseAdAsset model) {
    return copyWith(
      small: model.small,
      medium: model.medium,
      large: model.large,
    );
  }

  /// Provides a list of the [FastResponseAdAsset] object's properties.
  @override
  List<Object?> get props => [small, medium, large];
}
