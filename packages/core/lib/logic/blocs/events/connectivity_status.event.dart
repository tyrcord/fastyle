// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastConnectivityStatusBlocEvent extends BlocEvent<
    FastConnectivityStatusBlocEventType,
    FastConnectivityStatusBlocEventPayload> {
  const FastConnectivityStatusBlocEvent({
    required FastConnectivityStatusBlocEventType super.type,
    super.payload,
  });

  factory FastConnectivityStatusBlocEvent.connectivityStatusChanged(
    bool hasConnection,
    bool isServiceAvailable,
  ) {
    return FastConnectivityStatusBlocEvent(
      type: FastConnectivityStatusBlocEventType.connectivityStatusChanged,
      payload: FastConnectivityStatusBlocEventPayload(
        isServiceAvailable: isServiceAvailable,
        isConnected: hasConnection,
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

  factory FastConnectivityStatusBlocEvent.initialized(
    bool hasConnection,
    bool isServiceAvailable,
  ) {
    return FastConnectivityStatusBlocEvent(
      type: FastConnectivityStatusBlocEventType.initialized,
      payload: FastConnectivityStatusBlocEventPayload(
        isServiceAvailable: isServiceAvailable,
        isConnected: hasConnection,
      ),
    );
  }

  factory FastConnectivityStatusBlocEvent.checkConnectivity() {
    return const FastConnectivityStatusBlocEvent(
      type: FastConnectivityStatusBlocEventType.checkConnectivity,
    );
  }
}
