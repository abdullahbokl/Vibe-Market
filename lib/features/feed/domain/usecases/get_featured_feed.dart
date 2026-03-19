import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../product/domain/entities/product_entities.dart';
import '../repositories/feed_repository.dart';

class GetFeaturedFeed {
  const GetFeaturedFeed(this._repository);

  final FeedRepository _repository;

  Future<Either<Failure, List<ProductSummary>>> call() {
    return _repository.getFeaturedFeed();
  }
}
