import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../product/domain/entities/product_entities.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<ProductSummary>>> searchProducts(String query);

  Future<Either<Failure, List<ProductSummary>>> browseProducts({
    required int offset,
    required int limit,
  });
}
