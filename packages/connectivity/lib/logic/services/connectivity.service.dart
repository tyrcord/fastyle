import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fastyle_connectivity/fastyle_connectivity.dart';
import 'package:rxdart/rxdart.dart';

class FastConnectivityService {
  final Duration checkInterval;
  final Duration checkTimeout;
  final String checkAddress;
  final int checkPort;

  const FastConnectivityService({
    this.checkInterval = kFastConnectivityCheckInterval,
    this.checkTimeout = kFastConnectivityCheckTimeout,
    this.checkAddress = kFastConnectivityCheckAddress,
    this.checkPort = kFastConnectivityCheckPort,
  });

  Stream<FastConnectivityStatus> get onInternetConnectivityChanged {
    return MergeStream([
      _checkConnectivityStatusPericodically(),
      _checkConnectivityStatusOnConnectivityChanged(),
    ]).distinct();
  }

  Future<bool> checkInternetConnectivity() async {
    var hasConnection = false;

    try {
      final socket = await Socket.connect(
        checkAddress,
        checkPort,
        timeout: checkTimeout,
      );

      socket.destroy();
      hasConnection = true;
    } catch (_) {
      hasConnection = false;
    }

    return hasConnection;
  }

  Stream<FastConnectivityStatus>
      _checkConnectivityStatusOnConnectivityChanged() {
    return Connectivity()
        .onConnectivityChanged
        .sampleTime(const Duration(milliseconds: 300))
        .asyncMap((event) async {
      var hasConnection = event != ConnectivityResult.none;

      if (hasConnection) {
        hasConnection = await checkInternetConnectivity();
      }

      return FastConnectivityStatus(
        connectivityResult: event,
        hasConnection: hasConnection,
      );
    });
  }

  Stream<FastConnectivityStatus> _checkConnectivityStatusPericodically() {
    return Stream.periodic(checkInterval).asyncMap((_) async {
      var hasConnection = await checkInternetConnectivity();

      return FastConnectivityStatus(
        connectivityResult: await Connectivity().checkConnectivity(),
        hasConnection: hasConnection,
      );
    });
  }
}
