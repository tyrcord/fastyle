// Package imports:
import 'package:tmodel/tmodel.dart';

//TODO: @need-review: code from fastyle_dart

class FastCategory extends TModel {
  ///
  /// Text that describes a category label.
  ///
  final String labelText;

  ///
  /// Text that describes a category value.
  ///
  final String valueText;

  ///
  /// Represents the weight of a category.
  /// min: 0
  /// max: 9999
  ///
  final double weight;

  const FastCategory({
    required this.labelText,
    required this.valueText,
    this.weight = 0.0,
  }) : assert(weight >= 0 && weight < 1000);

  @override
  FastCategory copyWith({
    String? labelText,
    String? valueText,
    double? weight,
  }) {
    return FastCategory(
      labelText: labelText ?? this.labelText,
      valueText: valueText ?? this.valueText,
      weight: weight ?? this.weight,
    );
  }

  @override
  FastCategory clone() => copyWith();

  @override
  FastCategory merge(covariant FastCategory model) {
    return copyWith(
      labelText: model.labelText,
      valueText: model.valueText,
      weight: model.weight,
    );
  }

  @override
  List<Object> get props => [labelText, valueText, weight];
}

///
/// Internal purposes.
///
class FastInternalCategory extends FastCategory {
  ///
  /// Represents the weight of an internal category.
  /// Weight must be greater than 1000.
  /// In order to avoid conflicts with user categories.
  ///
  @override
  // ignore: overridden_fields
  final double weight;

  const FastInternalCategory({
    required super.labelText,
    required super.valueText,
    required this.weight,
  }) : assert(weight >= 1000);

  @override
  FastInternalCategory copyWith({
    String? labelText,
    String? valueText,
    double? weight,
  }) {
    return FastInternalCategory(
      labelText: labelText ?? this.labelText,
      valueText: valueText ?? this.valueText,
      weight: weight ?? this.weight,
    );
  }

  @override
  FastInternalCategory clone() => copyWith();
}
