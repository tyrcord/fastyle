import 'package:fastyle_core/fastyle_core.dart';

bool isAdFreeEnabled() {
  return isFeatureEnabled(FastAppFeatures.adFree);
}

bool isExportPdfEnabled() {
  return isFeatureEnabled(FastAppFeatures.exportPdf);
}

bool isFeatureEnabled(FastAppFeatures feature) {
  final featureBloc = FastAppFeaturesBloc();
  final state = featureBloc.currentState;

  return state.isFeatureEnabled(feature);
}
