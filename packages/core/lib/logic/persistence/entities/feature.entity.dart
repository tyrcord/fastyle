// Package imports:
import 'package:tstore/tstore.dart';

/// Represents a fast feature entity.
class FastFeatureEntity extends TEntity {
  /// The name of the feature entity.
  final String name;

  /// Indicates whether the feature is enabled.
  final bool isEnabled;

  /// Constructs a [FastFeatureEntity] instance.
  ///
  /// The [name] parameter is required and represents the name of the feature
  /// entity.
  const FastFeatureEntity({
    required this.name,
    bool? isEnabled,
  }) : isEnabled = isEnabled ?? false;

  /// Creates a [FastFeatureEntity] instance from a JSON object.
  factory FastFeatureEntity.fromJson(Map<String, dynamic> json) {
    return FastFeatureEntity(
      isEnabled: json['isEnabled'] as bool,
      name: json['name'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'isEnabled': isEnabled,
        'name': name,
      };

  @override
  FastFeatureEntity copyWith({
    String? name,
    bool? isEnabled,
  }) =>
      FastFeatureEntity(
        isEnabled: isEnabled ?? this.isEnabled,
        name: name ?? this.name,
      );

  @override
  FastFeatureEntity merge(covariant FastFeatureEntity model) {
    return copyWith(
      name: model.name,
      isEnabled: model.isEnabled,
    );
  }

  @override
  FastFeatureEntity clone() => copyWith();

  @override
  List<Object?> get props => [name, isEnabled];
}
