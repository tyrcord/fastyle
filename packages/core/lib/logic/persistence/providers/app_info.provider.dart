// Package imports:
import 'package:tstore/tstore.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppInfoDataProvider extends TDocumentDataProvider {
  FastAppInfoDataProvider({
    String? storeName,
  }) : super(storeName: storeName ?? kFastAppInfoStoreName);

  Future<FastAppInfoDocument> retrieveAppInfo() async {
    final raw = await store.toMap();

    if (raw.isNotEmpty) {
      return FastAppInfoDocument.fromJson(raw);
    }

    return const FastAppInfoDocument();
  }

  Future<void> persistAppInfo(FastAppInfoDocument appInfo) async {
    return persistDocument(appInfo);
  }
}
