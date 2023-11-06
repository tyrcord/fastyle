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
  FastAppSettingsBloc appSettingsBloc = FastAppSettingsBloc();

  /// The debug label used to identify the bloc in the logs.
  @protected
  String? debugLabel;

  /// Determines if compute events should be debounced or not.
  @protected
  bool debouceComputeEvents;

  /// Constructs a new [FastCalculatorBloc] instance.
  ///
  /// [initialState] is required and represents the initial state of the bloc.
  /// [debugLabel] is an optional identifier for the bloc in the logs.
  /// [debouceComputeEvents] determines if compute events should be debounced,
  /// and defaults to `false`.
  FastCalculatorBloc({
    required super.initialState,
    super.enableForceBuildEvents = true,
    this.debugLabel,
    this.debouceComputeEvents = false,
  }) {
    if (debouceComputeEvents) {
      debugPrint('`debouceComputeEvents` is enabled for $runtimeType');
    } else {
      debugPrint('`debouceComputeEvents` is disabled for $runtimeType');
    }

    addDebouncedComputeEvent = debounceEvent((event) => addEvent(event));
    addDebouncedLoadMetadataEvent = debounceEvent((event) => addEvent(event));

    subxList.add(appSettingsBloc.onData.listen(handleSettingsChanges));
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
      } else if (eventType == FastCalculatorBlocEventType.resetValue) {
        yield* handleResetValueEvent(payload);
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
        addEvent(FastCalculatorBlocEvent.compute<R>());
      } else if (eventType == FastCalculatorBlocEventType.custom) {
        if (payload!.key == 'share' && payload.value is BuildContext) {
          await shareCalculatorState(payload.value as BuildContext);
        }
      } else if (eventType == FastCalculatorBlocEventType.reset) {
        yield* handleResetEvent();
      } else if (eventType == FastCalculatorBlocEventType.loadMetadata) {
        yield* handleLoadMetadataEvent();
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

      addEvent(FastCalculatorBlocEvent.compute<R>());
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
    yield currentState.copyWith(metadata: await loadMetadata()) as S;

    addEvent(FastCalculatorBlocEvent.compute<R>());
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

  Stream<S> handleResetValueEvent(
    FastCalculatorBlocEventPayload? payload,
  ) async* {
    if (payload != null && payload.key != null) {
      final state = await resetCalculatorState(payload.key!);
      yield* processCalculatorValueChange(state);
    }
  }

  @protected
  Stream<S> processCalculatorValueChange(S? state) async* {
    if (state != null) {
      await saveCalculatorState();
      yield state;

      if (debouceComputeEvents) {
        addDebouncedComputeEvent(FastCalculatorBlocEvent.compute<R>() as E);
      } else {
        addEvent(FastCalculatorBlocEvent.compute<R>() as E);
      }
    }
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
