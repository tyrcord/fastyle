import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:flutter/foundation.dart';
import 'package:tbloc_dart/tbloc_dart.dart';

typedef FastCalculatorBlocDebounceEventCallback<
        E extends FastCalculatorBlocEvent>
    = void Function(E event);

abstract class FastCalculatorBloc<
    E extends FastCalculatorBlocEvent,
    S extends FastCalculatorBlocState,
    R extends FastCalculatorResults> extends BidirectionalBloc<E, S> {
  @protected
  late S defaultCalculatorState;

  late FastCalculatorBlocDebounceEventCallback<E> addDebounceEvent;

  /// The debug label is used to identify the bloc in the logs.
  @protected
  String? debugLabel;

  FastCalculatorBloc({
    required super.initialState,
    this.debugLabel,
  }) {
    addDebounceEvent = debounceEvent((event) => addEvent(event));
  }

  @protected
  Future<S?> patchCalculatorState(String key, dynamic value);

  @protected
  Future<S> initializeCalculatorState();

  @protected
  Future<R> compute();

  @protected
  Future<R> retrieveDefaultResult();

  @protected
  Future<void> initialize();

  @protected
  Future<void> handleComputeError(dynamic error);

  @protected
  Future<bool> isCalculatorStateValid() async => true;

  @protected
  Future<bool> isCalculatorStateDirty() async {
    return defaultCalculatorState.fields != currentState.fields;
  }

  @protected
  Future<S> initializeDefaultCalculatorState() async => currentState;

  @protected
  Future<S> clearCalculatorState() async => defaultCalculatorState;

  @protected
  Future<bool> saveCalculatorState() async => true;

  @protected
  Future<void> shareCalculatorState() async {
    throw '`shareCalculatorState` function is not implemented';
  }

  @override
  bool shouldProcessEventInOrder() => false;

  @override
  Stream<S> mapEventToState(FastCalculatorBlocEvent event) async* {
    final payload = event.payload;
    final eventType = event.type;

    if (eventType == FastCalculatorBlocEventType.init) {
      yield* handleInitEvent();
    } else if (eventType == FastCalculatorBlocEventType.initialized) {
      yield* handleInitializedEvent();
    } else if (eventType == FastCalculatorBlocEventType.initFailed) {
      yield* handleInitializeFailedEvent();
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

  /// Log a message to the console.
  /// If the [debugLabel] is not null, it will be prepended to the message.
  /// If the [debugLabel] is null, the message will be printed as is.
  void log(String message, {dynamic value}) {
    if (kDebugMode) {
      if (debugLabel != null) {
        message = '$debugLabel: $message';
      }

      if (value != null) {
        message = '$message => $value';
      }

      debugPrint(message);
    }
  }

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
      } catch (error) {
        addEvent(FastCalculatorBlocEvent.initFailed<R>(error));
      }
    }
  }

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

  Stream<S> handleInitializeFailedEvent() async* {
    if (isInitializing) {
      isInitializing = false;
      isInitialized = false;

      yield currentState.copyWith(
        isInitializing: isInitializing,
        isInitialized: isInitialized,
      ) as S;
    }
  }

  Stream<S> handleResetEvent() async* {
    isInitialized = false;
    isInitializing = false;

    yield currentState.copyWith(
      isInitialized: isInitialized,
      isInitializing: isInitializing,
    ) as S;

    addEvent(FastCalculatorBlocEvent.init<R>());
  }

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

  @override
  @protected
  void handleInternalError(dynamic error) {
    log('Internal Bloc error occured $error');
  }
}
