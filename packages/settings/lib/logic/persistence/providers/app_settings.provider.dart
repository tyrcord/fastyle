import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:tstore/tstore.dart';

/// A [TDocumentDataProvider] that provides a way to persist and retrieve
/// [FastAppSettingsDocument] objects.
class FastAppSettingsDataProvider extends TDocumentDataProvider {
  FastAppSettingsDataProvider({
    super.storeName = kFastSettingStoreName,
  });

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
