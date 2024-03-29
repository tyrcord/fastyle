// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

typedef FastCalculatorBlocDebounceEventCallback<
        E extends FastCalculatorBlocEvent>
    = void Function(E event);

/// A generic and customizable FastCalculatorBloc class for managing the
/// business logic of a fast calculator. This class extends the
/// BidirectionalBloc and provides methods for initializing the calculator,
/// patching the calculator state, computing results, and handling various
/// events.
///
/// This class requires three type parameters:
/// - E: The event type, extending [FastCalculatorBlocEvent].
/// - S: The state type, extending [FastCalculatorBlocState].
/// - R: The results type, extending [FastCalculatorResults].
abstract class FastCalculatorBloc<
    E extends FastCalculatorBlocEvent,
    S extends FastCalculatorBlocState,
    R extends FastCalculatorResults> extends BidirectionalBloc<E, S> {
  /// The default state of the calculator.
  @protected
  late S defaultCalculatorState;

  late FastCalculatorBlocDebounceEventCallback<E> addDebouncedLoadMetadataEvent;
  late FastCalculatorBlocDebounceEventCallback<E> addDebouncedComputeEvent;

  /// The app settings bloc used by the calculator.
  @protected
  final appSettingsBloc = FastAppSettingsBloc();

  /// Determines if compute events should be debounced or not.
  @protected
  late final bool debouceComputeEvents;

  @protected
  late bool _isAutoRefreshEnabled;

  Map<String, dynamic> get currentMetadata => currentState.metadata;

  set isAutoRefreshEnabled(bool enabled) {
    _isAutoRefreshEnabled = enabled;

    if (enabled) {
      final refreshComputationsStream = Stream.periodic(autoRefreshPeriod);

      subxMap.add(
        'autoRefreshComputations',
        refreshComputationsStream.listen(handleAutoRefreshComputations),
      );
    } else {
      subxMap.cancelForKey('autoRefreshComputations');
    }
  }

  bool get isAutoRefreshEnabled => _isAutoRefreshEnabled;

  /// The auto-refresh period.
  @protected
  late final Duration autoRefreshPeriod;

  @protected
  late final FastCalculatorBlocDelegate? delegate;

  /// The debug label used to identify the bloc in the logs.
  @protected
  late final String? debugLabel;

  final BuildContext? Function()? getContext;

  BuildContext? get context => getContext?.call();

  Debouncer? _analyticsDebouncer;

  /// Constructs a new [FastCalculatorBloc] instance.
  ///
  /// [initialState] is required and represents the initial state of the bloc.
  /// [debugLabel] is an optional identifier for the bloc in the logs.
  /// [debouceComputeEvents] determines if compute events should be debounced,
  /// and defaults to `false`.
  FastCalculatorBloc({
    required super.initialState,
    this.autoRefreshPeriod = const Duration(minutes: 1),
    super.enableForceBuildEvents = true,
    this.debouceComputeEvents = false,
    this.debugLabel,
    this.delegate,
    bool? isAutoRefreshEnabled = false,
    this.getContext,
  }) {
    if (debouceComputeEvents) {
      debugPrint('`debouceComputeEvents` is enabled for $runtimeType');
    } else {
      debugPrint('`debouceComputeEvents` is disabled for $runtimeType');
    }

    _analyticsDebouncer = Debouncer(milliseconds: 5000); // 5 seconds

    addDebouncedComputeEvent = debounceEvent((event) {
      if (!closed) addEvent(event);
    });

    addDebouncedLoadMetadataEvent = debounceEvent((event) {
      if (!closed) addEvent(event);
    });

    subxList.add(appSettingsBloc.onData.listen(handleSettingsChanges));
    isAutoRefreshEnabled = isAutoRefreshEnabled ?? false;
  }

  void handleAutoRefreshComputations(dynamic event) async {
    final appLifecycleBloc = FastAppLifecycleBloc.instance;
    final appLifecycleState = appLifecycleBloc.currentState.appLifeCycleState;

    if (appLifecycleState == AppLifecycleState.paused) return;

    if (await isCalculatorStateValid() &&
        isAutoRefreshCalculatorResultsEnabled()) {
      final canRefresh = await delegate?.canAutoRefreshComputations() ?? true;

      if (canRefresh) {
        debugLog('Auto-refreshing computations', debugLabel: debugLabel);
        addComputeEvent();
      }
    }
  }

  /// Updates a single field in the calculator state.
  ///
  /// Takes [key] as the field key and [value] as the new value to update.
  /// Returns a future of the updated state or `null` if the state is not
  /// updated.
  @protected
  Future<S?> patchCalculatorState(String key, dynamic value);

  @protected
  Future<S?> resetCalculatorState(String key) async => currentState;

  /// Initializes the calculator state with default values.
  ///
  /// Returns a future of the initialized state.
  @protected
  Future<S> initializeCalculatorState();

  /// Performs the calculation and returns the result.
  ///
  /// Returns a future of the computed results of type [R].
  @protected
  Future<R> compute();

  /// Retrieves the default result.
  ///
  /// Returns a future of the default result of type [R].
  @protected
  Future<R> retrieveDefaultResult();

  /// Initializes the calculator by setting up required resources.
  ///
  /// Returns a future that completes when initialization is done.
  @protected
  Future<void> initialize();

  /// Handles errors that occur during computation.
  ///
  /// Takes an [error] argument which represents the error that occurred.
  /// Returns a future that completes when the error handling is done.
  @protected
  Future<void> handleComputeError(dynamic error);

  /// Checks if the calculator state is valid.
  ///
  /// Returns a future of `true` if the state is valid, otherwise `
  /// false`.
  @protected
  Future<bool> isCalculatorStateValid() async => true;

  /// Checks if the calculator state is dirty, i.e., different from the default
  /// state.
  ///
  /// Returns a future of `true` if the state is dirty, otherwise `false`.
  @protected
  Future<bool> isCalculatorStateDirty() async {
    return defaultCalculatorState.fields != currentState.fields;
  }

  /// Initializes the default calculator state.
  ///
  /// Returns a future of the default state of type [S].
  @protected
  Future<S> initializeDefaultCalculatorState() async => currentState;

  /// Clears the calculator state and sets it to the default state.
  ///
  /// Returns a future of the cleared state of type [S].
  @protected
  Future<S> clearCalculatorState() async => defaultCalculatorState;

  /// Saves the calculator state.
  ///
  /// Returns a future of `true` if the state is saved successfully,
  /// otherwise `false`.
  @protected
  Future<bool> saveCalculatorState() async => true;

  /// Loads the metadata of the calculator.
  @protected
  Future<Map<String, dynamic>> loadMetadata() async {
    return const <String, dynamic>{};
  }

  /// Shares the calculator state.
  ///
  /// Throws an exception if the `shareCalculatorState` function is not
  /// implemented.
  @protected
  Future<void> shareCalculatorState(BuildContext context) async {
    throw '`shareCalculatorState` function is not implemented';
  }

  /// Exports the calculator state to PDF.
  ///
  /// Throws an exception if the `exportToPdf` function is not implemented.
  @protected
  Future<void> exportToPdf(BuildContext context) async {
    throw '`exportToPdf` function is not implemented';
  }

  /// Exports the calculator state to CSV.
  /// Throws an exception if the `exportToCsv` function is not implemented.
  @protected
  Future<void> exportToCsv(BuildContext context) async {
    throw '`exportToCsv` function is not implemented';
  }

  /// Export the calculator state to an Excel file.
  /// Throws an exception if the `exportToExcel` function is not implemented.
  @protected
  Future<void> exportToExcel(BuildContext context) async {
    throw '`exportToExcel` function is not implemented';
  }

  /// Determines if events should be processed in order.
  ///
  /// Returns `false` by default, meaning events can be processed out of order.
  @override
  bool shouldProcessEventInOrder() => false;

  /// Handles settings changes.
  @protected
  @mustCallSuper
  void handleSettingsChanges(FastAppSettingsBlocState state) {
    if (isInitialized) {
      debugLog('Settings changed, reloading metadata', debugLabel: debugLabel);
      addDebouncedLoadMetadataEvent(
        FastCalculatorBlocEvent.loadMetadata<R>() as E,
      );
    }
  }

  /// Maps an event to a new state and emits the state changes as a stream.
  ///
  /// Takes a [FastCalculatorBlocEvent] and returns a stream of state changes.
  /// Uses an asynchronous generator to yield new states based on the incoming
  /// event.
  @override
  Stream<S> mapEventToState(FastCalculatorBlocEvent event) async* {
    final payload = event.payload;
    final eventType = event.type;

    if (eventType == FastCalculatorBlocEventType.init) {
      yield* handleInitEvent();
    } else if (eventType == FastCalculatorBlocEventType.initialized) {
      yield* handleInitializedEvent();
    } else if (eventType == FastCalculatorBlocEventType.initFailed) {
      yield* handleInitializeFailedEvent(
        payload as FastCalculatorBlocEventPayload<R>?,
      );
    } else if (isInitialized) {
      if (eventType == FastCalculatorBlocEventType.patchValue) {
        yield* handlePatchValueEvent(payload);
      } else if (eventType == FastCalculatorBlocEventType.compute) {
        yield* handleComputeEvent();
      } else if (eventType == FastCalculatorBlocEventType.computed) {
        yield* handleComputedEvent(payload);
      } else if (eventType == FastCalculatorBlocEventType.computeFailed) {
        if (payload?.error != null) {
          await handleComputeError(payload!.error);
        }

        yield currentState.copyWith(
          results: await retrieveDefaultResult(),
          isBusy: false,
        ) as S;
      } else if (eventType == FastCalculatorBlocEventType.clear) {
        final nextState = await clearCalculatorState();
        await saveCalculatorState();
        yield nextState.copyWith(isInitialized: true) as S;
        addComputeEvent();
      } else if (eventType == FastCalculatorBlocEventType.share) {
        if (payload?.value is BuildContext) {
          await shareCalculatorState(payload!.value as BuildContext);
        }
      } else if (eventType == FastCalculatorBlocEventType.exportToPdf) {
        if (payload?.value is BuildContext) {
          await exportToPdf(payload!.value as BuildContext);
        }
      } else if (eventType == FastCalculatorBlocEventType.exportToCsv) {
        if (payload?.value is BuildContext) {
          await exportToCsv(payload!.value as BuildContext);
        }
      } else if (eventType == FastCalculatorBlocEventType.exportToExcel) {
        if (payload?.value is BuildContext) {
          await exportToExcel(payload!.value as BuildContext);
        }
      } else if (eventType == FastCalculatorBlocEventType.reset) {
        yield* handleResetEvent();
      } else if (eventType == FastCalculatorBlocEventType.loadMetadata) {
        yield* handleLoadMetadataEvent();
      } else if (eventType == FastCalculatorBlocEventType.patchMetadata) {
        yield* handlePatchMetadataEvent(payload);
      }
    } else {
      assert(false, 'FastCalculatorBloc is not initialized yet.');
    }
  }

  // Handlers for various events in the FastCalculatorBloc

  /// Handles the initialization event by initializing the calculator and
  /// emitting the new state.
  ///
  /// If the calculator can be initialized, it sets the initializing flag
  /// to `true` and attempts to initialize the calculator. Then, it emits the
  /// new state and triggers the `initialized` or `initFailed` event
  /// depending on the result.
  ///
  /// Yields a stream of state changes.
  @protected
  Stream<S> handleInitEvent() async* {
    if (canInitialize) {
      debugLog('Initializing calculator', debugLabel: debugLabel);

      isInitializing = true;
      yield currentState.copyWith(isInitializing: isInitializing) as S;

      try {
        await initialize();
        defaultCalculatorState = await initializeDefaultCalculatorState();
        final nextState = await initializeCalculatorState();

        yield currentState
            .merge(defaultCalculatorState)
            .merge(nextState)
            .copyWith(
              isInitializing: isInitializing,
              metadata: await loadMetadata(),
            ) as S;

        addEvent(FastCalculatorBlocEvent.initialized<R>());
      } catch (error, stacktrace) {
        addEvent(FastCalculatorBlocEvent.initFailed<R>(error, stacktrace));
      }
    }
  }

  /// Handles the initialized event by updating the `isInitialized` and
  /// `isInitializing` flags.
  ///
  /// After updating the flags, it emits the new state and triggers the
  /// `compute` event.
  ///
  /// Yields a stream of state changes.
  @protected
  Stream<S> handleInitializedEvent() async* {
    if (isInitializing) {
      debugLog('Calculator initialized', debugLabel: debugLabel);

      isInitialized = true;

      defaultCalculatorState = defaultCalculatorState.copyWith(
        isInitializing: isInitializing,
        isInitialized: isInitialized,
      ) as S;

      yield currentState.copyWith(
        isInitializing: isInitializing,
        isInitialized: isInitialized,
      ) as S;

      addComputeEvent();
    }
  }

  /// Handles an event where the calculator fails to initialize by resetting the
  /// `isInitialized` and `isInitializing` flags and emitting a new state.
  ///
  /// If the `payload.error` property is not null, the method logs a message
  /// indicating that the calculator failed to initialize and includes the error
  /// object in the log message. If the `payload.stacktrace` property is
  /// not null, the method also logs the stack trace associated with the error.
  ///
  @protected
  Stream<S> handleInitializeFailedEvent(
    FastCalculatorBlocEventPayload<R>? payload,
  ) async* {
    // TODO: allow to log errors and stacktraces to an external tool.
    if (payload?.error != null) {
      debugLog(
        'Failed to initialize calculator',
        value: payload!.error,
        debugLabel: debugLabel,
      );

      if (payload.stacktrace != null) {
        debugLog(
          'Stacktrace',
          value: payload.stacktrace,
          debugLabel: debugLabel,
        );
      }
    }

    if (isInitializing) {
      isInitializing = false;
      isInitialized = false;

      // TODO: Notifies the state when the initialization process fails.
      yield currentState.copyWith(
        isInitializing: isInitializing,
        isInitialized: isInitialized,
      ) as S;
    }
  }

  /// Handles the reset event by setting the `isInitialized` and
  /// `isInitializing` flags to `false`.
  ///
  /// Emits the new state and triggers the `init` event.
  ///
  /// Yields a stream of state changes.
  @protected
  Stream<S> handleResetEvent() async* {
    debugLog('Resetting calculator', debugLabel: debugLabel);

    isInitialized = false;
    isInitializing = false;

    yield currentState.copyWith(
      isInitialized: isInitialized,
      isInitializing: isInitializing,
    ) as S;

    addEvent(FastCalculatorBlocEvent.init<R>());
  }

  /// Handles the load metadata event by loading the calculator metadata.
  /// Emits the new state.
  @protected
  Stream<S> handleLoadMetadataEvent() async* {
    final metadata = await loadMetadata();
    final newMetadata = mergeMetadata(metadata);

    yield currentState.copyWith(metadata: newMetadata) as S;

    addComputeEvent();
  }

  /// Handles the patch value event by updating a single field in the
  /// calculator state.
  ///
  /// Takes a [FastCalculatorBlocEventPayload] containing the key and value
  /// to update.
  ///
  /// If the state is successfully updated, saves the calculator state,
  /// emits the new state, and triggers the `compute` event with a debounce.
  ///
  /// Yields a stream of state changes.
  @protected
  Stream<S> handlePatchValueEvent(
    FastCalculatorBlocEventPayload? payload,
  ) async* {
    if (payload != null && payload.key != null) {
      final state = await patchCalculatorState(payload.key!, payload.value);
      yield* processCalculatorValueChange(state);
    }
  }

  Stream<S> handlePatchMetadataEvent(
    FastCalculatorBlocEventPayload? payload,
  ) async* {
    if (payload != null && payload.value is Map<String, dynamic>) {
      final newMetadata = mergeMetadata(payload.value as Map<String, dynamic>);

      yield currentState.copyWith(metadata: newMetadata) as S;
    }
  }

  Map<String, dynamic> mergeMetadata(Map<String, dynamic> partialMetadata) {
    return {...currentMetadata, ...partialMetadata};
  }

  @protected
  Stream<S> processCalculatorValueChange(S? state) async* {
    if (state != null) {
      await saveCalculatorState();
      yield state;

      addComputeEvent();
    }
  }

  @protected
  void addComputeEvent() {
    if (debouceComputeEvents) {
      addDebouncedComputeEvent(FastCalculatorBlocEvent.compute<R>() as E);
    } else {
      addEvent(FastCalculatorBlocEvent.compute<R>() as E);
    }
  }

  /// The initializer to yield the current state before computation begins.
  @protected
  @mustCallSuper
  Stream<S> willCompute() async* {
    final (isValid, isDirty) = await retrieveCalculatorStateStatus();

    yield currentState.copyWith(
      isValid: isValid,
      isDirty: isDirty,
      isBusy: true,
    ) as S;
  }

  /// Handles the compute event by updating the state flags and performing
  /// the calculation.
  ///
  /// Sets the `isValid`, `isDirty`, and `isBusy` flags in the state, then
  /// attempts to perform the computation. If successful, triggers
  /// the `computed` event.
  ///
  /// If an error occurs, triggers the `computeFailed` event.
  ///
  /// Yields a stream of state changes.
  @protected
  Stream<S> handleComputeEvent() async* {
    debugLog('Will compute', debugLabel: debugLabel);
    yield* willCompute();

    debugLog('Computing results', debugLabel: debugLabel);

    final (isValid, isDirty) = await retrieveCalculatorStateStatus();

    yield currentState.copyWith(
      isValid: isValid,
      isDirty: isDirty,
      isBusy: true,
    ) as S;

    try {
      final results = await performCancellableAsyncOperation(compute());

      if (results != null) {
        addEvent(FastCalculatorBlocEvent.computed<R>(results));
      }
    } catch (error, stacktrace) {
      debugLog(
        'Failed to compute results',
        value: error,
        debugLabel: debugLabel,
      );

      debugLog(
        'Stacktrace',
        value: stacktrace,
        debugLabel: debugLabel,
      );

      addEvent(FastCalculatorBlocEvent.computeFailed<R>(error));
    }
  }

  /// Handles the computed event by updating the state with the computed
  /// results.
  @protected
  Stream<S> handleComputedEvent(
    FastCalculatorBlocEventPayload? payload,
  ) async* {
    if (payload != null) {
      debugLog('Results computed', debugLabel: debugLabel);
      debugLog('Results', value: payload.results, debugLabel: debugLabel);

      final (isValid, isDirty) = await retrieveCalculatorStateStatus();

      if (isValid) {
        final fields = currentState.fields;
        // Note: capture the fields outside the closure to avoid
        // capturing the whole state object.
        final params = fields.toJson();

        _analyticsDebouncer?.run(() {
          if (params.isNotEmpty && !closed) {
            analyticsEventController.add(BlocAnalyticsEvent(
              type: FastCalculatorBlocAnalyticEvent.computedFields,
              parameters: params,
            ));
          }
        });
      }

      yield currentState.copyWith(
        results: payload.results,
        isValid: isValid,
        isDirty: isDirty,
        isBusy: false,
      ) as S;
    }

    yield currentState.copyWith(isBusy: false) as S;
  }

  /// Handles internal errors that occur within the bloc.
  ///
  /// Takes an [error] argument representing the error that occurred.
  /// Logs the error to the console.
  @override
  @protected
  void handleInternalError(dynamic error, StackTrace stackTrace) {
    debugLog(
      'Internal Bloc error occured',
      value: error,
      debugLabel: debugLabel,
    );

    debugLog(
      'Stacktrace',
      value: stackTrace,
      debugLabel: debugLabel,
    );
  }

  /// Retrieves the current status of the calculator state, including
  /// validity and dirtiness.
  ///
  /// It asynchronously checks if the calculator state is valid and dirty,
  /// then logs and returns the results.
  ///
  /// Returns a [Future] that resolves to a tuple with [isValid] indicating
  /// if the state is valid and [isDirty] indicating if the state has been
  /// modified.
  Future<(bool isValid, bool isDirty)> retrieveCalculatorStateStatus() async {
    final isValid = await isCalculatorStateValid();
    final isDirty = await isCalculatorStateDirty();

    debugLog(
      'Calculator state is dirty',
      value: isDirty,
      debugLabel: debugLabel,
    );

    debugLog(
      'Calculator state is valid',
      value: isValid,
      debugLabel: debugLabel,
    );

    return (isValid, isDirty);
  }
}
