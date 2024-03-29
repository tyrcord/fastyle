// Package imports:
import 'package:collection/collection.dart' show IterableExtension;
import 'package:tstore/tstore.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppDictDataProvider extends TDataProvider {
  FastAppDictDataProvider({
    String? storeName,
  }) : super(storeName: storeName ?? kFastAppDictStoreName);

  Future<List<FastDictEntryEntity>> listAllEntries() async {
    final rawList = await store.list<Map<dynamic, dynamic>>();

    return rawList.map((Map<dynamic, dynamic> raw) {
      final json = Map<String, dynamic>.from(raw);

      return FastDictEntryEntity.fromJson(json);
    }).toList();
  }

  Future<void> persistEntry(FastDictEntryEntity model) async {
    return store.persistEntity(model.name, model);
  }

  Future<FastDictEntryEntity?> findEntryByName(String name) async {
    final entries = await listAllEntries();

    return entries.firstWhereOrNull(
      (FastDictEntryEntity model) => model.name == name,
    );
  }

  Future<void> persistEntries(List<FastDictEntryEntity> models) async {
    final entries = models.map((model) => MapEntry(model.name, model.toJson()));

    return store.persistAll(Map.fromEntries(entries));
  }

  Future<void> deleteEntries(List<FastDictEntryEntity> entries) {
    final names = entries.map((e) => e.name).toList();

    return store.deleteAll(names);
  }

  Future<void> deleteAllEntries() async {
    return store.clear();
  }
}
