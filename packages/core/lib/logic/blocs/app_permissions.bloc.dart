// Package imports:
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// The [FastAppPermissionsBloc] is used to manage the app permissions.
/// It can be used to request permissions, check permission status, etc.
class FastAppPermissionsBloc extends BidirectionalBloc<
    FastAppPermissionsBlocEvent, FastAppPermissionsBlocState> {
  static bool _hasBeenInstantiated = false;
  static late FastAppPermissionsBloc instance;
  static const String debugLabel = 'FastAppPermissionsBloc';

  FastAppPermissionsBloc._({FastAppPermissionsBlocState? initialState})
      : super(initialState: initialState ?? FastAppPermissionsBlocState());

  factory FastAppPermissionsBloc({FastAppPermissionsBlocState? initialState}) {
    if (!_hasBeenInstantiated) {
      instance = FastAppPermissionsBloc._(initialState: initialState);
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  @override
  bool canClose() => false;

  @override
  Stream<FastAppPermissionsBlocState> mapEventToState(
    FastAppPermissionsBlocEvent event,
  ) async* {
    final payload = event.payload;
    final type = event.type;

    if (type == FastAppPermissionsBlocEventType.init) {
      yield* handleInitEvent();
    } else if (type == FastAppPermissionsBlocEventType.initialized) {
      if (payload is FastAppPermission) {
        yield* handleInitializedEvent(payload);
      }
    } else if (isInitialized) {
      switch (type) {
        case FastAppPermissionsBlocEventType.updateNotificationPermission:
          if (payload is FastAppPermission) {
            yield* handleUpdateNotificationPermissionEvent(payload);
          }

        case FastAppPermissionsBlocEventType.updateTrackingPermission:
          if (payload is FastAppPermission) {
            yield* handleUpdateTrackingPermissionEvent(payload);
          }

        default:
          break;
      }
    }
  }

  Stream<FastAppPermissionsBlocState> handleInitEvent() async* {
    if (canInitialize) {
      isInitializing = true;
      yield currentState.copyWith(isInitializing: true);

      final permission = await _getTrackingPermission();

      debugLog('Tracking permission: $permission', debugLabel: debugLabel);

      addEvent(FastAppPermissionsBlocEvent.initialized(permission));
    }
  }

  Stream<FastAppPermissionsBlocState> handleInitializedEvent(
    FastAppPermission permission,
  ) async* {
    if (isInitializing) {
      isInitialized = true;

      yield currentState.copyWith(
        trackingPermission: permission,
        isInitializing: false,
        isInitialized: true,
      );
    }
  }

  Stream<FastAppPermissionsBlocState> handleUpdateNotificationPermissionEvent(
    FastAppPermission permission,
  ) async* {
    yield currentState.copyWith(notificationPermission: permission);
  }

  Stream<FastAppPermissionsBlocState> handleUpdateTrackingPermissionEvent(
    FastAppPermission permission,
  ) async* {
    yield currentState.copyWith(trackingPermission: permission);
  }

  Future<FastAppPermission> _getTrackingPermission() async {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;

    return getTrackingPermission(status);
  }
}
