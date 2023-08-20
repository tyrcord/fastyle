// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppPermissionsBlocEvent
    extends BlocEvent<FastAppPermissionsBlocEventType, FastAppPermission> {
  const FastAppPermissionsBlocEvent.init()
      : super(type: FastAppPermissionsBlocEventType.init);

  const FastAppPermissionsBlocEvent.initialized(
    FastAppPermission permission,
  ) : super(
          type: FastAppPermissionsBlocEventType.initialized,
          payload: permission,
        );

  const FastAppPermissionsBlocEvent.updateTrackingPermission(
    FastAppPermission permission,
  ) : super(
          type: FastAppPermissionsBlocEventType.updateTrackingPermission,
          payload: permission,
        );

  const FastAppPermissionsBlocEvent.updateNotificationPermission(
    FastAppPermission permission,
  ) : super(
          type: FastAppPermissionsBlocEventType.updateNotificationPermission,
          payload: permission,
        );
}
