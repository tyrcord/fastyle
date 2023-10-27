// Package imports:
import 'package:tstore/tstore.dart';

/// The app onboarding document.
class FastAppOnboardingDocument extends TDocument {
  /// Indicates whether the onboarding process has been completed.
  final bool isCompleted;

  /// Creates an instance of [FastAppOnboardingDocument].
  const FastAppOnboardingDocument({
    this.isCompleted = false,
  });

  /// Creates an instance of [FastAppOnboardingDocument] from a JSON map.
  factory FastAppOnboardingDocument.fromJson(Map<String, dynamic> json) {
    return FastAppOnboardingDocument(
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'isCompleted': isCompleted,
      ...super.toJson(),
    };
  }

  @override
  FastAppOnboardingDocument copyWith({
    bool? isCompleted,
  }) {
    return FastAppOnboardingDocument(
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  FastAppOnboardingDocument merge(covariant FastAppOnboardingDocument model) {
    return copyWith(
      isCompleted: model.isCompleted,
    );
  }

  @override
  FastAppOnboardingDocument clone() => copyWith();

  @override
  List<Object?> get props => [
        isCompleted,
      ];
}
