import '../../../../core/storage/app_cache_store.dart';
import '../../../product/data/models/product_serializers.dart';
import '../../../product/domain/entities/product_entities.dart';

class SearchCacheDataSource {
  const SearchCacheDataSource(this._cacheStore);

  final AppCacheStore _cacheStore;

  List<ProductSummary> read(String key) {
    final Map<String, dynamic>? cached = _cacheStore.readJson(key);
    final List<dynamic> items = cached?['items'] as List<dynamic>? ?? <dynamic>[];
    return items
        .whereType<Map<dynamic, dynamic>>()
        .map((Map<dynamic, dynamic> item) => ProductSerializers.summaryFromMap(
              Map<String, dynamic>.from(item),
            ))
        .toList();
  }

  Future<void> write(String key, List<ProductSummary> items) {
    return _cacheStore.putJson(key, <String, dynamic>{
      'storedAt': DateTime.now().toIso8601String(),
      'items': items.map(ProductSerializers.summaryToMap).toList(),
    });
  }
}
