// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppFeaturesBlocEvent
    extends BlocEvent<FastAppFeaturesBlocEventType, List<FastFeatureEntity>> {
  const FastAppFeaturesBlocEvent.init()
      : super(type: FastAppFeaturesBlocEventType.init);

  const FastAppFeaturesBlocEvent.initialized(
    List<FastFeatureEntity> payload,
  ) : super(
          type: FastAppFeaturesBlocEventType.initialized,
          payload: payload,
        );

  const FastAppFeaturesBlocEvent.retrieveFeatures()
      : super(type: FastAppFeaturesBlocEventType.retrieveFeatures);

  const FastAppFeaturesBlocEvent.featuresRetrieved(
    List<FastFeatureEntity> payload,
  ) : super(
          type: FastAppFeaturesBlocEventType.featuresRetrieved,
          payload: payload,
        );
}
