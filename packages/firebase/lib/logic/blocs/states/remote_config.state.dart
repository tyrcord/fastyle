// Package imports:
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:tbloc/tbloc.dart';

class FastFirebaseRemoteConfigBlocState extends BlocState {
  final FirebaseRemoteConfig? config;
  final bool isEnabled;

  FastFirebaseRemoteConfigBlocState({
    super.isInitializing = false,
    super.isInitialized = false,
    super.error,
    bool? isEnabled,
    this.config,
  }) : isEnabled = isEnabled ?? false;

  @override
  FastFirebaseRemoteConfigBlocState copyWith({
    FirebaseRemoteConfig? config,
    bool? isInitializing,
    bool? isInitialized,
    bool? isEnabled,
    dynamic error,
  }) {
    return FastFirebaseRemoteConfigBlocState(
      isInitializing: isInitializing ?? this.isInitializing,
      isInitialized: isInitialized ?? this.isInitialized,
      isEnabled: isEnabled ?? this.isEnabled,
      config: config ?? this.config,
      error: error,
    );
  }

  @override
  FastFirebaseRemoteConfigBlocState clone() => copyWith();

  @override
  FastFirebaseRemoteConfigBlocState merge(
    covariant FastFirebaseRemoteConfigBlocState model,
  ) {
    return FastFirebaseRemoteConfigBlocState(
      isInitializing: model.isInitializing,
      isInitialized: model.isInitialized,
      isEnabled: model.isEnabled,
      config: model.config,
      error: model.error,
    );
  }

  @override
  List<Object?> get props => [
        isInitializing,
        isInitialized,
        isEnabled,
        config,
      ];
}
