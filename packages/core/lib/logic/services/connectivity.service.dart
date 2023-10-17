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

  factory FastConnectivityService({
    Duration? checkInterval,
    Duration? checkTimeout,
    String? checkAddress,
    int? checkPort,
  }) {
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

  Future<bool> checkDeviceConnectivity() async {
    final connectivity = await Connectivity().checkConnectivity();

    return connectivity != ConnectivityResult.none;
  }

  Future<bool> checkServiceConnectivity() async {
    try {
      final socket = await Socket.connect(
        checkAddress,
        checkPort,
        timeout: checkTimeout,
      );

      await socket.close();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<FastConnectivityStatus> checkConnectivity() async {
    return FastConnectivityStatus(
      connectivityResult: await Connectivity().checkConnectivity(),
      isServiceAvailable: await checkServiceConnectivity(),
      isConnected: await checkDeviceConnectivity(),
    );
  }

  Stream<FastConnectivityStatus>
      _checkConnectivityStatusOnConnectivityChanged() {
    return Connectivity()
        .onConnectivityChanged
        .sampleTime(const Duration(milliseconds: 2500))
        .asyncMap((event) async {
      return FastConnectivityStatus(
        isServiceAvailable: await checkServiceConnectivity(),
        isConnected: await checkDeviceConnectivity(),
        connectivityResult: event,
      );
    });
  }

  Stream<FastConnectivityStatus> _checkConnectivityStatusPericodically() {
    return Stream.periodic(checkInterval).asyncMap((_) => checkConnectivity());
  }
}
