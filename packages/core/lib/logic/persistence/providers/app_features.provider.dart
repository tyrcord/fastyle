// Package imports:
import 'package:collection/collection.dart' show IterableExtension;
import 'package:tstore/tstore.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppFeaturesDataProvider extends TDataProvider {
  FastAppFeaturesDataProvider({
    String? storeName,
  }) : super(storeName: storeName ?? kFastAppFeaturesStoreName);

  Future<List<FastFeatureEntity>> listAllFeatures() async {
    final rawList = await store.list<Map<dynamic, dynamic>>();

    return rawList.map((Map<dynamic, dynamic> raw) {
      final json = Map<String, dynamic>.from(raw);

      return FastFeatureEntity.fromJson(json);
    }).toList();
  }

  Future<void> persistFeature(FastFeatureEntity model) async {
    return store.persist(model.name, model.toJson());
  }

  Future<void> enableFeature(FastFeatureEntity model) async {
    return persistFeature(model.copyWith(isEnabled: true, isActivated: true));
  }

  Future<void> disableFeature(FastFeatureEntity model) async {
    return persistFeature(model.copyWith(isEnabled: false, isActivated: false));
  }

  Future<void> enableFeatures(List<FastFeatureEntity> models) async {
    await Future.wait(models.map((model) => enableFeature(model)));
  }

  Future<void> disableFeatures(List<FastFeatureEntity> models) async {
    await Future.wait(models.map((model) => disableFeature(model)));
  }

  Future<FastFeatureEntity?> findFeatureByName(String name) async {
    final features = await listAllFeatures();

    return features.firstWhereOrNull(
      (FastFeatureEntity model) => model.name == name,
    );
  }
}
