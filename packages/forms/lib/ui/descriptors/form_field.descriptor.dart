import 'package:tmodel/tmodel.dart';

/// A descriptor for a form field.
class FastFormFieldDescriptor extends TModel {
  /// The text to display in the search title.
  final String? searchTitleText;

  /// The caption text to display.
  final String? captionText;

  /// The label text to display.
  final String? labelText;

  /// The placeholder text to display in the search field.
  final String? searchPlaceholderText;

  /// The placeholder text to display in the field.
  final String? placeholderText;

  /// Whether to show the field.
  final bool show;

  /// Creates a new [FastFormFieldDescriptor].
  const FastFormFieldDescriptor({
    this.searchTitleText,
    this.captionText,
    this.labelText,
    this.searchPlaceholderText,
    this.placeholderText,
    this.show = true,
  });

  @override
  FastFormFieldDescriptor clone() => copyWith();

  @override
  FastFormFieldDescriptor copyWith({
    String? searchTitleText,
    String? captionText,
    String? labelText,
    String? searchPlaceholderText,
    String? placeholderText,
    bool? show,
  }) {
    return FastFormFieldDescriptor(
      searchTitleText: searchTitleText ?? this.searchTitleText,
      captionText: captionText ?? this.captionText,
      labelText: labelText ?? this.labelText,
      searchPlaceholderText:
          searchPlaceholderText ?? this.searchPlaceholderText,
      placeholderText: placeholderText ?? this.placeholderText,
      show: show ?? this.show,
    );
  }

  @override
  FastFormFieldDescriptor merge(covariant FastFormFieldDescriptor model) {
    return copyWith(
      searchTitleText: model.searchTitleText,
      captionText: model.captionText,
      labelText: model.labelText,
      searchPlaceholderText: model.searchPlaceholderText,
      placeholderText: model.placeholderText,
      show: model.show,
    );
  }

  @override
  List<Object?> get props => [
        labelText,
        searchTitleText,
        captionText,
        searchPlaceholderText,
        placeholderText,
        show,
      ];
}
