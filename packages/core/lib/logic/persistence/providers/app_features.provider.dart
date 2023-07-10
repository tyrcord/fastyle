import 'package:collection/collection.dart' show IterableExtension;
import 'package:fastyle_core/fastyle_core.dart';
import 'package:tstore/tstore.dart';

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

  Future<FastFeatureEntity?> findFeatureByName(String name) async {
    final features = await listAllFeatures();

    return features.firstWhereOrNull(
      (FastFeatureEntity model) => model.name == name,
    );
  }
}
