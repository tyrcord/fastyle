import 'package:fastyle_connectivity/fastyle_connectivity.dart';
import 'package:tbloc/tbloc.dart';

class FastConnectivityStatusBlocEvent extends BlocEvent<
    FastConnectivityStatusBlocEventType,
    FastConnectivityStatusBlocEventPayload> {
  const FastConnectivityStatusBlocEvent({
    required FastConnectivityStatusBlocEventType type,
    FastConnectivityStatusBlocEventPayload? payload,
  }) : super(type: type, payload: payload);

  factory FastConnectivityStatusBlocEvent.connectivityStatusChanged(
    bool hasConnection,
  ) {
    return FastConnectivityStatusBlocEvent(
      type: FastConnectivityStatusBlocEventType.connectivityStatusChanged,
      payload: FastConnectivityStatusBlocEventPayload(
        hasConnection: hasConnection,
      ),
    );
  }

  factory FastConnectivityStatusBlocEvent.init({
    FastConnectivityStatusBlocEventPayload? payload,
  }) {
    return FastConnectivityStatusBlocEvent(
      type: FastConnectivityStatusBlocEventType.init,
      payload: payload,
    );
  }

  factory FastConnectivityStatusBlocEvent.initialized(bool hasConnection) {
    return FastConnectivityStatusBlocEvent(
      type: FastConnectivityStatusBlocEventType.initialized,
      payload: FastConnectivityStatusBlocEventPayload(
        hasConnection: hasConnection,
      ),
    );
  }

  factory FastConnectivityStatusBlocEvent.disconnected() {
    return FastConnectivityStatusBlocEvent.connectivityStatusChanged(false);
  }

  factory FastConnectivityStatusBlocEvent.connected() {
    return FastConnectivityStatusBlocEvent.connectivityStatusChanged(true);
  }
}
