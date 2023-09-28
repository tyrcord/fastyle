// Package imports:
import 'package:t_helpers/helpers.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastConnectivityStatusBloc extends BidirectionalBloc<
    FastConnectivityStatusBlocEvent, FastConnectivityStatusBlocState> {
  static late FastConnectivityStatusBloc instance;
  static late FastConnectivityService service;
  static bool _hasBeenInstantiated = false;

  factory FastConnectivityStatusBloc({
    FastConnectivityStatusBlocState? initialState,
  }) {
    if (!_hasBeenInstantiated) {
      instance = FastConnectivityStatusBloc._(initialState: initialState);
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  FastConnectivityStatusBloc._({FastConnectivityStatusBlocState? initialState})
      : super(
          initialState: initialState ??
              FastConnectivityStatusBlocState(isConnected: false),
        );

  @override
  Stream<FastConnectivityStatusBlocState> mapEventToState(
    FastConnectivityStatusBlocEvent event,
  ) async* {
    final eventType = event.type;
    final payload = event.payload;
    final isPayloadDefined = payload is FastConnectivityStatusBlocEventPayload;

    if (eventType == FastConnectivityStatusBlocEventType.init) {
      yield* handleInitEvent(payload);
    } else if (isPayloadDefined) {
      if (eventType == FastConnectivityStatusBlocEventType.initialized) {
        yield* handleInitializedEvent(payload);
      } else if (isInitialized) {
        if (eventType ==
            FastConnectivityStatusBlocEventType.connectivityStatusChanged) {
          yield _mapConnectivityStatusChangedToState(payload);
        }
      }
    }
  }

  Stream<FastConnectivityStatusBlocState> handleInitEvent(
    FastConnectivityStatusBlocEventPayload? payload,
  ) async* {
    if (canInitialize) {
      isInitializing = true;

      yield currentState.copyWith(isInitializing: isInitializing);

      service = FastConnectivityService(
        checkInterval: payload?.checkInterval ?? kFastConnectivityCheckInterval,
        checkTimeout: payload?.checkTimeout ?? kFastConnectivityCheckTimeout,
        checkAddress: payload?.checkAddress ?? kFastConnectivityCheckAddress,
        checkPort: payload?.checkPort ?? kFastConnectivityCheckPort,
      );

      subxList.add(service.onInternetConnectivityChanged.listen((status) {
        if (isInitialized) {
          addEvent(FastConnectivityStatusBlocEvent.connectivityStatusChanged(
            status.isConnected,
            status.isServiceAvailable,
          ));
        }
      }));

      bool validator(bool result) => result == true;

      final isDeviceConnected = await retry<bool>(
        task: service.checkDeviceConnectivity,
        validate: validator,
      );

      final isServiceAvailable = await retry<bool>(
        task: service.checkServiceConnectivity,
        validate: validator,
      );

      addEvent(FastConnectivityStatusBlocEvent.initialized(
        isDeviceConnected,
        isServiceAvailable,
      ));
    }
  }

  Stream<FastConnectivityStatusBlocState> handleInitializedEvent(
    FastConnectivityStatusBlocEventPayload payload,
  ) async* {
    if (isInitializing) {
      isInitialized = true;

      yield currentState.copyWith(
        isServiceAvailable: payload.isServiceAvailable,
        isConnected: payload.isConnected,
        isInitializing: isInitializing,
        isInitialized: isInitialized,
      );
    }
  }

  FastConnectivityStatusBlocState _mapConnectivityStatusChangedToState(
    FastConnectivityStatusBlocEventPayload payload,
  ) {
    return currentState.copyWith(
      isServiceAvailable: payload.isServiceAvailable,
      isConnected: payload.isConnected,
    );
  }
}
