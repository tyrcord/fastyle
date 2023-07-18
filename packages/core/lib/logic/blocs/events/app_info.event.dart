// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppInfoBlocEvent
    extends BlocEvent<FastAppInfoBlocEventType, FastAppInfoDocument> {
  const FastAppInfoBlocEvent.init(FastAppInfoDocument payload)
      : super(type: FastAppInfoBlocEventType.init, payload: payload);

  const FastAppInfoBlocEvent.initialized(FastAppInfoDocument payload)
      : super(type: FastAppInfoBlocEventType.initialized, payload: payload);
}
