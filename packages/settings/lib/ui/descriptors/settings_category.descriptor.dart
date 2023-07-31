// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_forms/fastyle_forms.dart';

/// This file defines the [FastSettingsCategoryDescriptor] class, which is a
/// model for a settings category in the Fastyle Forms library.
///
/// A [FastSettingsCategoryDescriptor] instance contains a title, a map of
/// [FastFormFieldDescriptor] objects, and a boolean flag indicating whether
/// the category should be shown or hidden.
///
/// This class extends [FastDescriptor], which provides methods for cloning,
/// copying, and merging instances of the class.
class FastSettingsCategoryDescriptor extends FastDescriptor {
  /// A map of [FastFormFieldDescriptor] objects that define the fields in the
  /// category.
  final Map<String, FastFormFieldDescriptor> fields;

  /// The title of the category.
  final String titleText;

  /// A boolean flag indicating whether the category should be shown or hidden.
  final bool show;

  /// Creates a new instance of [FastSettingsCategoryDescriptor].
  ///
  /// The [titleText] parameter is required and specifies the title of the
  /// category. The [fields] parameter is optional and specifies the fields in
  /// the category. The [show] parameter is optional and specifies whether the
  /// category should be shown or hidden.
  const FastSettingsCategoryDescriptor({
    required this.titleText,
    this.fields = const {},
    this.show = true,
  });

  @override
  FastSettingsCategoryDescriptor clone() => copyWith();

  @override
  FastSettingsCategoryDescriptor copyWith({
    Map<String, FastFormFieldDescriptor>? fields,
    String? titleText,
    bool? show,
  }) {
    return FastSettingsCategoryDescriptor(
      titleText: titleText ?? this.titleText,
      fields: fields ?? this.fields,
      show: show ?? this.show,
    );
  }

  @override
  FastSettingsCategoryDescriptor merge(
    covariant FastSettingsCategoryDescriptor model,
  ) {
    return copyWith(
      titleText: model.titleText,
      fields: model.fields,
      show: model.show,
    );
  }

  @override
  List<Object?> get props => [
        titleText,
        fields,
        show,
      ];
}
