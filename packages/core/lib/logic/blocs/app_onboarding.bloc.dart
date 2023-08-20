// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// The [FastAppOnboardingBloc] is used to manage the app onboarding process.
/// It can be used to handle the completion of onboarding steps and track the
/// current onboarding state.
class FastAppOnboardingBloc extends BidirectionalBloc<
    FastAppOnboardingBlocEvent, FastAppOnboardingBlocState> {
  final FastAppOnboardingDataProvider _dataProvider;
  late FastAppOnboardingDocument _persistedOnboarding;

  static bool _hasBeenInstantiated = false;
  static late FastAppOnboardingBloc instance;

  FastAppOnboardingBloc._({FastAppOnboardingBlocState? initialState})
      : _dataProvider = FastAppOnboardingDataProvider(),
        super(initialState: initialState ?? FastAppOnboardingBlocState());

  factory FastAppOnboardingBloc({FastAppOnboardingBlocState? initialState}) {
    if (!_hasBeenInstantiated) {
      instance = FastAppOnboardingBloc._(initialState: initialState);
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  @override
  bool canClose() => false;

  @override
  Stream<FastAppOnboardingBlocState> mapEventToState(
      FastAppOnboardingBlocEvent event) async* {
    final payload = event.payload;
    final type = event.type;

    if (type == FastAppOnboardingBlocEventType.init) {
      yield* handleInitEvent();
    } else if (type == FastAppOnboardingBlocEventType.initialized) {
      yield* handleInitializedEvent(payload);
    } else if (isInitialized) {
      switch (type) {
        case FastAppOnboardingBlocEventType.initializationCompleted:
          yield* handleInitializationCompletedEvent();
        default:
          break;
      }
    } else {
      assert(false, 'FastAppOnboardingBloc is not initialized yet.');
    }
  }

  /// Handle the [FastAppOnboardingBlocEventType.init] event.
  /// This event is used to initialize the bloc.
  /// It will retrieve the onboarding data from the data provider and
  /// dispatch a [FastAppOnboardingBlocEventType.initialized] event.
  Stream<FastAppOnboardingBlocState> handleInitEvent() async* {
    if (canInitialize) {
      isInitializing = true;
      yield currentState.copyWith(isInitializing: true);

      final onboarding = await _retrievePersistedOnboarding();

      addEvent(FastAppOnboardingBlocEvent.initialized(
        FastAppOnboardingBlocEventPayload(
          isCompleted: onboarding.isCompleted,
        ),
      ));
    }
  }

  /// Handle the [FastAppOnboardingBlocEventType.initialized] event.
  /// This event is used to end the initialization process.
  /// It will set the bloc as initialized and dispatch a new state.
  /// The new state will contain the onboarding data retrieved from
  /// the data provider.
  Stream<FastAppOnboardingBlocState> handleInitializedEvent(
    FastAppOnboardingBlocEventPayload? payload,
  ) async* {
    if (isInitializing) {
      isInitialized = true;

      yield currentState.copyWith(
        isCompleted: payload?.isCompleted ?? false,
        isInitializing: false,
        isInitialized: true,
      );
    }
  }

  /// Handles the `initializationCompleted` event by marking the onboarding
  /// process as completed and updating the state.
  Stream<FastAppOnboardingBlocState>
      handleInitializationCompletedEvent() async* {
    await _persistInitializationCompleted(true);

    yield currentState.copyWith(isCompleted: _persistedOnboarding.isCompleted);
  }

  /// Persists the completion status of the onboarding process.
  ///
  /// The [isCompleted] parameter represents the completion status to
  /// be persisted.
  Future<FastAppOnboardingDocument> _persistInitializationCompleted(
    bool isCompleted,
  ) async {
    if (isCompleted != currentState.isCompleted) {
      final newOnboarding = _persistedOnboarding.copyWith(
        isCompleted: isCompleted,
      );

      await _dataProvider.persistOnboarding(newOnboarding);
    }

    return _retrievePersistedOnboarding();
  }

  /// Retrieve the onboarding data from the data provider.
  Future<FastAppOnboardingDocument> _retrievePersistedOnboarding() async {
    await _dataProvider.connect();

    return (_persistedOnboarding = await _dataProvider.retrieveOnboarding());
  }
}
