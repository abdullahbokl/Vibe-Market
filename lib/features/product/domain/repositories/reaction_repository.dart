import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/product_entities.dart';

abstract class ReactionRepository {
  Future<Either<Failure, ReactionSnapshot>> getSnapshot(String productId);

  Future<Either<Failure, ReactionSnapshot>> toggleReaction(String productId);

  Stream<Either<Failure, ReactionSnapshot>> watchSnapshot(String productId);
}
