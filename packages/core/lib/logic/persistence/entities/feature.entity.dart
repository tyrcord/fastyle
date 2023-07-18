// Package imports:
import 'package:tstore/tstore.dart';

/// Represents a fast feature entity.
class FastFeatureEntity extends TEntity {
  /// The name of the feature entity.
  final String name;

  /// Indicates whether the feature is enabled.
  final bool isEnabled;

  /// Indicates whether the feature is activated.
  final bool isActivated;

  /// Constructs a [FastFeatureEntity] instance.
  ///
  /// The [name] parameter is required and represents the name of the feature
  /// entity. The [isActivated] and [isEnabled] parameters are optional and
  /// default to `false` if not provided.
  const FastFeatureEntity({
    required this.name,
    bool? isActivated,
    bool? isEnabled,
  })  : isActivated = isActivated ?? false,
        isEnabled = isEnabled ?? false;

  /// Creates a [FastFeatureEntity] instance from a JSON object.
  factory FastFeatureEntity.fromJson(Map<String, dynamic> json) {
    return FastFeatureEntity(
      isActivated: json['isActivated'] as bool,
      isEnabled: json['isEnabled'] as bool,
      name: json['name'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'isActivated': isActivated,
        'isEnabled': isEnabled,
        'name': name,
      };

  @override
  FastFeatureEntity copyWith({
    String? name,
    bool? isEnabled,
    bool? isActivated,
  }) =>
      FastFeatureEntity(
        isActivated: isActivated ?? this.isActivated,
        isEnabled: isEnabled ?? this.isEnabled,
        name: name ?? this.name,
      );

  @override
  FastFeatureEntity merge(covariant FastFeatureEntity model) {
    return copyWith(
      name: model.name,
      isEnabled: model.isEnabled,
      isActivated: model.isActivated,
    );
  }

  @override
  FastFeatureEntity clone() => copyWith();

  @override
  List<Object?> get props => [name, isEnabled, isActivated];
}
