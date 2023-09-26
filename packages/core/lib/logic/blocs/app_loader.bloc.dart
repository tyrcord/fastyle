// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:

//TODO: @need-review: code from fastyle_dart

class FastAppLoaderBloc
    extends BidirectionalBloc<FastAppLoaderBlocEvent, FastAppLoaderBlocState> {
  static bool _hasBeenInstantiated = false;
  static late FastAppLoaderBloc instance;

  factory FastAppLoaderBloc({FastAppLoaderBlocState? initialState}) {
    if (!_hasBeenInstantiated) {
      instance = FastAppLoaderBloc._(initialState);
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  FastAppLoaderBloc._(FastAppLoaderBlocState? initialState)
      : super(initialState: initialState ?? FastAppLoaderBlocState());

  @override
  bool canClose() => false;

  @override
  Stream<FastAppLoaderBlocState> mapEventToState(
    FastAppLoaderBlocEvent event,
  ) async* {
    final eventPayload = event.payload;
    final eventType = event.type;

    if (eventType == FastAppLoaderBlocEventType.init &&
        !isInitialized &&
        !isInitializing) {
      final jobs = eventPayload!.jobs;
      final errorReporter = eventPayload.errorReporter;
      isInitializing = true;

      yield currentState.copyWith(isLoading: isInitializing);

      if (jobs != null && jobs.isNotEmpty) {
        yield* _runJobs(
          eventPayload.context!,
          jobs,
          errorReporter: errorReporter,
        );
      } else {
        addEvent(const FastAppLoaderBlocEvent.initialized());
      }
    } else if (eventType == FastAppLoaderBlocEventType.initialized &&
        !isInitialized &&
        isInitializing) {
      isInitialized = true;

      yield currentState.copyWith(
        isLoading: isInitializing,
        isLoaded: isInitialized,
      );
    } else if (eventType == FastAppLoaderBlocEventType.initFailed) {
      isInitializing = false;
      isInitialized = false;

      yield currentState.copyWith(
        error: eventPayload!.error,
        isLoading: isInitializing,
        isLoaded: isInitialized,
        progress: 0,
      );
    }
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
