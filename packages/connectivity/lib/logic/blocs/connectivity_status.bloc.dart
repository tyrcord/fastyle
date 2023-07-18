// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_connectivity/fastyle_connectivity.dart';

class FastConnectivityStatusBloc extends BidirectionalBloc<
    FastConnectivityStatusBlocEvent, FastConnectivityStatusBlocState> {
  late FastConnectivityService service;

  FastConnectivityStatusBloc()
      : super(
          initialState: FastConnectivityStatusBlocState(hasConnection: false),
        );

  @override
  Stream<FastConnectivityStatusBlocState> mapEventToState(
    FastConnectivityStatusBlocEvent event,
  ) async* {
    final eventType = event.type;
    final payload = event.payload;
    final isPayloadDefined = payload is FastConnectivityStatusBlocEventPayload;

    if (isPayloadDefined) {
      if (eventType == FastConnectivityStatusBlocEventType.init) {
        yield* handleInitEvent(payload);
      } else if (eventType == FastConnectivityStatusBlocEventType.initialized) {
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
    FastConnectivityStatusBlocEventPayload payload,
  ) async* {
    if (canInitialize) {
      isInitializing = true;

      yield currentState.copyWith(isInitializing: isInitializing);

      service = FastConnectivityService(
        checkInterval: payload.checkInterval ?? kFastConnectivityCheckInterval,
        checkTimeout: payload.checkTimeout ?? kFastConnectivityCheckTimeout,
        checkAddress: payload.checkAddress ?? kFastConnectivityCheckAddress,
        checkPort: payload.checkPort ?? kFastConnectivityCheckPort,
      );

      subxList.add(service.onInternetConnectivityChanged.listen((status) {
        if (isInitializing) {
          addEvent(FastConnectivityStatusBlocEvent.initialized(
            status.hasConnection,
          ));
        } else {
          addEvent(FastConnectivityStatusBlocEvent.connectivityStatusChanged(
            status.hasConnection,
          ));
        }
      }));
    }
  }

  Stream<FastConnectivityStatusBlocState> handleInitializedEvent(
    FastConnectivityStatusBlocEventPayload payload,
  ) async* {
    if (isInitializing) {
      isInitialized = true;

      yield currentState.copyWith(
        hasConnection: payload.hasConnection,
        isInitializing: isInitializing,
        isInitialized: isInitialized,
      );
    }
  }

  FastConnectivityStatusBlocState _mapConnectivityStatusChangedToState(
    FastConnectivityStatusBlocEventPayload payload,
  ) {
    return currentState.copyWith(hasConnection: payload.hasConnection);
  }
}
