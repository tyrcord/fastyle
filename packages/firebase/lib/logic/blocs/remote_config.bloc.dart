// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tbloc/tbloc.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_firebase/fastyle_firebase.dart';

class FastFirebaseRemoteConfigBloc extends BidirectionalBloc<
    FastFirebaseRemoteConfigBlocEvent, FastFirebaseRemoteConfigBlocState> {
  static const String _debugLabel = 'FastFirebaseRemoteConfigBloc';
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static late FastFirebaseRemoteConfigBloc instance;
  static final _manager = TLoggerManager();
  static bool _hasBeenInstantiated = false;

  FastFirebaseRemoteConfigBloc._({
    FastFirebaseRemoteConfigBlocState? initialState,
  }) : super(initialState: initialState ?? FastFirebaseRemoteConfigBlocState());

  factory FastFirebaseRemoteConfigBloc({
    FastFirebaseRemoteConfigBlocState? initialState,
  }) {
    if (!_hasBeenInstantiated) {
      instance = FastFirebaseRemoteConfigBloc._(initialState: initialState);
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  @override
  bool canClose() => false;

  @override
  Stream<FastFirebaseRemoteConfigBlocState> mapEventToState(
    FastFirebaseRemoteConfigBlocEvent event,
  ) async* {
    final payload = event.payload;
    final type = event.type;

    if (type == FastFirebaseRemoteConfigBlocEventType.init) {
      yield* handleInitEvent(payload?.defaultConfig);
    } else if (type == FastFirebaseRemoteConfigBlocEventType.initialized) {
      yield* handleInitializedEvent(enabled: payload?.enabled);
    } else {
      assert(false, 'FastFirebaseRemoteConfigBloc is not initialized yet.');
    }
  }

  Stream<FastFirebaseRemoteConfigBlocState> handleInitEvent(
    Map<String, dynamic>? defaultConfig,
  ) async* {
    if (canInitialize) {
      isInitializing = true;
      yield currentState.copyWith(isInitializing: true);

      final remoteConfig = FirebaseRemoteConfig.instance;

      if (defaultConfig != null) {
        _logger.debug('setting default config: $defaultConfig');
        await remoteConfig.setDefaults(defaultConfig);
      }

      _logger.debug('setting config settings');
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        minimumFetchInterval: const Duration(hours: 1),
        fetchTimeout: const Duration(minutes: 1),
      ));

      bool enabled = false;

      try {
        // TODO: listen on config changes ?
        _logger.debug('fetching and activating remote config');
        enabled = await remoteConfig.fetchAndActivate();
      } catch (error, stackTrace) {
        _logger.error(
          'An error occured when fetching and activating remote config: $error',
          stackTrace,
        );
      }

      _logger.info('remote config is enabled', enabled);

      if (enabled) {
        final config = remoteConfig.getAll();
        await _updateAppFeatures(config);
      } else {
        _logger.warning('remote config is not enabled');
      }

      addEvent(FastFirebaseRemoteConfigBlocEvent.initialized(enabled: enabled));
    }
  }

  Stream<FastFirebaseRemoteConfigBlocState> handleInitializedEvent({
    bool? enabled = false,
  }) async* {
    if (isInitializing) {
      final remoteConfig = FirebaseRemoteConfig.instance;
      isInitialized = true;

      yield currentState.copyWith(
        config: remoteConfig,
        isEnabled: enabled,
        isInitializing: false,
        isInitialized: true,
      );
    }
  }

  Future<void> _updateAppFeatures(Map<String, RemoteConfigValue> config) async {
    final featureToEnable = <FastAppFeatures>[];
    final featureToDisable = <FastAppFeatures>[];

    config.forEach((key, value) {
      if (key.startsWith('feature')) {
        key = key.replaceFirst('feature', '');
        final featureKey = toCamelCase(key);

        try {
          final feature = FastAppFeatures.values.byName(featureKey);
          final isFeatureEnabled = value.asBool();

          if (isFeatureEnabled) {
            _logger.info('enabling feature', featureKey);
            featureToEnable.add(feature);
          } else {
            _logger.info('disabling feature', featureKey);
            featureToDisable.add(feature);
          }
        } catch (e) {
          _logger.warning('unknown feature: $featureKey');
        }
      }
    });

    final appFeaturesBloc = FastAppFeaturesBloc.instance;
    final enableFeaturesEvent = FastAppFeaturesBlocEvent.enableFeatures(
      featureToEnable,
    );
    final disableFeaturesEvent = FastAppFeaturesBlocEvent.disableFeatures(
      featureToDisable,
    );

    appFeaturesBloc.addEvent(enableFeaturesEvent);
    appFeaturesBloc.addEvent(disableFeaturesEvent);
  }
}
