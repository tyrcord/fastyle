import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:tstore/tstore.dart';

/// A [TDocumentDataProvider] that provides a way to persist and retrieve
/// [FastSettingsDocument] objects.
class FastSettingsDataProvider extends TDocumentDataProvider {
  FastSettingsDataProvider({
    super.storeName = kFastSettingStoreName,
  });

  /// Retrieves the settings document.
  Future<FastSettingsDocument> retrieveSettings() async {
    final raw = await store.toMap();

    if (raw.isNotEmpty) {
      return FastSettingsDocument.fromJson(raw);
    }

    return const FastSettingsDocument();
  }

  /// Persists the settings document.
  Future<void> persistSettings(FastSettingsDocument entity) {
    return persistDocument(entity);
  }
}
