// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_firebase/fastyle_firebase.dart';

class FastFirebaseRemoteConfigBlocEvent extends BlocEvent<
    FastFirebaseRemoteConfigBlocEventType,
    FastFirebaseRemoteConfigBlocEventPayload> {
  const FastFirebaseRemoteConfigBlocEvent({
    required FastFirebaseRemoteConfigBlocEventType super.type,
    super.payload,
  });

  FastFirebaseRemoteConfigBlocEvent.init({Map<String, dynamic>? defaultConfig})
      : super(
          type: FastFirebaseRemoteConfigBlocEventType.init,
          payload: FastFirebaseRemoteConfigBlocEventPayload(
            defaultConfig: defaultConfig,
          ),
        );

  FastFirebaseRemoteConfigBlocEvent.initialized({bool enabled = false})
      : super(
          type: FastFirebaseRemoteConfigBlocEventType.initialized,
          payload: FastFirebaseRemoteConfigBlocEventPayload(enabled: enabled),
        );
}
