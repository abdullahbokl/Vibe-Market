import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/storage/app_cache_store.dart';
import '../../../product/data/datasources/catalog_seed_data_source.dart';
import '../../../product/data/models/product_serializers.dart';
import '../../../product/domain/entities/product_entities.dart';
import '../../domain/repositories/feed_repository.dart';

class HybridFeedRepository implements FeedRepository {
  HybridFeedRepository({
    required CatalogSeedDataSource dataSource,
    required AppCacheStore cacheStore,
  }) : _dataSource = dataSource,
       _cacheStore = cacheStore;

  static const String _cacheKey = 'feed::featured';
  static const Duration _cacheTtl = Duration(minutes: 15);

  final CatalogSeedDataSource _dataSource;
  final AppCacheStore _cacheStore;

  @override
  Future<Either<Failure, List<ProductSummary>>> getFeaturedFeed() async {
    final Map<String, dynamic>? cached = _cacheStore.readJson(_cacheKey);
    if (cached != null) {
      final DateTime? storedAt = DateTime.tryParse(
        cached['storedAt'] as String? ?? '',
      );
      if (storedAt != null &&
          DateTime.now().difference(storedAt) <= _cacheTtl) {
        final List<dynamic> items =
            cached['items'] as List<dynamic>? ?? <dynamic>[];
        final List<ProductSummary> hydrated = items
            .whereType<Map<dynamic, dynamic>>()
            .map(
              (Map<dynamic, dynamic> item) => ProductSerializers.summaryFromMap(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();
        if (hydrated.isNotEmpty) {
          return right(hydrated);
        }
      }
    }

    final List<ProductSummary> products = _dataSource.listSummaries();
    await _cacheStore.putJson(_cacheKey, <String, dynamic>{
      'storedAt': DateTime.now().toIso8601String(),
      'items': products.map(ProductSerializers.summaryToMap).toList(),
    });
    return right(products);
  }
}
