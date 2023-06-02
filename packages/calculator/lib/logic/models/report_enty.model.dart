import 'package:flutter/material.dart';
import 'package:tmodel/tmodel.dart';

class FastReportEntry extends TModel {
  final String name;
  final String value;
  final Color? color;

  const FastReportEntry({
    required this.name,
    required this.value,
    this.color,
  });

  @override
  FastReportEntry clone() => copyWith();

  @override
  FastReportEntry copyWith({
    String? name,
    String? value,
    Color? color,
  }) {
    return FastReportEntry(
      name: name ?? this.name,
      value: value ?? this.value,
      color: color ?? this.color,
    );
  }

  @override
  FastReportEntry merge(covariant FastReportEntry model) {
    return copyWith(
      name: model.name,
      value: model.value,
      color: model.color,
    );
  }

  @override
  List<Object?> get props => [name, value, color];
}
