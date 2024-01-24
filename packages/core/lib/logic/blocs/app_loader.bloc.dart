// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:

//TODO: @need-review: code from fastyle_dart

class FastAppLoaderBloc
    extends BidirectionalBloc<FastAppLoaderBlocEvent, FastAppLoaderBlocState> {
  /// Keeps track if a singleton instance has been created.
  static bool get hasBeenInstantiated => _hasBeenInstantiated;
  static bool _hasBeenInstantiated = false;

  static final _logger = TLoggerManager.instance.getLogger(debugLabel);
  static const debugLabel = 'FastAppLoaderBloc';

  static late FastAppLoaderBloc _instance;

  static FastAppLoaderBloc get instance {
    if (!_hasBeenInstantiated) return FastAppLoaderBloc();

    return _instance;
  }

  // Method to reset the singleton instance
  static void reset() => _hasBeenInstantiated = false;

  FastAppLoaderBloc._() : super(initialState: FastAppLoaderBlocState());

  factory FastAppLoaderBloc() {
    if (!_hasBeenInstantiated) {
      _instance = FastAppLoaderBloc._();
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  @override
  bool canClose() => false;

  @override
  Stream<FastAppLoaderBlocState> mapEventToState(
    FastAppLoaderBlocEvent event,
  ) async* {
    final eventPayload = event.payload;
    final eventType = event.type;

    _logger.debug('Event received: $eventType');

    if (eventType == FastAppLoaderBlocEventType.init &&
        eventPayload is FastAppLoaderBlocEventPayload) {
      yield* handleInitEvent(eventPayload);
    } else if (eventType == FastAppLoaderBlocEventType.initialized) {
      yield* handleInitializedEvent();
    } else if (eventType == FastAppLoaderBlocEventType.initFailed) {
      yield* handleInitFailedEvent(eventPayload);
    }
  }

  Stream<FastAppLoaderBlocState> handleInitEvent(
    FastAppLoaderBlocEventPayload eventPayload,
  ) async* {
    if (canInitialize) {
      _logger.debug('Initializing...');
      isInitializing = true;

      final errorReporter = eventPayload.errorReporter;
      final jobs = eventPayload.jobs;

      yield currentState.copyWith(
        isLoading: isInitializing,
        isLoaded: false,
        progress: 0,
      );

      if (jobs != null && jobs.isNotEmpty) {
        yield* _runJobs(
          eventPayload.context!,
          jobs,
          errorReporter: errorReporter,
        );
      } else {
        addEvent(const FastAppLoaderBlocEvent.initialized());
      }
    }
  }

  Stream<FastAppLoaderBlocState> handleInitializedEvent() async* {
    if (isInitializing) {
      _logger.debug('Initialized');
      isInitializing = false;

      yield currentState.copyWith(
        isLoading: isInitializing,
        isLoaded: true,
      );
    }
  }

  Stream<FastAppLoaderBlocState> handleInitFailedEvent(
    FastAppLoaderBlocEventPayload? eventPayload,
  ) async* {
    isInitializing = false;

    yield currentState.copyWith(
      error: eventPayload?.error,
      isLoading: isInitializing,
      isLoaded: false,
      progress: 0,
    );
  }

  Stream<FastAppLoaderBlocState> _runJobs(
    BuildContext context,
    Iterable<FastJob> jobs, {
    IFastErrorReporter? errorReporter,
  }) async* {
    final jobRunner = FastJobRunner(context, jobs);
    final stream = jobRunner.run(errorReporter: errorReporter);

    try {
      await for (final currentProgress in stream) {
        yield currentState.copyWith(progress: currentProgress);
      }

      addEvent(const FastAppLoaderBlocEvent.initialized());
    } catch (error) {
      addEvent(FastAppLoaderBlocEvent.initFailed(error));
    }
  }
}
