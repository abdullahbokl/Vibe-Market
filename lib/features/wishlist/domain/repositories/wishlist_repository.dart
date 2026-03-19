import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class WishlistRepository {
  Future<Either<Failure, Set<String>>> loadWishlistIds();

  Future<Either<Failure, Set<String>>> toggleWishlist({
    required String productId,
    required String userScope,
  });
}
