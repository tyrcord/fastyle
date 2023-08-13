import 'package:fastyle_core/fastyle_core.dart';

// TODO: implement better user rights
bool isUserPremium() {
  final featureBloc = FastAppFeaturesBloc();
  final state = featureBloc.currentState;

  return state.isFeatureEnabled(FastAppFeatures.pro) ||
      state.isFeatureEnabled(FastAppFeatures.premium);
}
