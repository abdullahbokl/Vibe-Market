import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../product/domain/entities/product_entities.dart';
import '../repositories/search_repository.dart';

class BrowseProducts {
  const BrowseProducts(this._repository);

  final SearchRepository _repository;

  Future<Either<Failure, List<ProductSummary>>> call({
    required int offset,
    required int limit,
  }) {
    return _repository.browseProducts(offset: offset, limit: limit);
  }
}
