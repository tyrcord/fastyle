// Package imports:
import 'package:tstore/tstore.dart';

/// Represents a fast dictionary entry entity.
class FastDictEntryEntity extends TEntity {
  /// The name of the dictionary entry.
  final String name;

  /// The value of the dictionary entry.
  final dynamic value;

  /// Constructs a [FastDictEntryEntity] instance.
  ///
  /// The [name] parameter is required and represents the name of the dictionary
  /// entry. The [value] parameter is required and represents the value of the
  /// dictionary entry.
  const FastDictEntryEntity({
    required this.name,
    this.value,
  });

  /// Creates a [FastDictEntryEntity] instance from a JSON object.
  factory FastDictEntryEntity.fromJson(Map<String, dynamic> json) {
    return FastDictEntryEntity(
      name: json['name'] as String,
      value: json['value'],
    );
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'value': value,
      };

  @override
  FastDictEntryEntity copyWith({
    String? name,
    dynamic value,
  }) =>
      FastDictEntryEntity(
        name: name ?? this.name,
        value: value ?? this.value,
      );

  @override
  FastDictEntryEntity merge(covariant FastDictEntryEntity model) {
    return copyWith(
      name: model.name,
      value: model.value,
    );
  }

  @override
  FastDictEntryEntity clone() => copyWith();

  @override
  List<Object?> get props => [name, value];
}
