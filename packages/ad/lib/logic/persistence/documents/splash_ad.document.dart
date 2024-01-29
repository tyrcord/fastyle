// Package imports:
import 'package:tstore/tstore.dart';

/// The app onboarding document.
class FastSplashAdDocument extends TDocument {
  final DateTime? lastImpressionDate;

  /// Creates an instance of [FastSplashAdDocument].
  const FastSplashAdDocument({
    this.lastImpressionDate,
  });

  /// Creates an instance of [FastSplashAdDocument] from a JSON map.
  factory FastSplashAdDocument.fromJson(Map<String, dynamic> json) {
    final String? lastImpressionDateString =
        json['lastImpressionDate'] as String?;

    DateTime? lastImpressionDate;

    if (lastImpressionDateString != null) {
      lastImpressionDate = DateTime.parse(lastImpressionDateString);
    }

    return FastSplashAdDocument(
      lastImpressionDate: lastImpressionDate,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'lastImpressionDate': lastImpressionDate?.toIso8601String(),
      ...super.toJson(),
    };
  }

  @override
  FastSplashAdDocument copyWith({
    DateTime? lastImpressionDate,
  }) {
    return FastSplashAdDocument(
      lastImpressionDate: lastImpressionDate ?? this.lastImpressionDate,
    );
  }

  @override
  FastSplashAdDocument merge(covariant FastSplashAdDocument model) {
    return copyWith(
      lastImpressionDate: model.lastImpressionDate,
    );
  }

  @override
  FastSplashAdDocument clone() => copyWith();

  @override
  List<Object?> get props => [lastImpressionDate];
}
