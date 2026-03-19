import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../product/domain/entities/product_entities.dart';
import '../repositories/search_repository.dart';

class SearchProducts {
  const SearchProducts(this._repository);

  final SearchRepository _repository;

  Future<Either<Failure, List<ProductSummary>>> call(String query) {
    return _repository.searchProducts(query);
  }
}
