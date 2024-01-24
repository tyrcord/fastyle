// Dart imports:
import 'dart:async';
import 'dart:io';

// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// Service for monitoring internet connectivity status.
///
/// This service provides streams and methods to check device connectivity and
/// the availability of a remote service. It periodically checks connectivity and
/// also listens for system connectivity changes.
class FastConnectivityService {
  /// Singleton instance.
  static final FastConnectivityService instance = FastConnectivityService._();

  // Configuration parameters.
  Duration _checkInterval;
  Duration _checkTimeout;
  String _checkAddress;
  int _checkPort;

  /// A debug label to use when logging.
  String debugLabel;

  // Flag indicating whether the singleton instance has been accessed.
  static bool _hasBeenInstantiated = false;

  // Private constructor with initial configuration.
  FastConnectivityService._({
    Duration? checkInterval,
    Duration? checkTimeout,
    String? checkAddress,
    int? checkPort,
    String? debugLabel,
  })  : _checkInterval = checkInterval ?? kFastConnectivityCheckInterval,
        _checkTimeout = checkTimeout ?? kFastConnectivityCheckTimeout,
        _checkAddress = checkAddress ?? kFastConnectivityCheckAddress,
        _checkPort = checkPort ?? kFastConnectivityCheckPort,
        debugLabel = debugLabel ?? 'FastConnectivityService';

  // Factory constructor for providing a singleton instance.
  factory FastConnectivityService({
    Duration? checkInterval,
    Duration? checkTimeout,
    String? checkAddress,
    int? checkPort,
  }) {
    if (!_hasBeenInstantiated) {
      instance._setConfig(
        checkInterval: checkInterval,
        checkTimeout: checkTimeout,
        checkAddress: checkAddress,
        checkPort: checkPort,
      );
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  // Stream providing real-time connectivity status.
  Stream<FastConnectivityStatus> get onInternetConnectivityChanged {
    return MergeStream([
      _checkConnectivityStatusPeriodically(),
      _checkConnectivityStatusOnSystemChange(),
    ]).distinct();
  }

  // Check the current device internet connectivity.
  Future<bool> checkDeviceConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    return connectivityResult != ConnectivityResult.none;
  }

  // Check the availability of the remote service.
  Future<bool> checkServiceAvailability() async {
    try {
      final socket = await Socket.connect(
        _checkAddress,
        _checkPort,
        timeout: _checkTimeout,
      );

      await socket.flush();
      await socket.close();

      return true;
    } catch (e) {
      // Logging errors or handling them according to the project's practices
      // would be ideal here rather than silently failing.
      debugLog('Unable to connect to service: $e', debugLabel: debugLabel);

      return false;
    }
  }

  // Check overall connectivity status, combining device connectivity
  // and service availability.
  Future<FastConnectivityStatus> checkOverallConnectivity() async {
    debugLog('Checking overall connectivity status...', debugLabel: debugLabel);

    final connectivityResult = await Connectivity().checkConnectivity();
    final serviceAvailable = await checkServiceAvailability();
    final deviceConnected = await checkDeviceConnectivity();

    return FastConnectivityStatus(
      connectivityResult: connectivityResult,
      isServiceAvailable: serviceAvailable,
      isConnected: deviceConnected,
    );
  }

  // Generate a stream that periodically checks connectivity status.
  Stream<FastConnectivityStatus> _checkConnectivityStatusPeriodically() {
    return Stream.periodic(_checkInterval)
        .asyncMap((_) => checkOverallConnectivity());
  }

  // Generate a stream that reacts to system connectivity changes.
  Stream<FastConnectivityStatus> _checkConnectivityStatusOnSystemChange() {
    return Connectivity()
        .onConnectivityChanged
        .sampleTime(const Duration(milliseconds: 2500))
        .asyncMap((event) async {
      return FastConnectivityStatus(
        isServiceAvailable: await checkServiceAvailability(),
        isConnected: await checkDeviceConnectivity(),
        connectivityResult: event,
      );
    });
  }

  // Sets the configuration for the service. This is an internal method used
  // during instantiation to avoid repeating the defaulting logic.
  void _setConfig({
    Duration? checkInterval,
    Duration? checkTimeout,
    String? checkAddress,
    int? checkPort,
  }) {
    _checkInterval = checkInterval ?? kFastConnectivityCheckInterval;
    _checkTimeout = checkTimeout ?? kFastConnectivityCheckTimeout;
    _checkAddress = checkAddress ?? kFastConnectivityCheckAddress;
    _checkPort = checkPort ?? kFastConnectivityCheckPort;
  }
}
