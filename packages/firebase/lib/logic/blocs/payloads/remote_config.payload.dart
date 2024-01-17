class FastFirebaseRemoteConfigBlocEventPayload {
  final Map<String, dynamic>? defaultConfig;
  final bool? activated;

  FastFirebaseRemoteConfigBlocEventPayload({
    this.activated,
    this.defaultConfig,
  });
}
