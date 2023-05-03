import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:flutter/foundation.dart';
import 'package:tbloc/tbloc.dart';

typedef FastCalculatorBlocDebounceEventCallback<
        E extends FastCalculatorBlocEvent>
    = void Function(E event);

/// A generic and customizable FastCalculatorBloc class for managing the
/// business logic of a fast calculator. This class extends the BidirectionalBloc
/// and provides methods for initializing the calculator, patching the calculator
/// state, computing results, and handling various events.
///
/// This class requires three type parameters:
/// - E: The event type, extending [FastCalculatorBlocEvent].
/// - S: The state type, extending [FastCalculatorBlocState].
/// - R: The results type, extending [FastCalculatorResults].
abstract class FastCalculatorBloc<
    E extends FastCalculatorBlocEvent,
    S extends FastCalculatorBlocState,
    R extends FastCalculatorResults> extends BidirectionalBloc<E, S> {
  @protected
  late S defaultCalculatorState;

  late FastCalculatorBlocDebounceEventCallback<E> addDebounceEvent;

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
    this.debugLabel,
    this.debouceComputeEvents = false,
  }) {
    if (debouceComputeEvents) {
      debugPrint('`debouceComputeEvents` is enabled for $runtimeType');
      addDebounceEvent = debounceEvent((event) => addEvent(event));
    } else {
      debugPrint('`debouceComputeEvents` is disabled for $runtimeType');
      addDebounceEvent = addEvent;
    }
  }

  /// Updates a single field in the calculator state.
  ///
  /// Takes [key] as the field key and [value] as the new value to update.
  /// Returns a future of the updated state or `null` if the state is not
  /// updated.
  @protected
  Future<S?> patchCalculatorState(String key, dynamic value);

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

  /// Shares the calculator state.
  ///
  /// Throws an exception if the `shareCalculatorState` function is not
  /// implemented.
  @protected
  Future<void> shareCalculatorState() async {
    throw '`shareCalculatorState` function is not implemented';
  }

  /// Determines if events should be processed in order.
  ///
  /// Returns `false` by default, meaning events can be processed out of order.
  @override
  bool shouldProcessEventInOrder() => false;

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
        yield* handlePatchValueEvent(payload!);
      } else if (eventType == FastCalculatorBlocEventType.compute) {
        yield* handleComputeEvent();
      } else if (eventType == FastCalculatorBlocEventType.computed) {
        yield currentState.copyWith(
          results: payload!.results,
          isBusy: false,
        ) as S;
      } else if (eventType == FastCalculatorBlocEventType.computeFailed) {
        await handleComputeError(payload!.error);

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
        if (payload!.key == 'share') {
          await shareCalculatorState();
        }
      } else if (eventType == FastCalculatorBlocEventType.reset) {
        yield* handleResetEvent();
      }
    } else {
      assert(false, 'FastCalculatorBloc is not initialized yet.');
    }
  }

  /// Logs a message to the console with an optional debug label and value.
  ///
  /// Takes a [message] string and optional [value] to print to the console.
  /// If [debugLabel] is not null, it will be prepended to the message.
  /// If [debugLabel] is null, the message will be printed as is.
  void log(String message, {dynamic value}) {
    if (kDebugMode) {
      if (debugLabel != null) {
        message = '[$debugLabel]: $message';
      }

      if (value != null) {
        message = '$message => $value';
      }

      debugPrint(message);
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
      isInitializing = true;
      yield currentState.copyWith(isInitializing: isInitializing) as S;

      try {
        await initialize();
        defaultCalculatorState = await initializeDefaultCalculatorState();
        final nextState = await initializeCalculatorState();

        yield currentState
            .merge(defaultCalculatorState)
            .merge(nextState)
            .copyWith(isInitializing: isInitializing) as S;

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
  /// object in the log message. If the `payload.stacktrace` property is not null,
  /// the method also logs the stack trace associated with the error.
  ///
  @protected
  Stream<S> handleInitializeFailedEvent(
    FastCalculatorBlocEventPayload<R>? payload,
  ) async* {
    // TODO: allow to log errors and stacktraces to an external tool.
    if (payload?.error != null) {
      log('Failed to initialize calculator', value: payload!.error);

      if (payload.stacktrace != null) {
        log('Stacktrace', value: payload.stacktrace);
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
    isInitialized = false;
    isInitializing = false;

    yield currentState.copyWith(
      isInitialized: isInitialized,
      isInitializing: isInitializing,
    ) as S;

    addEvent(FastCalculatorBlocEvent.init<R>());
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
    FastCalculatorBlocEventPayload payload,
  ) async* {
    var state = await patchCalculatorState(payload.key!, payload.value);

    if (state != null) {
      await saveCalculatorState();
      yield state;
      addDebounceEvent(FastCalculatorBlocEvent.compute<R>() as E);
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
    yield currentState.copyWith(
      isValid: await isCalculatorStateValid(),
      isDirty: await isCalculatorStateDirty(),
      isBusy: true,
    ) as S;

    try {
      final results = await performCancellableAsyncOperation(compute());

      if (results != null) {
        addEvent(FastCalculatorBlocEvent.computed<R>(results));
      }
    } catch (error) {
      addEvent(FastCalculatorBlocEvent.computeFailed<R>(error));
    }
  }

  /// Handles internal errors that occur within the bloc.
  ///
  /// Takes an [error] argument representing the error that occurred.
  /// Logs the error to the console.
  @override
  @protected
  void handleInternalError(dynamic error) {
    log('Internal Bloc error occured $error');
  }
}
