// Package imports:
import 'package:fastyle_dart/fastyle_dart.dart';

// Project imports:
import 'package:fastyle_settings/fastyle_settings.dart';

/// The default categories for the [FastSettingsDescriptor].
const kDefaultFastSettingsCategories = {
  FastAppSettingsCategories.inputs: FastAppSettingsInputsCategoryDescriptor(),
  FastAppSettingsCategories.defaultValues:
      FastAppSettingsDefaultValuesCategoryDescriptor(),
};

/// A [FastDescriptor] that describes the settings available in the Fastyle
/// Settings package.
///
/// The [FastSettingsDescriptor] class contains a map of
/// [FastSettingsCategoryDescriptor] objects, which describe the different
/// categories of settings available to the user.
///
/// The [FastSettingsDescriptor] class provides methods for cloning, copying,
/// and merging instances of itself, as well as a list of [props] that can be
/// used to compare instances of the class.
class FastSettingsDescriptor extends FastDescriptor {
  /// Whether to show the default value settings category.
  final Map<String, FastSettingsCategoryDescriptor> categories;

  /// Creates a new [FastSettingsDescriptor] instance.
  ///
  /// The [categories] parameter is a map of [FastSettingsCategoryDescriptor]
  /// objects that describe the different categories of settings available to
  /// the user. If no categories are provided, the default categories are used.
  const FastSettingsDescriptor({
    this.categories = kDefaultFastSettingsCategories,
  });

  /// Creates a copy of this [FastSettingsDescriptor] instance.
  ///
  /// The [categories] parameter is an optional map of
  /// [FastSettingsCategoryDescriptor] objects that describe the different
  /// categories of settings available to the user. If no categories are
  /// provided, the categories of this instance are used.
  @override
  FastSettingsDescriptor copyWith({
    Map<String, FastSettingsCategoryDescriptor>? categories,
  }) {
    return FastSettingsDescriptor(
      categories: categories ?? this.categories,
    );
  }

  /// Creates a new [FastSettingsDescriptor] instance that is a copy of this
  /// instance.
  @override
  FastSettingsDescriptor clone() => copyWith();

  /// Merges this [FastSettingsDescriptor] instance with another instance of
  /// the same class.
  ///
  /// The [model] parameter is the instance to merge with this instance.
  @override
  FastSettingsDescriptor merge(covariant FastSettingsDescriptor model) {
    return copyWith(
      categories: model.categories,
    );
  }

  /// Returns a list of properties that can be used to compare instances of
  /// this class.
  @override
  List<Object?> get props => [
        categories,
      ];
}
