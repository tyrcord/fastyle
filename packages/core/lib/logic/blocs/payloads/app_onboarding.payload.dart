/// The onboarding bloc event payload.
/// This payload is used to pass data to the onboarding bloc.
class FastAppOnboardingBlocEventPayload {
  /// Whether the onboarding process is completed.
  final bool isCompleted;

  const FastAppOnboardingBlocEventPayload({
    this.isCompleted = false,
  });
}
