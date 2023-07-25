import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:tbloc/tbloc.dart';

class FastAdInfoBlocEvent
    extends BlocEvent<FastAdInfoBlocEventType, FastAdInfo> {
  const FastAdInfoBlocEvent.init({FastAdInfo? adInfo})
      : super(type: FastAdInfoBlocEventType.init, payload: adInfo);

  const FastAdInfoBlocEvent.initialized({FastAdInfo? adInfo})
      : super(type: FastAdInfoBlocEventType.initialized, payload: adInfo);
}
