// Project imports:
import 'package:fastyle_connectivity/fastyle_connectivity.dart';

class FastConnectivityStatusBlocEventPayload {
  final Duration? checkInterval;
  final Duration? checkTimeout;
  final String? checkAddress;
  final bool hasConnection;
  final int? checkPort;

  const FastConnectivityStatusBlocEventPayload({
    this.checkInterval = kFastConnectivityCheckInterval,
    this.checkTimeout = kFastConnectivityCheckTimeout,
    this.checkAddress = kFastConnectivityCheckAddress,
    this.checkPort = kFastConnectivityCheckPort,
    this.hasConnection = false,
  });
}
