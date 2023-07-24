// Package imports:
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_firebase/fastyle_firebase.dart';

class FastFirebaseRemoteConfigBloc extends BidirectionalBloc<
    FastFirebaseRemoteConfigBlocEvent, FastFirebaseRemoteConfigBlocState> {
  static FastFirebaseRemoteConfigBloc? _singleton;

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
}
