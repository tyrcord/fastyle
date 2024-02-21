// Package imports:
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:tbloc/tbloc.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// The [FastAppPermissionsBloc] is used to manage the app permissions.
/// It can be used to request permissions, check permission status, etc.
class FastAppPermissionsBloc extends BidirectionalBloc<
    FastAppPermissionsBlocEvent, FastAppPermissionsBlocState> {
  /// Keeps track if a singleton instance has been created.
  static bool get hasBeenInstantiated => _hasBeenInstantiated;
  static bool _hasBeenInstantiated = false;

  static final _logger = TLoggerManager.instance.getLogger(debugLabel);
  static const debugLabel = 'FastAppPermissionsBloc';

  static late FastAppPermissionsBloc _instance;

  static FastAppPermissionsBloc get instance {
    if (!_hasBeenInstantiated) return FastAppPermissionsBloc();

    return _instance;
  }

  // Method to reset the singleton instance
  static void reset() => instance.resetBloc();

  FastAppPermissionsBloc._()
      : super(initialState: FastAppPermissionsBlocState());

  factory FastAppPermissionsBloc() {
    if (!_hasBeenInstantiated) {
      _instance = FastAppPermissionsBloc._();
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

      _logger.info('Tracking permission', permission);

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
