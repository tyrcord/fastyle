// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

String? getPremiumProductId() {
  final appInfoBloc = FastAppInfoBloc();
  final appInfo = appInfoBloc.currentState;

  return appInfo.premiumProductIdentifier;
}

bool isOsVersionAtLeast(double version) {
  final appInfoBloc = FastAppInfoBloc();
  final appInfo = appInfoBloc.currentState;
  final osVersion = double.tryParse(appInfo.osVersion ?? '');

  return osVersion != null && osVersion >= version;
}
