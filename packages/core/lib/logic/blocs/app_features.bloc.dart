// Package imports:
import 'package:tbloc/tbloc.dart';
import 'package:tlogger/logger.dart';
import 'package:tstore/tstore.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppFeaturesBloc extends BidirectionalBloc<FastAppFeaturesBlocEvent,
    FastAppFeaturesBlocState> {
  /// Keeps track if a singleton instance has been created.
  static bool get hasBeenInstantiated => _hasBeenInstantiated;
  static bool _hasBeenInstantiated = false;

  static final _logger = TLoggerManager.instance.getLogger(debugLabel);
  static const debugLabel = 'FastAppFeaturesBloc';

  static late FastAppFeaturesBloc _instance;

  static FastAppFeaturesBloc get instance {
    if (!_hasBeenInstantiated) return FastAppFeaturesBloc();

    return _instance;
  }

  static final _dataProvider = FastAppFeaturesDataProvider();

  // Method to reset the singleton instance
  static void reset() => instance.resetBloc();

  FastAppFeaturesBloc._() : super(initialState: FastAppFeaturesBlocState());

  factory FastAppFeaturesBloc() {
    if (!_hasBeenInstantiated) {
      _instance = FastAppFeaturesBloc._();
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  @override
  bool canClose() => false;

  bool isFeatureEnabled(FastAppFeatures appFeature) {
    return currentState.isFeatureEnabled(appFeature);
  }

  @override
  Stream<FastAppFeaturesBlocState> mapEventToState(
    FastAppFeaturesBlocEvent event,
  ) async* {
    final payload = event.payload;
    final type = event.type;

    _logger.debug('Event received: $type');

    if (type == FastAppFeaturesBlocEventType.init) {
      yield* handleInitEvent();
    } else if (type == FastAppFeaturesBlocEventType.initialized) {
      if (payload is FastAppFeaturesBlocEventPayload) {
        assert(payload.features != null);
        yield* handleInitializedEvent(payload.features!);
      }
    } else if (isInitialized) {
      switch (type) {
        case FastAppFeaturesBlocEventType.retrieveFeatures:
          yield* handleRetrieveFeaturesEvent();
        case FastAppFeaturesBlocEventType.featuresRetrieved:
          if (payload is FastAppFeaturesBlocEventPayload) {
            assert(payload.features != null);
            yield* handleFeaturesRetrievedEvent(payload.features!);
          }

        case FastAppFeaturesBlocEventType.enableFeature:
          if (payload is FastAppFeaturesBlocEventPayload) {
            assert(payload.feature != null);
            yield* handleEnableFeaturesEvent([payload.feature!]);
          }

        case FastAppFeaturesBlocEventType.enableFeatures:
          if (payload is FastAppFeaturesBlocEventPayload) {
            assert(payload.features != null);
            yield* handleEnableFeaturesEvent(payload.features!);
          }

        case FastAppFeaturesBlocEventType.disableFeature:
          if (payload is FastAppFeaturesBlocEventPayload) {
            assert(payload.feature != null);
            yield* handleDisableFeaturesEvent([payload.feature!]);
          }

        case FastAppFeaturesBlocEventType.disableFeatures:
          if (payload is FastAppFeaturesBlocEventPayload) {
            assert(payload.features != null);
            yield* handleDisableFeaturesEvent(payload.features!);
          }

        default:
          assert(false, 'FastAppFeaturesBloc is not initialized yet.');
      }
    } else {
      assert(false, 'FastAppFeaturesBloc is not initialized yet.');
    }
  }

  Stream<FastAppFeaturesBlocState> handleInitEvent() async* {
    if (canInitialize) {
      _logger.debug('Initializing...');
      isInitializing = true;
      yield currentState.copyWith(isInitializing: true);

      final features = await _retrieveFeatures();

      subxList.add(
        _dataProvider.onChanges.listen((TStoreChanges changes) {
          addEvent(const FastAppFeaturesBlocEvent.retrieveFeatures());
        }),
      );

      addEvent(FastAppFeaturesBlocEvent.initialized(features));
    }
  }

  Stream<FastAppFeaturesBlocState> handleInitializedEvent(
    List<FastFeatureEntity> features,
  ) async* {
    if (isInitializing) {
      _logger.debug('Initialized');
      isInitialized = true;

      yield currentState.copyWith(
        isInitializing: false,
        isInitialized: true,
        features: features,
      );
    }
  }

  Stream<FastAppFeaturesBlocState> handleRetrieveFeaturesEvent() async* {
    if (isInitialized) {
      yield currentState.copyWith(isRetrievingFeatures: true);

      final features = await _retrieveFeatures();

      addEvent(FastAppFeaturesBlocEvent.featuresRetrieved(features));
    }
  }

  Stream<FastAppFeaturesBlocState> handleFeaturesRetrievedEvent(
    List<FastFeatureEntity> features,
  ) async* {
    if (isInitialized) {
      yield currentState.copyWith(
        isRetrievingFeatures: false,
        features: features,
      );
    }
  }

  Stream<FastAppFeaturesBlocState> handleEnableFeaturesEvent(
    List<FastFeatureEntity> features,
  ) async* {
    if (isInitialized) {
      await _dataProvider.enableFeatures(features);
      yield currentState.copyWith(features: await _retrieveFeatures());
    }
  }

  Stream<FastAppFeaturesBlocState> handleDisableFeaturesEvent(
    List<FastFeatureEntity> features,
  ) async* {
    if (isInitialized) {
      await _dataProvider.disableFeatures(features);
      yield currentState.copyWith(features: await _retrieveFeatures());
    }
  }

  Future<List<FastFeatureEntity>> _retrieveFeatures() async {
    await _dataProvider.connect();

    return _dataProvider.listAllFeatures();
  }
}
