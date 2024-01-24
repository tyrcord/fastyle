// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:t_helpers/helpers.dart';
import 'package:tbloc/tbloc.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastConnectivityStatusBloc extends BidirectionalBloc<
    FastConnectivityStatusBlocEvent, FastConnectivityStatusBlocState> {
  /// Keeps track if a singleton instance has been created.
  static bool get hasBeenInstantiated => _hasBeenInstantiated;
  static bool _hasBeenInstantiated = false;

  static final _logger = TLoggerManager.instance.getLogger(debugLabel);
  static const debugLabel = 'FastConnectivityStatusBloc';

  static late FastConnectivityStatusBloc _instance;

  static FastConnectivityStatusBloc get instance {
    if (!_hasBeenInstantiated) return FastConnectivityStatusBloc();

    return _instance;
  }

  static late FastConnectivityService service;

  // Method to reset the singleton instance
  static void reset() => _hasBeenInstantiated = false;

  /// Subscription to connectivity status updates.
  @protected
  StreamSubscription<FastConnectivityStatus>? connectivitySubscription;

  /// State flag indicating whether the connectivity stream is paused.
  @protected
  bool isConnectivityStreamPaused = false;

  bool _isCheckingConnectivity = false;

  factory FastConnectivityStatusBloc({
    FastConnectivityStatusBlocState? initialState,
  }) {
    if (!_hasBeenInstantiated) {
      _instance = FastConnectivityStatusBloc._(initialState: initialState);
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  FastConnectivityStatusBloc._({FastConnectivityStatusBlocState? initialState})
      : super(
          initialState: initialState ??
              FastConnectivityStatusBlocState(isConnected: false),
        );

  @override
  bool canClose() => false;

  @override
  Stream<FastConnectivityStatusBlocState> mapEventToState(
    FastConnectivityStatusBlocEvent event,
  ) async* {
    final eventType = event.type;
    final payload = event.payload;
    final isPayloadDefined = payload is FastConnectivityStatusBlocEventPayload;

    _logger.debug('Event type: $eventType received.');

    if (eventType == FastConnectivityStatusBlocEventType.init) {
      yield* handleInitEvent(payload);
    } else if (eventType ==
        FastConnectivityStatusBlocEventType.checkConnectivity) {
      yield* handleCheckConnectivityEvent();
    } else if (isPayloadDefined) {
      if (eventType == FastConnectivityStatusBlocEventType.initialized) {
        yield* handleInitializedEvent(payload);
      } else if (isInitialized) {
        if (eventType ==
            FastConnectivityStatusBlocEventType.connectivityStatusChanged) {
          yield handleConnectivityStatusChanged(payload);
        }
      }
    }
  }

  Stream<FastConnectivityStatusBlocState> handleInitEvent(
    FastConnectivityStatusBlocEventPayload? payload,
  ) async* {
    if (canInitialize) {
      isInitializing = true;

      yield currentState.copyWith(
        isInitializing: isInitializing,
        isCheckingConnectivity: true,
      );

      service = FastConnectivityService(
        checkInterval: payload?.checkInterval ?? kFastConnectivityCheckInterval,
        checkTimeout: payload?.checkTimeout ?? kFastConnectivityCheckTimeout,
        checkAddress: payload?.checkAddress ?? kFastConnectivityCheckAddress,
        checkPort: payload?.checkPort ?? kFastConnectivityCheckPort,
      );

      if (connectivitySubscription != null) {
        disposeConnectivityStream();
      }

      connectivitySubscription = listenToConnectivityStatusChanges();

      subxList.addAll([
        listenToAppLifecycleChanges(),
        connectivitySubscription!,
      ]);

      final (deviceConnected, serviceAvailable) = await _checkConnectivity();

      addEvent(FastConnectivityStatusBlocEvent.initialized(
        deviceConnected,
        serviceAvailable,
      ));
    }
  }

  Stream<FastConnectivityStatusBlocState> handleInitializedEvent(
    FastConnectivityStatusBlocEventPayload payload,
  ) async* {
    if (isInitializing) {
      isInitialized = true;

      yield currentState.copyWith(
        isServiceAvailable: payload.isServiceAvailable,
        isConnected: payload.isConnected,
        isInitializing: isInitializing,
        isInitialized: isInitialized,
        isCheckingConnectivity: false,
      );
    }
  }

  Stream<FastConnectivityStatusBlocState>
      handleCheckConnectivityEvent() async* {
    if (isInitialized && !_isCheckingConnectivity) {
      yield currentState.copyWith(isCheckingConnectivity: true);

      final (deviceConnected, serviceAvailable) = await _checkConnectivity();

      addEvent(FastConnectivityStatusBlocEvent.connectivityStatusChanged(
        deviceConnected,
        serviceAvailable,
      ));
    }
  }

  FastConnectivityStatusBlocState handleConnectivityStatusChanged(
    FastConnectivityStatusBlocEventPayload payload,
  ) {
    return currentState.copyWith(
      isServiceAvailable: payload.isServiceAvailable,
      isConnected: payload.isConnected,
      isCheckingConnectivity: false,
    );
  }

  StreamSubscription<FastConnectivityStatus>
      listenToConnectivityStatusChanges() {
    return service.onInternetConnectivityChanged.listen((status) {
      if (isInitialized) {
        addEvent(FastConnectivityStatusBlocEvent.connectivityStatusChanged(
          status.isConnected,
          status.isServiceAvailable,
        ));
      }
    });
  }

  Future<(bool, bool)> _checkConnectivity() async {
    _isCheckingConnectivity = true;

    bool validator(bool result) => result == true;
    bool isDeviceConnected = false;
    bool isServiceAvailable = false;

    _logger.debug('Checking the connectivity status...');

    try {
      isDeviceConnected = await retry<bool>(
        task: service.checkDeviceConnectivity,
        validate: validator,
      );

      isServiceAvailable = await retry<bool>(
        task: service.checkServiceAvailability,
        validate: validator,
      );
    } catch (e) {
      _logger.error('Error while checking the connectivity status: $e');
    } finally {
      _logger
        ..info('Device is connected', isDeviceConnected)
        ..info('Service is available', isServiceAvailable);
    }

    _isCheckingConnectivity = false;

    return (isDeviceConnected, isServiceAvailable);
  }

  /// Pauses the connectivity status stream if it's not already paused.
  @protected
  void pauseConnectivityStream() {
    if (!isConnectivityStreamPaused) {
      connectivitySubscription?.pause();
      isConnectivityStreamPaused = true;
    }
  }

  /// Resumes the connectivity status stream if it has been paused.
  @protected
  void resumeConnectivityStream() {
    if (isConnectivityStreamPaused) {
      connectivitySubscription?.resume();
      isConnectivityStreamPaused = false;
    }
  }

  /// Disposes of the connectivity stream subscription when it's no longer
  /// needed, avoiding potential memory leaks.
  @protected
  void disposeConnectivityStream() {
    connectivitySubscription?.cancel();
    connectivitySubscription = null;
  }

  /// Listens to the app's lifecycle changes, pausing or resuming the
  /// connectivity stream in response to those changes.
  ///
  /// Returns a StreamSubscription to the app's lifecycle state changes.
  @protected
  StreamSubscription<FastAppLifecycleBlocState> listenToAppLifecycleChanges() {
    final appLifecycleBloc = FastAppLifecycleBloc.instance;

    return appLifecycleBloc.onData.listen((state) {
      if (state.appLifeCycleState == AppLifecycleState.paused) {
        pauseConnectivityStream();
      } else {
        resumeConnectivityStream();
      }
    });
  }
}
