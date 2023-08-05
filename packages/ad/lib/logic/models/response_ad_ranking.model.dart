import 'package:tmodel/tmodel.dart';

/// A class representing Fast Response Ad Ranking.
/// Extends the `TModel` class from the `tmodel` package.
class FastResponseAdRanking extends TModel {
  /// The value of the ad ranking.
  final double value;

  /// The factor of the ad ranking.
  final int factor;

  /// Creates a [FastResponseAdRanking] instance with the given [value] and
  /// [factor].
  const FastResponseAdRanking({
    required this.value,
    required this.factor,
  });

  /// Factory constructor to create a [FastResponseAdRanking] instance from a
  /// JSON [Map]. Expects the JSON map to have 'value' and 'factor' fields.
  factory FastResponseAdRanking.fromJson(Map<String, dynamic> json) {
    return FastResponseAdRanking(
      value: json['value'] as double,
      factor: json['factor'] as int,
    );
  }

  /// Creates a new instance of [FastResponseAdRanking] with the same [value]
  /// and [factor].
  @override
  FastResponseAdRanking clone() => copyWith();

  /// Creates a new instance of [FastResponseAdRanking] with optional updates to
  /// [value] and/or [factor].
  @override
  FastResponseAdRanking copyWith({
    double? value,
    int? factor,
  }) {
    return FastResponseAdRanking(
      value: value ?? this.value,
      factor: factor ?? this.factor,
    );
  }

  /// Merges the current [FastResponseAdRanking] instance with another
  /// [FastResponseAdRanking] instance. It updates the [value] and [factor] of
  /// the current instance with the values from the [model] instance.
  @override
  FastResponseAdRanking merge(covariant FastResponseAdRanking model) {
    return copyWith(
      value: model.value,
      factor: model.factor,
    );
  }

  /// Returns a list of properties (fields) used to determine the equality of
  /// two [FastResponseAdRanking] instances.
  @override
  List<Object?> get props => [value, factor];
}
