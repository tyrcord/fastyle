// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

bool isAdFreeEnabled() {
  return isFeatureEnabled(FastAppFeatures.adFree);
}

bool isExportReportPdfEnabled() {
  return isFeatureEnabled(FastAppFeatures.exportReportPdf);
}

bool isAutoRefreshCalculatorResultsEnabled() {
  return isFeatureEnabled(FastAppFeatures.autoRefreshCalculatorResults);
}

bool isFeatureEnabled(FastAppFeatures feature) {
  final featureBloc = FastAppFeaturesBloc();

  return featureBloc.isFeatureEnabled(feature);
}
