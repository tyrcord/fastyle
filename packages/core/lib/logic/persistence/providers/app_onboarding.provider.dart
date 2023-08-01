// Package imports:
import 'package:tstore/tstore.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// A [TDocumentDataProvider] that provides a way to persist and retrieve
/// [FastAppOnboardingDocument] objects.
class FastAppOnboardingDataProvider extends TDocumentDataProvider {
  FastAppOnboardingDataProvider({
    super.storeName = kFastAppOnboardingStoreName,
  });

  /// Retrieves the onboarding document.
  Future<FastAppOnboardingDocument> retrieveOnboarding() async {
    final raw = await store.toMap();

    if (raw.isNotEmpty) {
      return FastAppOnboardingDocument.fromJson(raw);
    }

    return const FastAppOnboardingDocument();
  }

  /// Persists the onboarding document.
  Future<void> persistOnboarding(FastAppOnboardingDocument entity) {
    return persistDocument(entity);
  }
}
