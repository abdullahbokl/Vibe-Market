import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/product_entities.dart';

abstract class ProductRepository {
  Future<Either<Failure, ProductDetail>> getProductById(String productId);

  Future<Either<Failure, List<ProductSummary>>> getProductsByIds(
    List<String> productIds,
  );
}
