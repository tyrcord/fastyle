import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:tstore/tstore.dart';

/// A [TDocumentDataProvider] that provides a way to persist and retrieve
/// [FastUserSettingsDocument] objects.
class FastUserSettingsDataProvider extends TDocumentDataProvider {
  FastUserSettingsDataProvider({
    super.storeName = kFastUserSettingStoreName,
  });

  /// Retrieves the user settings document.
  Future<FastUserSettingsDocument> retrieveUserSettings() async {
    final raw = await store.toMap();

    if (raw.isNotEmpty) {
      return FastUserSettingsDocument.fromJson(raw);
    }

    return const FastUserSettingsDocument();
  }

  /// Persists the user settings document.
  Future<void> persistUserSettings(FastUserSettingsDocument entity) {
    return persistDocument(entity);
  }
}
