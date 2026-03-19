import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/services/supabase_gateway.dart';
import '../../../product/data/datasources/catalog_seed_data_source.dart';
import '../../../product/data/models/product_serializers.dart';
import '../../../product/data/mappers/remote_product_summary_mapper.dart';
import '../../../product/domain/entities/product_entities.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_cache_data_source.dart';
import '../datasources/search_remote_data_source.dart';

class HybridSearchRepository implements SearchRepository {
  HybridSearchRepository({
    required CatalogSeedDataSource dataSource,
    required SearchCacheDataSource cacheDataSource,
    required SupabaseGateway gateway,
  }) : _dataSource = dataSource,
       _cache = cacheDataSource,
       _gateway = gateway;

  final CatalogSeedDataSource _dataSource;
  final SearchCacheDataSource _cache;
  final SupabaseGateway _gateway;

  @override
  Future<Either<Failure, List<ProductSummary>>> browseProducts({
    required int offset,
    required int limit,
  }) async {
    final String cacheKey = _browseCacheKey(offset: offset, limit: limit);
    final List<ProductSummary> cached = _cache.read(cacheKey);
    if (cached.isNotEmpty) {
      return right(cached);
    }

    final SearchRemoteDataSource? remote = _remoteDataSource;
    if (remote != null) {
      try {
        final List<ProductSummary> parsed = (await remote.browseProducts(
          offset: offset,
          limit: limit,
        )).map(mapRemoteProductSummary).whereType<ProductSummary>().toList();
        await _cache.write(cacheKey, parsed);
        return right(parsed);
      } catch (_) {
        // Fall back to local browsing when Supabase is unavailable.
      }
    }

    final List<ProductSummary> local = _dataSource.listSummaries().skip(offset).take(limit).toList();
    await _cache.write(cacheKey, local);
    return right(local);
  }

  @override
  Future<Either<Failure, List<ProductSummary>>> searchProducts(String query) async {
    final String normalized = query.trim();
    if (normalized.isEmpty) {
      return const Right<Failure, List<ProductSummary>>(<ProductSummary>[]);
    }

    final String cacheKey = _queryCacheKey(normalized);
    final List<ProductSummary> cached = _cache.read(cacheKey);
    if (cached.isNotEmpty) {
      return right(cached);
    }

    final SearchRemoteDataSource? remote = _remoteDataSource;
    if (remote != null) {
      try {
        final Object? data = (await remote.semanticSearch(normalized)).data;
        final List<ProductSummary> parsed = _parseSemanticResponse(data);
        if (parsed.isNotEmpty) {
          await _cache.write(cacheKey, parsed);
          return right(parsed);
        }
      } catch (_) {
        // Fall back to local ranking when the edge function is unavailable.
      }
    }

    final List<ProductSummary> local = _dataSource.search(normalized);
    await _cache.write(cacheKey, local);
    return right(local);
  }

  SearchRemoteDataSource? get _remoteDataSource {
    final client = _gateway.client;
    return client == null ? null : SearchRemoteDataSource(client);
  }

  List<ProductSummary> _parseSemanticResponse(Object? data) {
    final Object? payload = data is Map<String, dynamic> ? data['items'] ?? data['results'] : data;
    if (payload is! List<dynamic>) {
      return const <ProductSummary>[];
    }
    return payload
        .whereType<Map<dynamic, dynamic>>()
        .map((Map<dynamic, dynamic> item) => ProductSerializers.summaryFromMap(
              Map<String, dynamic>.from(item),
            ))
        .whereType<ProductSummary>()
        .toList();
  }

  String _queryCacheKey(String query) => 'search::${query.toLowerCase()}';

  String _browseCacheKey({required int offset, required int limit}) =>
      'search::browse::$offset::$limit';
}
