// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_firebase/fastyle_firebase.dart';

class FastFirebaseRemoteConfigBloc extends BidirectionalBloc<
    FastFirebaseRemoteConfigBlocEvent, FastFirebaseRemoteConfigBlocState> {
  static FastFirebaseRemoteConfigBloc? _singleton;
  static String debugLabel = 'FastFirebaseRemoteConfigBloc';

  FastFirebaseRemoteConfigBloc._({
    FastFirebaseRemoteConfigBlocState? initialState,
  }) : super(initialState: initialState ?? FastFirebaseRemoteConfigBlocState());

  factory FastFirebaseRemoteConfigBloc({
    FastFirebaseRemoteConfigBlocState? initialState,
  }) {
    _singleton ??= FastFirebaseRemoteConfigBloc._(initialState: initialState);

    return _singleton!;
  }

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
        await remoteConfig.setDefaults(defaultConfig);
      }

      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        minimumFetchInterval: const Duration(hours: 1),
        fetchTimeout: const Duration(minutes: 1),
      ));

      // TODO: listen on config changes ?
      final enabled = await remoteConfig.fetchAndActivate();

      if (enabled) {
        final config = remoteConfig.getAll();
        await _updateAppFeatures(config);
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
            debugLog('enabling feature: $featureKey', debugLabel: debugLabel);
            featureToEnable.add(feature);
          } else {
            debugLog('disabling feature: $featureKey', debugLabel: debugLabel);
            featureToDisable.add(feature);
          }
        } catch (e) {
          debugLog('unknown feature: $featureKey', debugLabel: debugLabel);
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
