import 'package:fastyle_core/fastyle_core.dart';
import 'package:tbloc/tbloc.dart';

class FastAppInfoBlocEvent
    extends BlocEvent<dynamic, FastAppInfoBlocEventType> {
  const FastAppInfoBlocEvent.init()
      : super(type: FastAppInfoBlocEventType.init);

  const FastAppInfoBlocEvent.initialized()
      : super(type: FastAppInfoBlocEventType.initialized);

  const FastAppInfoBlocEvent.fisrtLaunchCompleted()
      : super(type: FastAppInfoBlocEventType.fisrtLaunchCompleted);
}
