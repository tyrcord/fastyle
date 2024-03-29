// Package imports:
import 'package:tstore/tstore.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// A [TDocumentDataProvider] that provides a way to persist and retrieve
/// [FastAppSettingsDocument] objects.
class FastAppSettingsDataProvider extends TDocumentDataProvider {
  FastAppSettingsDataProvider({super.storeName = kFastAppSettingStoreName});

  /// Retrieves the settings document.
  Future<FastAppSettingsDocument> retrieveSettings() async {
    final raw = await store.toMap();

    if (raw.isNotEmpty) {
      return FastAppSettingsDocument.fromJson(raw);
    }

    return const FastAppSettingsDocument();
  }

  /// Persists the settings document.
  Future<void> persistSettings(FastAppSettingsDocument entity) {
    return persistDocument(entity);
  }
}
