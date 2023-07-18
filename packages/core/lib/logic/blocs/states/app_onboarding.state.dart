// Package imports:
import 'package:tbloc/tbloc.dart';

/// The [FastAppOnboardingBlocState] class is the state of the
/// [FastAppOnboardingBloc].
///
/// It contains the current onboarding state of the application.
class FastAppOnboardingBlocState extends BlocState {
  /// The index of the current onboarding step.
  final int currentStepIndex;

  /// Indicates whether the onboarding process has been completed.
  final bool isCompleted;

  /// Constructs a [FastAppOnboardingBlocState] with the provided parameters.
  FastAppOnboardingBlocState({
    super.isInitializing,
    super.isInitialized,
    int? currentStepIndex,
    bool? isCompleted,
  })  : currentStepIndex = currentStepIndex ?? 0,
        isCompleted = isCompleted ?? false;

  /// Creates a new [FastAppOnboardingBlocState] instance with updated
  /// properties.
  ///
  /// If a parameter is not provided, the corresponding property of the current
  /// instance is used instead.
  @override
  FastAppOnboardingBlocState copyWith({
    bool? isInitializing,
    bool? isInitialized,
    int? currentStepIndex,
    bool? isCompleted,
  }) =>
      FastAppOnboardingBlocState(
        isInitializing: isInitializing ?? this.isInitializing,
        isInitialized: isInitialized ?? this.isInitialized,
        currentStepIndex: currentStepIndex ?? this.currentStepIndex,
        isCompleted: isCompleted ?? this.isCompleted,
      );

  /// Creates a new [FastAppOnboardingBlocState] instance with the same property
  /// values as the current instance.
  @override
  FastAppOnboardingBlocState clone() => copyWith();

  /// Merges the properties of the provided [model] into a new
  /// [FastAppOnboardingBlocState] instance.
  @override
  FastAppOnboardingBlocState merge(covariant FastAppOnboardingBlocState model) {
    return copyWith(
      isInitializing: model.isInitializing,
      isInitialized: model.isInitialized,
      currentStepIndex: model.currentStepIndex,
      isCompleted: model.isCompleted,
    );
  }

  /// Returns a list of properties used to determine equality between instances.
  @override
  List<Object?> get props => [
        isInitializing,
        isInitialized,
        currentStepIndex,
        isCompleted,
      ];
}
