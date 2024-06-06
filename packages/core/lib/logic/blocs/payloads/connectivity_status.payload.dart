// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastConnectivityStatusBlocEventPayload {
  final List<String> checkAddresses;
  final Duration? checkInterval;
  final bool isServiceAvailable;
  final Duration? checkTimeout;
  final List<int> checkPorts;
  final bool isConnected;

  const FastConnectivityStatusBlocEventPayload({
    this.checkInterval = kFastConnectivityCheckInterval,
    this.checkTimeout = kFastConnectivityCheckTimeout,
    this.checkAddresses = kFastConnectivityCheckAddresses,
    this.checkPorts = kFastConnectivityCheckPorts,
    this.isConnected = false,
    this.isServiceAvailable = false,
  });
}
