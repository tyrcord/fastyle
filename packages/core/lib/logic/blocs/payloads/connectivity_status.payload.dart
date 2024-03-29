// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastConnectivityStatusBlocEventPayload {
  final Duration? checkInterval;
  final Duration? checkTimeout;
  final String? checkAddress;
  final bool isConnected;
  final bool isServiceAvailable;
  final int? checkPort;

  const FastConnectivityStatusBlocEventPayload({
    this.checkInterval = kFastConnectivityCheckInterval,
    this.checkTimeout = kFastConnectivityCheckTimeout,
    this.checkAddress = kFastConnectivityCheckAddress,
    this.checkPort = kFastConnectivityCheckPort,
    this.isConnected = false,
    this.isServiceAvailable = false,
  });
}
