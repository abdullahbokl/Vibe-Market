import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../product/domain/entities/product_entities.dart';

abstract class FeedRepository {
  Future<Either<Failure, List<ProductSummary>>> getFeaturedFeed();
}
