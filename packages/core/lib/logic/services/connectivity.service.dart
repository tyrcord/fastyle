// Dart imports:
import 'dart:async';
import 'dart:io';

// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// Service for monitoring internet connectivity status.
///
/// This service provides streams and methods to check device connectivity and
/// the availability of remote services. It periodically checks connectivity
/// and also listens for system connectivity changes.
class FastConnectivityService {
  /// Singleton instance.
  static final FastConnectivityService instance = FastConnectivityService._();
  static const String debugLabel = 'FastConnectivityService';
  static final _manager = TLoggerManager();

  late final TLogger _logger;

  // Configuration parameters.
  Duration _checkInterval;
  Duration _checkTimeout;
  List<String> _checkAddresses;
  List<int> _checkPorts;
  Duration _throttleDuration;

  // Flag indicating whether the singleton instance has been accessed.
  static bool _hasBeenInstantiated = false;

  // StreamController for throttling service availability checks.
  final _serviceAvailabilityController = StreamController<bool>();

  // Private constructor with initial configuration.
  FastConnectivityService._({
    Duration? checkInterval,
    Duration? checkTimeout,
    List<String>? checkAddresses,
    List<int>? checkPorts,
    Duration? throttleDuration,
    String? debugLabel,
  })  : _checkInterval = checkInterval ?? kFastConnectivityCheckInterval,
        _checkTimeout = checkTimeout ?? kFastConnectivityCheckTimeout,
        _checkAddresses = checkAddresses ?? kFastConnectivityCheckAddresses,
        _checkPorts = checkPorts ?? kFastConnectivityCheckPorts,
        _throttleDuration =
            throttleDuration ?? kFastConnectivityCheckThrottleDuration {
    debugLabel ??= FastConnectivityService.debugLabel;
    _logger = _manager.getLogger(debugLabel);

    _serviceAvailabilityController.stream
        .throttleTime(_throttleDuration)
        .asyncMap((_) => _performServiceAvailabilityCheck())
        .listen((result) => _serviceAvailabilitySubject.add(result));
  }

  // Factory constructor for providing a singleton instance.
  factory FastConnectivityService({
    Duration? checkInterval,
    Duration? checkTimeout,
    List<String>? checkAddresses,
    List<int>? checkPorts,
    Duration? throttleDuration,
  }) {
    if (!_hasBeenInstantiated) {
      instance._setConfig(
        checkInterval: checkInterval,
        checkTimeout: checkTimeout,
        checkAddresses: checkAddresses,
        checkPorts: checkPorts,
        throttleDuration: throttleDuration,
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
    final connectivityResults = await Connectivity().checkConnectivity();

    return connectivityResults
        .any((result) => result != ConnectivityResult.none);
  }

  // Subject to emit the results of the service availability checks.
  final _serviceAvailabilitySubject = BehaviorSubject<bool>();

  // Stream to expose the service availability results.
  Stream<bool> get serviceAvailabilityStream =>
      _serviceAvailabilitySubject.stream;

  // Public method to trigger a service availability check.
  Future<bool> checkServiceAvailability() async {
    _serviceAvailabilityController.add(true);

    return _serviceAvailabilitySubject.first;
  }

  // Internal method to perform the actual service availability check.
  Future<bool> _performServiceAvailabilityCheck() async {
    final checks = _checkAddresses.asMap().entries.map((entry) async {
      final address = entry.value;
      final port = _checkPorts[entry.key];

      try {
        _logger.debug('Checking service availability at $address:$port...');
        final socket = await Socket.connect(
          address,
          port,
          timeout: _checkTimeout,
        );

        await socket.flush();
        await socket.close();

        _logger.debug('Service available at $address:$port');

        return true;
      } catch (e) {
        _logger.debug('Unable to connect to $address:$port - $e');

        return false;
      }
    });

    try {
      return await Future.any(checks).then((result) {
        _logger.debug('Service availability check completed - $result');

        return result;
      });
    } catch (e) {
      // If all futures fail, Future.any will throw an error, so we handle it
      _logger.debug('All connection attempts failed - $e');

      return false;
    }
  }

  // Check overall connectivity status, combining device connectivity
  // and service availability.
  Future<FastConnectivityStatus> checkOverallConnectivity() async {
    _logger.debug('Checking overall connectivity status...');

    final connectivityResults = await Connectivity().checkConnectivity();
    final serviceAvailable = await checkServiceAvailability();
    final deviceConnected = connectivityResults.any(
      (result) => result != ConnectivityResult.none,
    );

    return FastConnectivityStatus(
      connectivityResults: connectivityResults,
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
        .skip(1) // Skips the first event which is the initial state.
        .sampleTime(const Duration(milliseconds: 2500))
        .asyncMap((connectivityResults) async {
      _logger.debug('System connectivity changed - $connectivityResults');

      return FastConnectivityStatus(
        isServiceAvailable: await checkServiceAvailability(),
        isConnected: connectivityResults.any(
          (result) => result != ConnectivityResult.none,
        ),
        connectivityResults: connectivityResults,
      );
    });
  }

  // Sets the configuration for the service. This is an internal method used
  // during instantiation to avoid repeating the defaulting logic.
  void _setConfig({
    Duration? checkInterval,
    Duration? checkTimeout,
    List<String>? checkAddresses,
    List<int>? checkPorts,
    Duration? throttleDuration,
  }) {
    _checkInterval = checkInterval ?? kFastConnectivityCheckInterval;
    _checkTimeout = checkTimeout ?? kFastConnectivityCheckTimeout;
    _checkAddresses = checkAddresses ?? kFastConnectivityCheckAddresses;
    _checkPorts = checkPorts ?? kFastConnectivityCheckPorts;
    _throttleDuration =
        throttleDuration ?? kFastConnectivityCheckThrottleDuration;
  }
}
