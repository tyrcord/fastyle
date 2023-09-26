// Dart imports:
import 'dart:io';

// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastConnectivityService {
  static late FastConnectivityService instance;
  static bool _hasBeenInstantiated = false;

  final Duration checkInterval;
  final Duration checkTimeout;
  final String checkAddress;
  final int checkPort;

  factory FastConnectivityService(
      {Duration? checkInterval,
      Duration? checkTimeout,
      String? checkAddress,
      int? checkPort}) {
    if (!_hasBeenInstantiated) {
      instance = FastConnectivityService._(
        checkInterval: checkInterval ?? kFastConnectivityCheckInterval,
        checkTimeout: checkTimeout ?? kFastConnectivityCheckTimeout,
        checkAddress: checkAddress ?? kFastConnectivityCheckAddress,
        checkPort: checkPort ?? kFastConnectivityCheckPort,
      );
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  const FastConnectivityService._({
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
    final connectivity = await Connectivity().checkConnectivity();
    var hasConnection = connectivity != ConnectivityResult.none;

    if (!hasConnection) {
      return hasConnection;
    }

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
      return FastConnectivityStatus(
        connectivityResult: event,
        hasConnection: await checkInternetConnectivity(),
      );
    });
  }

  Stream<FastConnectivityStatus> _checkConnectivityStatusPericodically() {
    return Stream.periodic(checkInterval).asyncMap((_) async {
      return FastConnectivityStatus(
        connectivityResult: await Connectivity().checkConnectivity(),
        hasConnection: await checkInternetConnectivity(),
      );
    });
  }
}
