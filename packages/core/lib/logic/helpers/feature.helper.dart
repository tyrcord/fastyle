import 'package:fastyle_core/fastyle_core.dart';

bool isAdFreeEnabled() {
  return isFeatureEnabled(FastAppFeatures.adFree);
}

bool isExportReportPdfEnabled() {
  return isFeatureEnabled(FastAppFeatures.exportReportPdf);
}

bool isFeatureEnabled(FastAppFeatures feature) {
  final featureBloc = FastAppFeaturesBloc();

  return featureBloc.isFeatureEnabled(feature);
}
