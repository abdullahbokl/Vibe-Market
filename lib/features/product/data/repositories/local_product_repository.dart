import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../datasources/catalog_seed_data_source.dart';
import '../../domain/entities/product_entities.dart';
import '../../domain/repositories/product_repository.dart';

class LocalProductRepository implements ProductRepository {
  LocalProductRepository(this._dataSource);

  final CatalogSeedDataSource _dataSource;

  @override
  Future<Either<Failure, ProductDetail>> getProductById(
    String productId,
  ) async {
    final ProductDetail? product = _dataSource.getById(productId);
    if (product == null) {
      return const Left<Failure, ProductDetail>(
        Failure.notFound(
          'That product is no longer in the current drop window.',
        ),
      );
    }
    return right(product);
  }

  @override
  Future<Either<Failure, List<ProductSummary>>> getProductsByIds(
    List<String> productIds,
  ) async {
    final List<ProductSummary> items = _dataSource
        .listSummaries()
        .where((ProductSummary product) => productIds.contains(product.id))
        .toList();
    return right(items);
  }
}
