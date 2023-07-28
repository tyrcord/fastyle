// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppFeaturesBlocEvent extends BlocEvent<FastAppFeaturesBlocEventType,
    FastAppFeaturesBlocEventPayload> {
  const FastAppFeaturesBlocEvent.init()
      : super(type: FastAppFeaturesBlocEventType.init);

  FastAppFeaturesBlocEvent.initialized(
    List<FastFeatureEntity> features,
  ) : super(
          type: FastAppFeaturesBlocEventType.initialized,
          payload: FastAppFeaturesBlocEventPayload(features: features),
        );

  const FastAppFeaturesBlocEvent.retrieveFeatures()
      : super(type: FastAppFeaturesBlocEventType.retrieveFeatures);

  FastAppFeaturesBlocEvent.featuresRetrieved(
    List<FastFeatureEntity> features,
  ) : super(
          type: FastAppFeaturesBlocEventType.featuresRetrieved,
          payload: FastAppFeaturesBlocEventPayload(features: features),
        );

  FastAppFeaturesBlocEvent.enableFeature(
    FastAppFeatures feature,
  ) : super(
          type: FastAppFeaturesBlocEventType.enableFeature,
          payload: FastAppFeaturesBlocEventPayload(
            feature: FastFeatureEntity(
              name: feature.name.toLowerCase(),
              isActivated: true,
              isEnabled: true,
            ),
          ),
        );
}
