// Package imports:
import 'package:tmodel/tmodel.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastItem<T> extends TModel {
  ///
  /// Describes some additional visual aspects of an item.
  ///
  final FastListItemDescriptor? descriptor;

  ///
  /// Describes a list of categories to which an item belongs.
  ///
  final List<FastCategory>? categories;

  ///
  /// Represents a lowercase labelText without any diacritics.
  ///
  final String? normalizedLabelText;

  ///
  /// Text that describes an item description.
  ///
  final String? descriptionText;

  ///
  /// Text that describes an item label.
  ///
  final String labelText;

  ///
  /// Indicates whether an item is enabled in the user interface.
  ///
  final bool isEnabled;

  ///
  /// Represents an item value.
  ///
  final T? value;

  const FastItem({
    required this.labelText,
    this.isEnabled = true,
    this.normalizedLabelText,
    this.descriptionText,
    this.categories,
    this.descriptor,
    this.value,
  });

  @override
  // ignore: code-metrics
  FastItem<T> copyWith({
    FastListItemDescriptor? descriptor,
    List<FastCategory>? categories,
    String? normalizedLabelText,
    String? descriptionText,
    String? labelText,
    bool? isEnabled,
    T? value,
  }) {
    return FastItem<T>(
      normalizedLabelText: normalizedLabelText ?? this.normalizedLabelText,
      descriptionText: descriptionText ?? this.descriptionText,
      categories: categories ?? this.categories,
      descriptor: descriptor ?? this.descriptor,
      isEnabled: isEnabled ?? this.isEnabled,
      labelText: labelText ?? this.labelText,
      value: value ?? this.value,
    );
  }

  @override
  FastItem<T> clone() {
    return FastItem<T>(
      descriptor: descriptor?.clone(),
      normalizedLabelText: normalizedLabelText,
      descriptionText: descriptionText,
      categories: categories?.map((c) => c.clone()).toList(),
      isEnabled: isEnabled,
      labelText: labelText,
      value: value,
    );
  }

  @override
  FastItem<T> merge(covariant FastItem<T> model) {
    return copyWith(
      normalizedLabelText: model.normalizedLabelText,
      descriptionText: model.descriptionText,
      categories: model.categories,
      descriptor: model.descriptor,
      isEnabled: model.isEnabled,
      labelText: model.labelText,
      value: model.value,
    );
  }

  @override
  List<Object?> get props => [
        normalizedLabelText,
        descriptionText,
        categories,
        descriptor,
        isEnabled,
        labelText,
        value,
      ];
}
