// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:t_helpers/helpers.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastConnectivityStatusBloc extends BidirectionalBloc<
    FastConnectivityStatusBlocEvent, FastConnectivityStatusBlocState> {
  static late FastConnectivityStatusBloc instance;
  static late FastConnectivityService service;
  static bool _hasBeenInstantiated = false;

  /// Subscription to connectivity status updates.
  @protected
  StreamSubscription<FastConnectivityStatus>? connectivitySubscription;

  /// State flag indicating whether the connectivity stream is paused.
  @protected
  bool isConnectivityStreamPaused = false;

  factory FastConnectivityStatusBloc({
    FastConnectivityStatusBlocState? initialState,
  }) {
    if (!_hasBeenInstantiated) {
      instance = FastConnectivityStatusBloc._(initialState: initialState);
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

    if (eventType == FastConnectivityStatusBlocEventType.init) {
      yield* handleInitEvent(payload);
    } else if (isPayloadDefined) {
      if (eventType == FastConnectivityStatusBlocEventType.initialized) {
        yield* handleInitializedEvent(payload);
      } else if (isInitialized) {
        if (eventType ==
            FastConnectivityStatusBlocEventType.connectivityStatusChanged) {
          yield _mapConnectivityStatusChangedToState(payload);
        }
      }
    }
  }

  Stream<FastConnectivityStatusBlocState> handleInitEvent(
    FastConnectivityStatusBlocEventPayload? payload,
  ) async* {
    if (canInitialize) {
      isInitializing = true;

      yield currentState.copyWith(isInitializing: isInitializing);

      service = FastConnectivityService(
        checkInterval: payload?.checkInterval ?? kFastConnectivityCheckInterval,
        checkTimeout: payload?.checkTimeout ?? kFastConnectivityCheckTimeout,
        checkAddress: payload?.checkAddress ?? kFastConnectivityCheckAddress,
        checkPort: payload?.checkPort ?? kFastConnectivityCheckPort,
      );

      connectivitySubscription = listenToConnectivityStatusChanges();

      subxList.addAll([
        listenToAppLifecycleChanges(),
        connectivitySubscription!,
      ]);

      bool validator(bool result) => result == true;
      bool isDeviceConnected = false;
      bool isServiceAvailable = false;

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
        debugLog('Error while initializing the connectivity status bloc: $e');
      } finally {
        addEvent(FastConnectivityStatusBlocEvent.initialized(
          isDeviceConnected,
          isServiceAvailable,
        ));
      }
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
      );
    }
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

  FastConnectivityStatusBlocState _mapConnectivityStatusChangedToState(
    FastConnectivityStatusBlocEventPayload payload,
  ) {
    return currentState.copyWith(
      isServiceAvailable: payload.isServiceAvailable,
      isConnected: payload.isConnected,
    );
  }
}
