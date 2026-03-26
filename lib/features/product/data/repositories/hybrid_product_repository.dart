import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/services/supabase_gateway.dart';
import '../datasources/catalog_seed_data_source.dart';
import '../datasources/remote_product_data_source.dart';
import '../mappers/remote_product_detail_mapper.dart';
import '../mappers/remote_product_summary_mapper.dart';
import '../../domain/entities/product_entities.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_repository_utils.dart';

class HybridProductRepository with ProductRepositoryUtils implements ProductRepository {
  HybridProductRepository({
    required CatalogSeedDataSource dataSource,
    required SupabaseGateway gateway,
  }) : _dataSource = dataSource,
       _gateway = gateway;

  final CatalogSeedDataSource _dataSource;
  final SupabaseGateway _gateway;

  @override
  Future<Either<Failure, ProductDetail>> getProductById(String productId) async {
    final ProductDetail? localProduct = _dataSource.getById(productId);
    if (localProduct != null) return right(localProduct);

    final RemoteProductDataSource? remote = _remoteDataSource(productId);
    if (remote == null) return notFound();

    try {
      final Map<String, dynamic>? response = await remote.fetchProductById(productId);
      final ProductDetail? product = response == null ? null : mapRemoteProductDetail(response);
      return product == null ? notFound() : right(product);
    } on PostgrestException catch (error) {
      return error.code == 'PGRST116' ? notFound() : networkFailure();
    } catch (_) {
      return networkFailure();
    }
  }

  @override
  Future<Either<Failure, List<ProductSummary>>> getProductsByIds(List<String> productIds) async {
    final List<ProductSummary> results = <ProductSummary>[];
    final Set<String> remainingIds = productIds.toSet();
    final RemoteProductDataSource? remote = _remoteDataSourceForList(productIds);
    if (remote != null) await _appendRemoteResults(remote, remainingIds, results);
    _appendLocalResults(remainingIds, results);
    return right(orderProducts(productIds, results));
  }

  Future<void> _appendRemoteResults(
    RemoteProductDataSource remote,
    Set<String> remainingIds,
    List<ProductSummary> results,
  ) async {
    try {
      final List<String> remoteIds = remainingIds.where(looksLikeUuid).toList();
      final List<Map<String, dynamic>> response = await remote.fetchProductsByIds(remoteIds);
      for (final Map<String, dynamic> item in response) {
        final ProductSummary? summary = mapRemoteProductSummary(item);
        if (summary != null) {
          results.add(summary);
          remainingIds.remove(summary.id);
        }
      }
    } catch (_) {}
  }

  void _appendLocalResults(Set<String> remainingIds, List<ProductSummary> results) {
    if (remainingIds.isEmpty) return;
    results.addAll(_dataSource.listSummaries().where((p) => remainingIds.contains(p.id)));
  }

  RemoteProductDataSource? _remoteDataSource(String productId) {
    final client = _gateway.client;
    if (client == null || !looksLikeUuid(productId)) return null;
    return RemoteProductDataSource(client);
  }

  RemoteProductDataSource? _remoteDataSourceForList(List<String> productIds) {
    final client = _gateway.client;
    if (client == null || !productIds.any(looksLikeUuid)) return null;
    return RemoteProductDataSource(client);
  }
}
