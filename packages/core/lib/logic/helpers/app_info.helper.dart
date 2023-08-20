// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

String? getPremiumProductId() {
  final appInfoBloc = FastAppInfoBloc();
  final appInfo = appInfoBloc.currentState;

  return appInfo.premiumProductIdentifier;
}
