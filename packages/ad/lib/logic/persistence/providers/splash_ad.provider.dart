// Package imports:
import 'package:tstore/tstore.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

/// A [TDocumentDataProvider] that provides a way to persist and retrieve
/// [FastSplashAdDocument] objects.
class FastSplashAdDataProvider extends TDocumentDataProvider {
  FastSplashAdDataProvider({
    super.storeName = kFastSplashAdStoreName,
  });

  /// Retrieves the document.
  Future<FastSplashAdDocument> retrieveSplashAdDocument() async {
    final raw = await store.toMap();

    if (raw.isNotEmpty) {
      return FastSplashAdDocument.fromJson(raw);
    }

    return const FastSplashAdDocument();
  }

  /// Persists the document.
  Future<void> persistSplashAdDocument(FastSplashAdDocument entity) {
    return persistDocument(entity);
  }
}
