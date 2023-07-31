// Package imports:
import 'package:tmodel/tmodel.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastListItemCategory<T extends FastItem> extends TModel {
  ///
  /// Text that describes an item label.
  ///
  final String labelText;

  ///
  /// Text that describes an item value.
  ///
  final String valueText;

  ///
  /// Text that describes an item label.
  ///
  final List<T> items;

  ///
  /// Represents the weight of a category.
  ///
  final double weight;

  const FastListItemCategory({
    required this.labelText,
    required this.valueText,
    required this.items,
    this.weight = 0.0,
  });

  @override
  FastListItemCategory<T> copyWith({
    String? labelText,
    String? valueText,
    List<T>? items,
    double? weight,
  }) {
    return FastListItemCategory(
      labelText: labelText ?? this.labelText,
      valueText: valueText ?? this.valueText,
      weight: weight ?? this.weight,
      items: items ?? this.items,
    );
  }

  @override
  FastListItemCategory<T> clone() => copyWith();

  @override
  FastListItemCategory<T> merge(covariant FastListItemCategory<T> model) {
    return copyWith(
      labelText: model.labelText,
      valueText: model.valueText,
      weight: model.weight,
      items: model.items,
    );
  }

  @override
  List<Object> get props => [labelText, valueText, weight, items];
}
