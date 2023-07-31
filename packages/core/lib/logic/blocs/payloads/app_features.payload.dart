// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppFeaturesBlocEventPayload {
  final List<FastFeatureEntity>? features;
  final FastFeatureEntity? feature;

  const FastAppFeaturesBlocEventPayload({
    this.features,
    this.feature,
  });
}
