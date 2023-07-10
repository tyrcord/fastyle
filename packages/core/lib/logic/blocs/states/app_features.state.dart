import 'package:collection/collection.dart' show IterableExtension;
import 'package:fastyle_core/fastyle_core.dart';
import 'package:tbloc/tbloc.dart';

/// Represents the state of the Fusex Features BLoC.
class FastAppFeaturesBlocState extends BlocState {
  /// The list of fast feature entities.
  final List<FastFeatureEntity> features;

  /// Whether the features are currently being retrieved.
  final bool isRetrievingFeatures;

  /// Constructs a [FastAppFeaturesBlocState] instance.
  ///
  /// The [features] parameter is optional and defaults to an empty list if
  /// not provided.
  FastAppFeaturesBlocState({
    super.isInitializing,
    super.isInitialized,
    List<FastFeatureEntity>? features,
    bool? isRetrievingFeatures,
  })  : features = features ?? const [],
        isRetrievingFeatures = isRetrievingFeatures ?? false;

  /// Checks if a feature with the given [name] is enabled.
  bool isFeatureEnabled(String name) {
    final feature = features.firstWhereOrNull(
      (FastFeatureEntity model) => model.name == name,
    );

    return feature != null ? feature.isActivated && feature.isEnabled : false;
  }

  @override
  FastAppFeaturesBlocState copyWith({
    List<FastFeatureEntity>? features,
    bool? isInitializing,
    bool? isInitialized,
    bool? isRetrievingFeatures,
  }) {
    return FastAppFeaturesBlocState(
      isInitializing: isInitializing ?? this.isInitializing,
      isInitialized: isInitialized ?? this.isInitialized,
      features: features ?? this.features,
      isRetrievingFeatures: isRetrievingFeatures ?? this.isRetrievingFeatures,
    );
  }

  @override
  FastAppFeaturesBlocState clone() => copyWith();

  @override
  FastAppFeaturesBlocState merge(covariant FastAppFeaturesBlocState model) {
    return copyWith(
      isInitializing: model.isInitializing,
      isInitialized: model.isInitialized,
      features: model.features,
      isRetrievingFeatures: model.isRetrievingFeatures,
    );
  }

  @override
  List<Object?> get props => [
        features,
        isInitialized,
        isInitializing,
        isRetrievingFeatures,
      ];
}
